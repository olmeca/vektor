import os, parseopt2, strutils, sequtils, json, future, streams, random, pegs, times, tables, logging
import "doctypes", "names", "qualifiers", "common"

type
   FieldSpec = object
      lineId: string
      leTypeId: string
      value: string
   
   FieldSpecError = object of Exception
   
   TCommand = enum
      cmdCopy, cmdQuery, cmdInfo, cmdHelp, cmdPrint

let helpText = """
   Vektor: a tool for analyzing and modifying Vektis EI declaration files.
   (c) 2017 Rudi Angela

   Usage: vektor <command> [<options>] [<input file>]

   It lets you specify an input file, a line element type and a value and then 
   creates a copy of the given file with all line elements of the given type 
   set to the specified value.
   -o:<output file> -e:<line element id>[=<new value>] [-e ...]
"""
const
   blanksSet: set[char] = { ' ' }
   cVektisDateFormat = "yyyyMMdd"

let
   elementSpecPattern = peg"""#
   Pattern <- ^ ElementSpec !.
   ElementSpec <-  {ElementId} '=' {ElementValue} / {ElementId}
   ElementId <- \d \d \d \d
   ElementValue <- .*
   """

   elementSpecsPattern = peg"""#
   Pattern <- ^ ElementsSpec !.
   ElementsSpec <- ElementSpec ElementSpecSeparator ElementsSpec / ElementSpec
   ElementSpec <- {(!ElementSpecSeparator .)+}
   ElementSpecSeparator <- ','
   """
   
   randomDatePattern = peg"""#
   Pattern <- ^ RandomDateSpec !.
   RandomDateSpec <- '@date:' {Date} '-' {Date}
   Date <- \d \d \d \d \d \d \d \d
   """

var 
   targetFieldsArg: string
   targetFields: seq[FieldSpec] = @[]
   filterFieldsArg: string
   outputPath: string = nil
   command: TCommand = cmdCopy
   commandArgs: seq[string] = @[]
   docType: DocumentType
   optVersion: int = -1
   optSubversion: int = -1
   commandWasRead: bool = false
   rootContext: Context = nil
   contextCursor: Context = nil
   # only lines of leaf line type or its parents
   # will trigger printing of previous leaf
   leafLineType: LineType
   argDocTypeName: string
   optLineId: string
   argSourceFilePath: string
   argDestFilePath: string
   lineQualifier: LineQualifier = nil
   qualifierString: string
   logLevel: string = nil

proc setLoggingLevel(level: Level) =
   let filePath = joinPath(getAppDir(), "vektor.log")
   var fileLogger = newFileLogger(filePath, fmtStr = verboseFmtStr)
   addHandler(fileLogger)
   setLogFilter(level)

proc description(doctype: DocumentType): string =
   "$# v$#.$#   $#" % [doctype.name, intToStr(doctype.formatVersion), intToStr(doctype.formatSubVersion), doctype.description]

proc toString(fs: FieldSpec): string = 
   "FieldSpec lId: $#, leId: $#, value: $#" % [fs.lineId, fs.leTypeId, fs.value]

proc toString(ctx: Context): string = 
   "Context[lt: $#]" % [ctx.lineType.lineId]

proc setLeafLineType(lineType: LineType) =
   debug("setLeafLineType: $#" % [lineType.lineId])
   leafLineType = lineType

proc createContext(line: string): Context =
   let lineType = docType.getLineTypeForFullLine(line)
   Context(lineType: linetype, line: line, subContexts: newTable[string, Context]())


proc isSubRecord(doctype: DocumentType, subject: LineType, reference: LineType): bool =
   if isNil(subject.parentLineId):
      result = false
   else:
      let parent = doctype.getLineTypeForLineId(subject.parentLineId)
      result = parent.lineId == reference.lineId or isSubRecord(doctype, parent, reference)
   debug("isSubRecord: lt: $#, ref: $# -> $#" % [subject.lineId, reference.lineId, repr(result)])

proc registerLineId(lineId: string) =
   let lineType = docType.getLineTypeForLineId(lineId)
   if docType.isSubRecord(lineType, leafLineType):
      setLeafLineType(lineType)
   else: discard

proc setCurrentContext(child: Context) =
   debug("setCurrentContext: lt: $#" % [child.lineType.lineId])
   if isNil(rootContext):
      debug("setCurrentContext: setting root.")
      rootContext = child
   else:
      debug("setCurrentContext: root exists: $#" % [rootContext.lineType.lineId])
      let parent = contextWithLineId(rootContext, child.lineType.parentLineId)
      parent.subContexts[child.lineType.lineId] = child
   contextCursor = child

proc setCurrentLine(line: string) =
   setCurrentContext(createContext(line))

proc parseVektisDate(dateString: string): TimeInfo =
   try:
      result = parse(dateString, cVektisDateFormat)
   except Exception:
      raise newException(ValueError, "Invalid date format: '$#'" % [dateString])

proc randomDateString(fromDate: string, toDate: string): string =
   let fromSeconds = parseVektisDate(fromDate).toTime().toSeconds()
   let toSeconds = parseVektisDate(toDate).toTime().toSeconds()
   let randomSeconds = random(toSeconds-fromSeconds) + fromSeconds
   let randomDate = fromSeconds(randomSeconds).getLocalTime()
   format(randomDate, cVektisDateFormat)
   

proc stripBlanks(source: string): string =
   strip(source, true, true, blanksSet)

proc fetch_doctype(line: string): DocumentType =
   let typeId = parseInt(line[2 .. 4])
   let version = parseInt(line[5 .. 6])
   let subversion = parseInt(line[7 .. 8])
   get_doctype(typeId, version, subversion)


proc writeToStream(buf: seq[char], stream: Stream) = 
   for c in buf:
      stream.write(c)
   stream.write('\r')
   stream.write('\l')

proc mytrim(value: string, length: int): string = 
   result = if value.len > length: value[0..length-1] else: value
   
proc elementValue(leType: LineElementType, value: string): string = 
   debug("elementValue: leType: $#, value='$#', length=$#" % [leType.lineElementId, (if isNil(value): "<nil>" else: value), intToStr(leType.length)])
   let length = leType.length
   if leType.fieldType == "N":
      var number: int
      if leType.isDate and value =~ randomDatePattern:
         result = randomDateString(matches[0], matches[1])
      else:
         number = if isNil(value): 0 else: parseInt(mytrim(value, length))
         result = intToStr(number, length)
   else:
      var alphanum: string = nil
      if value == "@name":
         alphanum = get_random()
      else:
         alphanum = if isNil(value): "" else: mytrim(stripBlanks(value), length)
      result = alphanum & spaces(length - alphanum.len)
   debug("elementValue -> '$#', $#" % [result, intToStr(result.len)])

proc mutate(fieldSpec: FieldSpec, line: string, buf: var openArray[char]) =
   let lineLineId = line[0..1]
   if fieldSpec.lineId == lineLineId:
      let leType = getLineElementType(docType, fieldSpec.leTypeId)
      let start: int = leType.startPosition-1
      let length = leType.length
      var newValue = elementValue(leType, fieldSpec.value)
      assert newValue.len == length
      let newValueSeq = toSeq(newValue.items)
      # Nim range is inclusive
      for i in 0..(length-1):
         buf[start+i] = newValueSeq[i]

proc padright(source: string, length: int, fillChar: char = ' '): string =
   source & repeat(fillChar, length - source.len)

proc getFieldValueFullString(fSpec: FieldSpec): string =
   debug("getFieldValueFullString: " & fSpec.leTypeId) 
   result = rootContext.getElementValueFullString(fSpec.leTypeId)

proc conditionIsMet(): bool =
   if isNil(lineQualifier):
      result = true
   else:
      try:
         result = lineQualifier.qualifies(rootContext)
      except NotFoundError:
         result = false

proc isLeafLine(line: string): bool =
   let lineId = line[0..1]
   result = leafLineType.lineId == lineId
   debug("isLeafLine: $# -> $#" % [lineId, repr(result)])

proc printLine(line: string) = 
   if line.isLeafLine() and conditionIsMet():
      stdout.write("| ")
      for field in targetFields:
         stdout.write(getFieldValueFullString(field))
         stdout.write(" | ")
      stdout.write("\n")

proc mutateAndWrite(line: var string, outStream: Stream) =
   var buf = toSeq(line.mitems)
   if conditionIsMet():
      for field in targetFields:
         mutate(field, line, buf)
   writeToStream(buf, outStream)


proc isSelected(dt: DocumentType): bool =
   (isNil(argDocTypeName) or dt.name.startsWith(argDocTypeName)) and (optVersion == -1 or optVersion == dt.formatVersion) and (optSubversion == -1 or optSubversion == dt.formatSubVersion)

proc selectDocTypes(): seq[DocumentType] =
   result = filter(allDocumentTypes(), isSelected)

proc showDocumentTypes() =
   for doctype in selectDocTypes():
      echo description(doctype)

#proc printDocumentTypesCode(out: Stream) =
#   for doctype in get_all_doctypes():
#      printCode( doctype,out)

proc showLineTypeInfo(doctype: DocumentType, ltId: string) =
   let lt = doctype.getLineTypeForLineId(ltId)
   echo description(doctype), ": ", lt.name
   echo "ID     V-code    Pos    Len   Type   Description"
   for et in lt.lineElementTypes:
      echo "$#   $#   $#   $#   $#   $#" % [et.lineElementId, et.code, intToStr(et.startPosition, 4), intToStr(et.length, 4), padright(et.fieldType, 4), et.description]

proc showDocumentTypeInfo(doctype: DocumentType) =
   echo description(doctype)
   echo "ID   Len   Description"
   for lineType in doctype.lineTypes:
      echo "$#   $#   $#" % [lineType.lineId, intToStr(lineType.length,3), lineType.name]

proc isVersionMissing(): bool = optVersion == -1 and optSubversion == -1

proc showInfo() =
   if isNil(argDocTypeName) or isVersionMissing():
      showDocumentTypes()
   else:
      let doctype = documentTypeMatching(argDocTypeName.toUpper(), optVersion, optSubversion)
      if isNil(optLineId):
         showDocumentTypeInfo(doctype)
      else:
         showLineTypeInfo(doctype, optLineId)

proc readVersion(versionString: string) =
   if isNil(versionString) or versionString.len == 0:
      quit("Invalid version format specified: '$#'" % [versionString])
   else:
      let items = versionString.split('.')
      if not isDigit(items[0]):
         quit("Invalid version format specified: '$#'" % [versionString])
      else:
         optVersion = parseInt(items[0])
      if items.len > 1:
         if not isDigit(items[1]):
            quit("Invalid version format specified: '$#'" % [versionString])
         else:
            optSubversion = parseInt(items[1])

proc showHelp() =
   echo helpText

proc readLogLevel(level: string): Level =
   case level
   of "debug":
      result = lvlDebug
   of "info":
      result = lvlInfo
   of "warn":
      result = lvlWarn
   of "error":
      result = lvlError
   else: 
      quit("Unknown logging level: " & level)

proc readCommand(cmdString: string) =
   case cmdString
   of "info":
      command = cmdInfo
   of "show":
      command = cmdQuery
   of "copy":
      command = cmdCopy
   of "help":
      command = cmdHelp
   of "print":
      command = cmdPrint
   else:
      quit("Please specify one of the following commands: info, show, copy or help.")
   commandWasRead = true

proc readElementSpec(spec: string): FieldSpec =
   if spec =~ elementSpecPattern:
      let leTypeId = matches[0]
      let value = matches[1]
      let lineId = leTypeId[0..1]
      registerLineId(lineId)
      result = FieldSpec(lineId: lineId, leTypeId: leTypeId, value: value)
   else:
      raise newException(FieldSpecError, "Invalid line element specification: $#" % [spec])

proc readFieldSpecs(value: string, fields: var seq[FieldSpec], argName: string) = 
   if commandWasRead:
      if value =~ elementSpecsPattern:
         fields = lc[readElementSpec(s)|(s <- matches, not isNil(s)), FieldSpec]
      else:
         quit("Invalid elements specification in argument ($#)." % [argName])
   else:
      quit("Command is missing.")

randomize()

proc checkCommandArgs(minCount: int, errorMessage: string) =
   if commandArgs.len < minCount:
      quit(errorMessage)

proc readCommandArgument(arg: string) =
   commandArgs.add(arg)

proc processCommandArgs() =
   if command == cmdInfo:
      if commandArgs.len > 0:
         argDocTypeName = commandArgs[0]
         if optVersion == 0:
            quit("For information on a document type you also need to specify a version (e.g. -v:1.0)")
         else: discard
      else: discard
   elif command == cmdCopy:
      checkCommandArgs(2, "You need to specify a source file and a destination file (e.g: vektor copy source.asc dest.asc -e:...).")
      argSourceFilePath = commandArgs[0]
      argDestFilePath = commandArgs[1]
   elif command == cmdQuery:
      argSourceFilePath = commandArgs[0]
   else: discard

for kind, key, value in getopt():
   case kind
   of cmdLongoption, cmdShortOption:
      case key 
      of "d", "debug-level":
         logLevel = value
      of "e", "elements":
         targetFieldsArg = value
      of "f", "filter":
         filterFieldsArg = value
      of "l", "lineid":
         optLineId = value
      of "o", "outputPath":
         outputPath = value
      of "v", "version":
         readVersion(value)
      of "c", "condition":
         qualifierString = value
   of cmdArgument:
      if commandWasRead:
         readCommandArgument(key)
      else:
         readCommand(key)
   of cmdEnd: assert(false) # cannot happen

if not isNil(logLevel):
   setLoggingLevel(readLogLevel(logLevel))
else: discard
readDocumentTypes()
processCommandArgs()

if not commandWasRead:
   showHelp()
elif command == cmdHelp:
   showHelp()
elif command == cmdInfo:
   showInfo()
elif command == cmdPrint:
   echo "Print command not supported yet"
   # printDocumentTypesCode(stdout)
else:
   if not existsFile(argSourceFilePath):
      quit("Specified source file not found: $#" % [argSourceFilePath])
   elif isNil(targetFieldsArg) or targetFieldsArg.len == 0:
      quit("You need to specify line elements (-e:0203,0207 or --elements 0203,0207 )")
   else:
      let input = newFileStream(argSourceFilePath, fmRead)
      var line: string = ""
      if input.readLine(line):
         if line.startswith("01"):
            try:
               docType = fetch_doctype(line)
               if not isNil(qualifierString):
                  lineQualifier = docType.parseQualifier(qualifierString)
               else: discard
               let lineType = docType.getLineTypeForLineId("01")
               setCurrentLine(line)
               setLeafLineType(lineType)
               echo ("Document type: $#" % [description(docType)])
               readFieldSpecs(targetFieldsArg, targetFields, "-e, --elements")
               if command == cmdCopy:
                  var outStream: Stream = newFileStream(argDestFilePath, fmWrite)
                  if not isNil(outStream):
                     mutateAndWrite(line, outStream)
                     while input.readLine(line):
                        setCurrentLine(line)
                        mutateAndWrite(line, outStream)
                     outStream.close()
                  else:
                     quit("Could not create file '$#'" % [outputPath])
               elif command == cmdQuery:
                  printLine(line)
                  while input.readLine(line):
                     setCurrentLine(line)
                     printLine(line)
               else:
                  quit("Unknown command.")
            except Exception:
               quit(getCurrentExceptionMsg())
         else:
            quit("File is not a Vektis format (first two characters should be 01)")
      input.close
   

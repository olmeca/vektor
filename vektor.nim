import os, parseopt2, strutils, sequtils, json, future, streams, random, pegs, times, tables
import "doctypes", "names", "qualifiers"

type
   FieldSpec = object
      lineId: string
      leTypeId: string
      value: string
   
   FieldSpecError = object of Exception
   NotFoundError = object of Exception
   
   TCommand = enum
      cmdCopy, cmdQuery, cmdInfo, cmdHelp, cmdPrint

   TRecordRef = ref object
      lineType: LineType
      line: string
      sublines: TableRef[string, TRecordRef]
      

let helpText = """
   Vektor: a tool for analyzing and modifying Vektis EI declaration files.
   (c) 2017 Rudi Angela

   Usage: vektor <command> [<options>] [<input file>]

   It lets you specify an input file, a line element type and a value and then 
   creates a copy of the given file with all line elements of the given type 
   set to the specified value.
   -o:<output file> -e:<line element id>[=<new value>] [-e ...]
"""
let 
   blanksSet: set[char] = { ' ' }
   kVektisDateFormat = "yyyyMMdd"
   
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
   recordRoot: TRecordRef = nil
   recordCursor: TRecordRef = nil
   # only lines of leaf line type or its parents
   # will trigger printing of previous leaf
   leafLineType: LineType
   argDocTypeName: string
   optLineId: string
   argSourceFilePath: string
   argDestFilePath: string
   lineQualifier: LineQualifier = nil
   qualifierString: string

proc log(message: string) =
   stdout.write(message & "\n")

proc description(doctype: DocumentType): string =
   "$# v$#.$#   $#" % [doctype.name, intToStr(doctype.formatVersion), intToStr(doctype.formatSubVersion), doctype.description]

proc toString(fs: FieldSpec): string = 
   "FieldSpec lId: $#, leId: $#, value: $#" % [fs.lineId, fs.leTypeId, fs.value]

proc toString(rRef: TRecordRef): string = 
   "TRecordRef[lt: $#]" % [rRef.lineType.lineId]

proc show(message: string) =
   if command != cmdQuery:
      echo message
   else: discard

proc createRecord(line: string): TRecordRef =
   let lineId = line[0..1]
   let lineType = docType.getLineTypeForLineId(lineId)
   TRecordRef(lineType: linetype, line: line, sublines: newTable[string, TRecordRef]())


proc isSubRecord(doctype: DocumentType, subject: LineType, reference: LineType): bool =
   if isNil(subject.parentLineId):
      result = false
   else:
      let parent = doctype.getLineType(subject.parentLineId)
      result = parent.lineId == reference.lineId or isSubRecord(doctype, parent, reference)

proc registerLineId(lineId: string) =
   let lineType = docType.getLineType(lineId)
   if docType.isSubRecord(lineType, leafLineType):
      leafLineType = lineType
   else: discard

proc recordWithLineId(record: TRecordRef, lineId: string): TRecordRef =
   if record.lineType.lineId == lineId:
      result = record
   elif record.sublines.len == 0:
      raise newException(NotFoundError, "No record found with line id $#" % [lineId])
   else:
      for sub in record.sublines.values:
         let found = recordWithLineId(sub, lineId)
         if not isNil(found):
            result = found
            break
         else: discard

proc setCurrentRecord(child: TRecordRef) =
   # echo "setCurrentRecord: lt: $#" % [child.lineType.lineId]
   if isNil(recordRoot):
      # echo "setCurrentRecord: setting root."
      recordRoot = child
   else:
      # echo "setCurrentRecord: root exists: $#" % [recordRoot.lineType.lineId]
      let parent = recordWithLineId(recordRoot, child.lineType.parentLineId)
      parent.sublines[child.lineType.lineId] = child
   recordCursor = child

proc parseVektisDate(dateString: string): TimeInfo =
   try:
      result = parse(dateString, kVektisDateFormat)
   except Exception:
      raise newException(ValueError, "Invalid date format: '$#'" % [dateString])

proc randomDateString(fromDate: string, toDate: string): string =
   let fromSeconds = parseVektisDate(fromDate).toTime().toSeconds()
   let toSeconds = parseVektisDate(toDate).toTime().toSeconds()
   let randomSeconds = random(toSeconds-fromSeconds) + fromSeconds
   let randomDate = fromSeconds(randomSeconds).getLocalTime()
   format(randomDate, kVektisDateFormat)
   

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
   #log("elementValue: value='$#', length=$#" % [if isNil(value): "" else: value, intToStr(length)])
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
   #log("elementValue -> '$#', $#" % [result, intToStr(result.len)])

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
   let lineRecord = recordRoot.recordWithLineId(fSpec.lineId)
   result = docType.getElementValueFullString(lineRecord.line, fSpec.leTypeId)

proc conditionIsMet(): bool =
   if isNil(lineQualifier):
      result = true
   else:
      try:
         let lineRecord = recordRoot.recordWithLineId(lineQualifier.lineId)
         result = lineQualifier.qualifies(lineRecord.line)
      except NotFoundError:
         result = false

proc printLine(line: string) = 
   if line.startsWith(leafLineType.lineId) and conditionIsMet():
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
   let lt = doctype.getLineType(ltId)
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
               let lineType = docType.getLineType("01")
               setCurrentRecord(createRecord(line))
               leafLineType = lineType
               show("Document type: $#" % [description(docType)])
               readFieldSpecs(targetFieldsArg, targetFields, "-e, --elements")
               if command == cmdCopy:
                  var outStream: Stream = newFileStream(argDestFilePath, fmWrite)
                  if not isNil(outStream):
                     mutateAndWrite(line, outStream)
                     while input.readLine(line):
                        setCurrentRecord(createRecord(line))
                        mutateAndWrite(line, outStream)
                     outStream.close()
                  else:
                     quit("Could not create file '$#'" % [outputPath])
               elif command == cmdQuery:
                  while input.readLine(line):
                     setCurrentRecord(createRecord(line))
                     printLine(line)
               else:
                  quit("Unknown command.")
            except Exception:
               quit(getCurrentExceptionMsg())
         else:
            quit("File is not a Vektis format (first two characters should be 01)")
      input.close
   

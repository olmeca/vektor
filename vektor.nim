import os, parseopt2, strutils, sequtils, json, future, streams, random, pegs, times, tables
import "doctypes", "names"

type
   FieldSpec = object
      lineId: string
      leTypeId: string
      value: string
   
   FieldSpecError = object of Exception
   VektisFormatError = object of Exception
   NotFoundError = object of Exception
   
   TCommand = enum
      cmdModify, cmdQuery, cmdInfo, cmdHelp

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
   debtorRecordVersionStartIndex = 298
   debtorRecordVersionEndIndex = 299
   debtorRecordDocumentTypeName = "SB311"
   debtorRecordLineId = "03"
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
   filterFields: seq[FieldSpec] = @[]
   inputfile: string = nil
   outputPath: string = nil
   command: TCommand = cmdModify
   docType: DocumentType
   lineTypeDetermined: bool = false
   lineType: LineType
   optDocTypeName: string = nil
   optVersion: int = -1
   optSubversion: int = -1
   commandWasRead: bool = false
   recordRoot: TRecordRef = nil
   recordCursor: TRecordRef = nil
   # only lines of leaf line type or its parents
   # will trigger printing of previous leaf
   leafLineType: LineType

proc log(message: string) =
   stdout.write(message & "\n")

proc description(doctype: DocumentType): string =
   "$# v$#.$#   $#" % [doctype.name, intToStr(doctype.formatVersion), intToStr(doctype.formatSubVersion), doctype.description]

proc show(message: string) =
   if command != cmdQuery:
      echo message
   else: discard

proc createRecord(line: string): TRecordRef =
   let lineType = docType.getLineType(line[0..1])
   TRecordRef(lineType: linetype, line: line, sublines: newTable[string, TRecordRef]())


proc find[T](seq1: var seq[T], pred: proc(item: T): bool {.closure.}): T =
   for i in 0 .. <len(seq1):
      if pred(seq1[i]):
         return seq1[i]
   raise newException(NotFoundError, "Not found.")

proc isSubRecord(doctype: DocumentType, subject: LineType, reference: LineType): bool =
   if isNil(subject.parentLineId):
      false
   else:
      let parent = doctype.getLineType(subject.parentLineId)
      parent.lineId == reference.lineId or isSubRecord(doctype, parent, reference)

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
   if isNil(recordRoot):
      recordRoot = child
   else:
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

proc fetchDebtorRecordDummyType(version: int): DocumentType =
   getDebtorRecordType(version, 0)

proc getLineType(doctype: DocumentType, lineId: string): LineType =
   let lineTypes = filter(doctype.lineTypes, proc(lt: LineType): bool = lt.lineId == lineId)
   if lineTypes.len == 0:
      raise newException(FieldSpecError, "Invalid line ID [$#] for document type $# specified." % [lineId, description(doctype)])
   else:
      result = lineTypes[0]

proc getLineElementType(doctype: DocumentType, ltype: LineType, leId: string): LineElementType =
   #echo "getLineElementType: ", leId, " in line ", ltype.lineId
   let leTypes = filter(ltype.lineElementTypes, proc(le: LineElementType): bool = le.lineElementId == leId)
   if leTypes.len == 0:
      raise newException(FieldSpecError, "Invalid line element ID [$#] for document type $# specified in field parameter $#" % [leId, description(doctype), targetFieldsArg])
   else:
      result = leTypes[0]

proc determineLineType(defaultDocType: DocumentType, line: string): LineType =
   let lineId = line[0..1]
   result = getLineType(defaultDocType, lineId)
   lineTypeDetermined = true
   if lineId == debtorRecordLineId:
      if line.len > debtorRecordVersionEndIndex:
         var doctype = defaultDocType
         case line[debtorRecordVersionStartIndex..debtorRecordVersionEndIndex]
         of "01":
            doctype = fetchDebtorRecordDummyType(1)
         of "02":
            doctype = fetchDebtorRecordDummyType(1)
         else: discard
         result = getLineType(doctype, lineId)
      else:
         raise newException(VektisFormatError, "Invalid line length for debtor record.")

proc getLineType(line: string): LineType =
   if not lineTypeDetermined:
      lineType = determineLineType(docType, line)
   else: discard
   result = lineType

proc createFieldSpec(doctype: DocumentType, elemSpec: string): FieldSpec =
   let items: seq[string] = split(elemSpec, '=', 1)
   let leId = items[0]
   let lineId = leId[0..1]
   var value: string = nil
   echo "createFieldSpec: line: ", lineId, ", el: ", leId
   if leId.len != 2 or not leId.isDigit():
      raise newException(FieldSpecError, "Invalid line element id: $#" % [ leId])
   else:
      # if a value was specified
      if items.len > 1:
         value = items[1]
         result = FieldSpec(lineId: lineId, leTypeId: leId, value: value)
      # no value was specified, indicating the empty value
      else: 
         result = FieldSpec(lineId: lineId, leTypeId: leId)
      

proc writeToFile(buf: seq[char], file: File) = 
   for c in buf:
      file.write(c)
   file.write('\r')
   file.write('\l')

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
   if fieldSpec.lineId == line[0..1]:
      let leType = getLineElementType(docType, getLineType(line), fieldSpec.leTypeId)
      let start: int = leType.startPosition-1
      let length = leType.length
      var newValue = elementValue(leType, fieldSpec.value)
      assert newValue.len == length
      let newValueSeq = toSeq(newValue.items)
      # Nim range is inclusive
      for i in 0..(length-1):
         buf[start+i] = newValueSeq[i]

proc getFieldValue(fSpec: FieldSpec): string =
   let lineRecord = recordRoot.recordWithLineId(fSpec.lineId)
   let leType = getLineElementType(docType, lineRecord.lineType, fSpec.leTypeId)
   let start = leType.startPosition-1
   let fin = start + leType.length-1
   lineRecord.line[start..fin]

proc printLine(line: string) = 
   if line.startsWith(leafLineType.lineId):
      stdout.write("| ")
      for field in targetFields:
         stdout.write(getFieldValue(field))
         stdout.write(" | ")
      stdout.write("\n")

proc mutateAndWrite(line: var string, file: File) =
   var buf = toSeq(line.mitems)
   for field in targetFields:
      mutate(field, line, buf)
   writeToFile(buf, file)

proc fieldSpecsFromString(doctype: DocumentType, source: string): seq[FieldSpec] =
   lc[createFieldSpec(doctype, item) | (item <- source.split(',')), FieldSpec]


proc isSelected(dt: DocumentType): bool =
   (isNil(optDocTypeName) or optDocTypeName == dt.name) and (optVersion == -1 or optVersion == dt.formatVersion) and (optSubversion == -1 or optSubversion == dt.formatSubVersion)

proc selectDocTypes(): seq[DocumentType] =
   result = filter(get_all_doctypes(), isSelected)

proc showTypes() =
   for doctype in selectDocTypes():
      echo description(doctype)

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
      command = cmdModify
   of "help":
      command = cmdHelp
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

for kind, key, value in getopt():
   case kind
   of cmdLongoption, cmdShortOption:
      case key 
      of "e", "elements":
         targetFieldsArg = value
      of "f", "filter":
         filterFieldsArg = value
      of "o", "outputPath":
         outputPath = value
      of "v", "version":
         readVersion(value)
      of "d", "doctypename":
         optDocTypeName = value
   of cmdArgument:
      if commandWasRead:
         inputfile = key
      else:
         readCommand(key)
   of cmdEnd: assert(false) # cannot happen

if not commandWasRead:
   showHelp()
elif command == cmdHelp:
   showHelp()
elif command == cmdInfo:
   showTypes()
else:
   if isNil(inputfile) or inputfile.len == 0:
      quit("You need to specify an input file")
   elif not existsFile(inputfile):
      quit("Specified input file not found: '$#'" % [inputfile])
   elif isNil(targetFieldsArg) or targetFieldsArg.len == 0:
      quit("You need to specify line elements (-e:0203,0207 or --elements 0203,0207 )")
   else:
      if command == cmdModify and (isNil(outputPath) or outputPath.len == 0):
         quit("No output file specified (-o:filename).")
      else:
         let input = newFileStream(inputfile, fmRead)
         var line: string = ""
         if input.readLine(line):
            if line.startswith("01"):
               try:
                  docType = fetch_doctype(line)
                  let lineType = docType.getLineType("01")
                  setCurrentRecord(createRecord(line))
                  leafLineType = lineType
                  show("Document type: $#" % [description(docType)])
                  readFieldSpecs(targetFieldsArg, targetFields, "-e, --elements")
                  if command == cmdModify:
                     var outputFile: File
                     if open(outputFile, outputPath, fmWrite):
                        mutateAndWrite(line, outputFile)
                        while input.readLine(line):
                           setCurrentRecord(createRecord(line))
                           mutateAndWrite(line, outputFile)
                        close(outputFile)
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
   

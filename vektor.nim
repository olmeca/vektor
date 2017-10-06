import os, parseopt2, strutils, sequtils, json, future, streams, random
import "doctypes", "names"

type
   FieldSpec = object
      lineId: string
      leTypeId: string
      value: string
   
   FieldSpecError = object of Exception
   VektisFormatError = object of Exception
   
   TCommand = enum
      cmdModify, cmdPrint, cmdInfo, cmdHelp

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
   lineId: string
   optDocTypeName: string = nil
   optVersion: int = -1
   optSubversion: int = -1
   commandWasRead: bool = false

proc log(message: string) =
   stdout.write(message & "\n")

proc description(doctype: DocumentType): string =
   "$# v$#.$#   $#" % [doctype.name, intToStr(doctype.formatVersion), intToStr(doctype.formatSubVersion), doctype.description]

proc show(message: string) =
   if command != cmdPrint:
      echo message
   else: discard

proc stripBlanks(source: string): string =
   strip(source, true, true, blanksSet)

proc fetch_doctype(line: string): DocumentType =
   let typeId = parseInt(line[2 .. 4])
   let version = parseInt(line[5 .. 6])
   let subversion = parseInt(line[7 .. 8])
   get_doctype(typeId, version, subversion)

proc fetchDebtorRecordDummyType(version: int): DocumentType =
   get_doctype_by_name(debtorRecordDocumentTypeName, version, 0)

proc getLineType(doctype: DocumentType, lineId: string): LineType =
   let lineTypes = filter(doctype.lineTypes, proc(lt: LineType): bool = lt.lineId == lineId)
   if lineTypes.len == 0:
      raise newException(FieldSpecError, "Invalid line ID [$#] for document type $# specified." % [lineId, description(doctype)])
   else:
      result = lineTypes[0]

proc getLineElementType(doctype: DocumentType, ltype: LineType, leId: string): LineElementType =
   let leTypes = filter(ltype.lineElementTypes, proc(le: LineElementType): bool = le.lineElementId == (ltype.lineId & leId))
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

proc createFieldSpec(doctype: DocumentType, targetFieldsArg: string): FieldSpec =
   let items: seq[string] = split(targetFieldsArg, '=', 1)
   let leId = items[0]
   var value: string = nil
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
   
proc elementValue(fieldType: string, value: string, length: int): string = 
   #log("elementValue: value='$#', length=$#" % [if isNil(value): "" else: value, intToStr(length)])
   if fieldType == "N":
      let number = if isNil(value): 0 else: parseInt(mytrim(value, length))
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
      var newValue = elementValue(leType.fieldType, fieldSpec.value, length)
      assert newValue.len == length
      let newValueSeq = toSeq(newValue.items)
      # Nim range is inclusive
      for i in 0..(length-1):
         buf[start+i] = newValueSeq[i]

proc getFieldValue(fSpec: FieldSpec, line: string): string =
   let et = getLineElementType(docType, getLineType(line), fSpec.leTypeId)
   let start = et.startPosition-1
   let fin = start + et.length-1
   line[start..fin]

proc printLine(line: string) = 
   if line.startsWith(lineId):
      stdout.write("| ")
      for field in targetFields:
         stdout.write(getFieldValue(field, line))
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
   of "print":
      command = cmdPrint
   of "modify":
      command = cmdModify
   of "help":
      command = cmdHelp
   else:
      quit("Invalid command: '$#'" % [cmdString])
   commandWasRead = true

randomize()

for kind, key, value in getopt():
   case kind
   of cmdLongoption, cmdShortOption:
      case key 
      of "e", "element":
         targetFieldsArg = value
      of "f", "filter":
         filterFieldsArg = value
      of "o", "outputPath":
         outputPath = value
      of "h", "help":
         command = cmdHelp
      of "p", "print":
         command = cmdPrint
      of "i", "info":
         command = cmdInfo
      of "v", "version":
         readVersion(value)
      of "d", "doctypename":
         optDocTypeName = value
      of "l", "lineId":
         lineId = value
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
   if isNil(lineId):
      quit("You need to specify a line id (e.g. -l:04)")   
   if isNil(inputfile) or inputfile.len == 0:
      quit("You need to specify an input file")
   elif not existsFile(inputfile):
      quit("Specified input file not found: '$#'" % [inputfile])
   elif targetFieldsArg.len == 0:
      quit("You need to specify an element parameter (e.g. -e:16=20190101).")
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
                  show("Document type: $#" % [description(docType)])
                  targetFields = fieldSpecsFromString(docType, targetFieldsArg)
                  if not isNil filterFieldsArg:
                     filterFields = fieldSpecsFromString(docType, filterFieldsArg)
                  else: discard
                  if command == cmdModify:
                     var outputFile: File
                     if open(outputFile, outputPath, fmWrite):
                        mutateAndWrite(line, outputFile)
                        while input.readLine(line):
                           mutateAndWrite(line, outputFile)
                        close(outputFile)
                  elif command == cmdPrint:
                     echo "Printing"
                     printLine(line)
                     while input.readLine(line):
                        printLine(line)
                  else:
                     quit("Unknown command.")
               except Exception:
                  quit(getCurrentExceptionMsg())
            else:
               quit("File is not a Vektis format (first two characters should be 01)")
         input.close
   

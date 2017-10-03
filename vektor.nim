import os, parseopt2, strutils, sequtils, json, future, streams
import "doctypes"

type
   FieldSpec = object
      lineId: string
      leType: LineElementType
      value: string
   
   FieldSpecError = object of Exception
   
   TCommand = enum
      cmdModify, cmdPrint

let helpText = """
Usage: vektor -o:<output file> -e:<line element id>[=<new value>] [-e ...] <input file>
vektor: a tool for anonymizing Vektis EI standard compliant declaration files.
It lets you specify an input file, a line element type and a value and then 
creates a copy of the given file with all line elements of the given type 
set to the specified value.
"""
let blanksSet: set[char] = { ' ' }

var 
   targetFieldsArg: string
   targetFields: seq[FieldSpec] = @[]
   filterFieldsArg: string
   filterFields: seq[FieldSpec] = @[]
   inputfile: string = nil
   outputPath: string = nil
   showHelp: bool = false
   command: TCommand = cmdModify
   docType: DocumentType
   lineType: LineType
   lineId: string

proc description(doctype: DocumentType): string =
   "$# v$#.$#" % [doctype.name, intToStr(doctype.formatVersion), intToStr(doctype.formatSubVersion)]

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

proc getLineType(doctype: DocumentType, lineId: string): LineType =
   let lineTypes = filter(doctype.lineTypes, proc(lt: LineType): bool = lt.lineId == lineId)
   if lineTypes.len == 0:
      raise newException(FieldSpecError, "Invalid line ID [$#] for document type $# specified." % [lineId, description(doctype)])
   else:
      result = lineTypes[0]

proc getLineElementType(doctype: DocumentType, ltype: LineType, leId: string, targetFieldsArg: string): LineElementType =
   let leTypes = filter(ltype.lineElementTypes, proc(le: LineElementType): bool = le.lineElementId == (ltype.lineId & leId))
   if leTypes.len == 0:
      raise newException(FieldSpecError, "Invalid line element ID [$#] for document type $# specified in field parameter $#" % [leId, description(doctype), targetFieldsArg])
   else:
      result = leTypes[0]

proc createFieldSpec(doctype: DocumentType, targetFieldsArg: string): FieldSpec =
   let items: seq[string] = split(targetFieldsArg, '=', 1)
   let leId = items[0]
   var value: string = nil
   if leId.len != 2 or not leId.isDigit():
      raise newException(FieldSpecError, "Invalid line element id: $#" % [ leId])
   else:
      let elemType = getLineElementType(doctype, lineType, leId, targetFieldsArg)
      # if a value was specified
      if items.len > 1:
         value = items[1]
         if value.len > elemType.length:
            raise newException(FieldSpecError, "Specified value '$#' too large for element $#[$#] (max. length: $#)" % [value, leId, elemType.description, intToStr(elemType.length)])
         elif elemType.fieldType == "N" and not isDigit(value):
            raise newException(FieldSpecError, "Invalid value '$#' for element $#[$#] (must be numerical)" % [value, leId, elemType.description, intToStr(elemType.length)])
         show("Set element $# ($# - $#) to value: '$#'" % [leId, lineType.name, elemType.description, value])
         result = FieldSpec(lineId: lineId, leType: elemType, value: value)
      # no value was specified, indicating the empty value
      else: 
         show("Set element $# ($# - $#) to empty value" % [leId, lineType.name, elemType.description])
         result = FieldSpec(lineId: lineId, leType: elemType)
      

proc writeToFile(buf: seq[char], file: File) = 
   for c in buf:
      file.write(c)
   file.write('\r')
   file.write('\l')

proc elementValue(fieldType: string, value: string, length: int): string = 
   if fieldType == "N":
      let number = if isNil(value): 0 else: parseInt(value)
      result = intToStr(number, length)
   else:
      let alphanum = if isNil(value): "" else: stripBlanks(value)
      result = alphanum & spaces(length - alphanum.len)

proc applyFieldSpec(fieldSpec: FieldSpec, line: string, buf: var openArray[char]) =
   if fieldSpec.lineId == line[0..1]:
      let leType = fieldSpec.leType
      let start: int = leType.startPosition-1
      let length = leType.length
      var newValue = elementValue(leType.fieldType, fieldSpec.value, length)
      assert newValue.len == length
      let newValueSeq = toSeq(newValue.items)
      for i in 0..(newValueSeq.len-1):
         buf[start+i] = newValueSeq[i]

proc getFieldValue(fSpec: FieldSpec, line: string): string =
   let et = fSpec.leType
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
      applyFieldSpec(field, line, buf)
   writeToFile(buf, file)

proc fieldSpecsFromString(doctype: DocumentType, source: string): seq[FieldSpec] =
   lc[createFieldSpec(doctype, item) | (item <- source.split(',')), FieldSpec]

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
         showHelp = true
      of "p", "print":
         command = cmdPrint
      of "l", "lineId":
         lineId = value
   of cmdArgument:
      inputfile = key
   of cmdEnd: assert(false) # cannot happen

if showHelp:
   echo helpText
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
                  lineType = getLineType(docType, lineId)
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
   

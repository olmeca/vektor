import os, parseopt2, strutils, sequtils, json, future, streams
import "doctypes"

type
   Mutation = object
      lineId: string
      leType: LineElementType
      value: string
   
   MutSpecError = object of Exception
   TCommand = enum
      cmdModify, cmdPrint

let helpText = """
Usage: vektor -o:<output file> -e:<line element id>[=<new value>] [-e ...] <input file>
vektor: a tool for anonymizing Vektis EI standard compliant declaration files.
It lets you specify an input file, a line element type and a value and then 
creates a copy of the given file with all line elements of the given type 
set to the specified value.
"""

var 
   mutationParams: seq[string] = @[]
   mutations: seq[Mutation]
   inputfile: string = nil
   outputPath: string = nil
   showHelp: bool = false
   command: TCommand = cmdModify

proc description(doctype: DocumentType): string =
   "$# v$#.$#" % [doctype.name, intToStr(doctype.formatVersion), intToStr(doctype.formatSubVersion)]

proc show(message: string) =
   if command != cmdPrint:
      echo message
   else: discard

proc fetch_doctype(line: string): DocumentType =
   let typeId = parseInt(line[2 .. 4])
   let version = parseInt(line[5 .. 6])
   let subversion = parseInt(line[7 .. 8])
   get_doctype(typeId, version, subversion)

proc getLineType(doctype: DocumentType, lineId: string, mutSpec: string): LineType =
   let lineTypes = filter(doctype.lineTypes, proc(lt: LineType): bool = lt.lineId == lineId)
   if lineTypes.len == 0:
      raise newException(MutSpecError, "Invalid line ID [$#] for document type $# specified in mutation parameter $#" % [lineId, description(doctype), mutSpec])
   else:
      result = lineTypes[0]

proc getLineElementType(doctype: DocumentType, ltype: LineType, leId: string, mutSpec: string): LineElementType =
   let leTypes = filter(ltype.lineElementTypes, proc(le: LineElementType): bool = le.lineElementId == leId)
   if leTypes.len == 0:
      raise newException(MutSpecError, "Invalid line element ID [$#] for document type $# specified in mutation parameter $#" % [leId, description(doctype), mutSpec])
   else:
      result = leTypes[0]

proc createMutation(doctype: DocumentType, mutSpec: string): Mutation =
   let items: seq[string] = split(mutSpec, '=', 1)
   let leId = items[0]
   var value: string = nil
   let lnId = leId[0..1]
   if leId.len != 4 or not leId.isDigit():
      raise newException(MutSpecError, "Line element ID in parameter: $# is not 4 digits." % [ mutSpec])
   else:
      let lineType = getLineType(doctype, lnId, mutSpec)
      let elemType = getLineElementType(doctype, lineType, leId, mutSpec)
      
      # if a value was specified
      if items.len > 1:
         value = items[1]
         if value.len > elemType.length:
            raise newException(MutSpecError, "Specified value '$#' too large for element $#[$#] (max. length: $#)" % [value, leId, elemType.description, intToStr(elemType.length)])
         elif elemType.fieldType == "N" and not isDigit(value):
            raise newException(MutSpecError, "Invalid value '$#' for element $#[$#] (must be numerical)" % [value, leId, elemType.description, intToStr(elemType.length)])
         show("Set element $# ($# - $#) to value: '$#'" % [leId, lineType.name, elemType.description, value])
         result = Mutation(lineId: lnId, leType: elemType, value: value)
      # no value was specified, indicating the empty value
      else: 
         show("Set element $# ($# - $#) to empty value" % [leId, lineType.name, elemType.description])
         result = Mutation(lineId: lnId, leType: elemType)
      

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
      let alphanum = if isNil(value): "" else: value
      result = alphanum & spaces(length - alphanum.len)

proc applyMutation(mut: Mutation, line: string, buf: var openArray[char]) =
   if mut.lineId == line[0..1]:
      let leType = mut.leType
      let start: int = leType.startPosition-1
      let length = leType.length
      var newValue = elementValue(leType.fieldType, mut.value, length)
      assert newValue.len == length
      let newValueSeq = toSeq(newValue.items)
      for i in 0..(newValueSeq.len-1):
         buf[start+i] = newValueSeq[i]

proc printLineElement(mut: Mutation, line: string) =
   if mut.lineId == line[0..1]:
      echo "Printing line."

proc printLine(line: string) = 
   for mutation in mutations:
      printLineElement(mutation, line)

proc mutateAndWrite(line: var string, file: File) =
   var buf = toSeq(line.mitems)
   for mutation in mutations:
      applyMutation(mutation, line, buf)
   writeToFile(buf, file)

for kind, key, value in getopt():
   case kind
   of cmdLongoption, cmdShortOption:
      case key 
      of "e", "element":
         mutationParams.add(value)
      of "o", "outputPath":
         outputPath = value
      of "h", "help":
         showHelp = true
      of "p", "print":
         command = cmdPrint
   of cmdArgument:
      inputfile = key
   of cmdEnd: assert(false) # cannot happen

if showHelp:
   echo helpText
else:
   if isNil(inputfile) or inputfile.len == 0:
      quit("You need to specify an input file")
   elif not existsFile(inputfile):
      quit("Specified input file not found: '$#'" % [inputfile])
   elif mutationParams.len == 0:
      quit("You need to specify an element parameter (e.g. -e:0416=20190101).")
   else:
      if isNil(outputPath) or outputPath.len == 0:
         quit("No output file specified (-o:filename).")
      else:
         let input = newFileStream(inputfile, fmRead)
         var line: string = ""
         if input.readLine(line):
            if line.startswith("01"):
               try:
                  let doctype = fetch_doctype(line)
                  show("Document type: $#" % [description(doctype)])
                  mutations = lc[createMutation(doctype, mut) | (mut <- mutationParams), Mutation]
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
   

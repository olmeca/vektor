import os, parseopt2, strutils, sequtils, json, future, streams
import "doctypes"

type
   Mutation = object
      lineId: string
      leType: LineElementType
      value: string
   
   MutSpecError = object of Exception

var 
   mutationParams: seq[string] = @[]
   mutations: seq[Mutation]
   inputfile: string = nil
   outputPath: string = nil

proc description(doctype: DocumentType): string =
   "$#v$#.$#" % [doctype.name, intToStr(doctype.formatVersion), intToStr(doctype.formatSubVersion)]

proc fetch_doctype(line: string): DocumentType =
   let typeId = parseInt(line[2 .. 4])
   let version = parseInt(line[5 .. 6])
   let subversion = parseInt(line[7 .. 8])
   echo "doctype: ", typeId, ", version: ", version, "sub: ", subversion
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
   let value = items[1]
   let lnId = leId[0..1]
   if leId.len != 4 or not leId.isDigit():
      raise newException(MutSpecError, "Line element ID in parameter: $# is not 4 digits." % [ mutSpec])
   else:
      let lineType = getLineType(doctype, lnId, mutSpec)
      let elemType = getLineElementType(doctype, lineType, leId, mutSpec)
      if value.len > elemType.length:
         raise newException(MutSpecError, "Specified value '$#' too large for element $#[$#] (max. length: $#)" % [value, leId, elemType.description, intToStr(elemType.length)])
      elif elemType.fieldType == "N" and not isDigit(value):
         raise newException(MutSpecError, "Invalid value '$#' for element $#[$#] (must be numerical)" % [value, leId, elemType.description, intToStr(elemType.length)])
      else:
         echo "Mutation for line $#, element $#, value: $#" % [lineType.name, elemType.description, value]
         result = Mutation(lineId: lnId, leType: elemType, value: value)

proc writeToFile(buf: seq[char], file: File) = 
   for c in buf:
      file.write(c)
   file.write("\r\n")

proc elementValue(fieldType: string, value: string, length: int): string = 
   if fieldType == "N":
      let number = parseInt(value)
      result = intToStr(number, length)
   else:
      result = value & spaces(length - value.len)

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

proc mutateAndWrite(line: var string, file: File) =
   var buf = toSeq(line.mitems)
   for mutation in mutations:
      applyMutation(mutation, line, buf)
   writeToFile(buf, file)

for kind, key, value in getopt():
   case kind
   of cmdLongoption, cmdShortOption:
      case key 
      of "m", "mutation":
         mutationParams.add(value)
      of "o", "outputPath":
         outputPath = value;
   of cmdArgument:
      inputfile = key
   of cmdEnd: assert(false) # cannot happen

if isNil(inputfile) or inputfile.len == 0:
   quit("You need to specify an input file")
elif mutationParams.len == 0:
   quit("You need to specify a mutation parameter (e.g. -m:0416=20190101).")
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
               mutations = lc[createMutation(doctype, mut) | (mut <- mutationParams), Mutation]
               var outputFile: File
               if open(outputFile, outputPath, fmWrite):
                  mutateAndWrite(line, outputFile)
                  while input.readLine(line):
                     mutateAndWrite(line, outputFile)
                  close(outputFile)
            except Exception:
               quit(getCurrentExceptionMsg())
         else:
            quit("File is not a Vektis format (first two characters should be 01)")
      input.close
   
echo "Done."
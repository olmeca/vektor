import os, parseopt2, strutils, sequtils, json, future, streams, random, pegs, times, tables, logging
import "doctypes", "context", "qualifiers", "common", "accumulator", "vektorhelp", "validation", "formatting", "expressions", "expressionsreader"

type
   FieldSpec = ref FieldSpecObj
   FieldSpecObj = object of RootObj
      leType: LineElementType
   FieldValueSpec = ref FieldValueSpecObj
   FieldValueSpecObj = object of FieldSpecObj
      value: Expression
   
   FieldSpecError = object of Exception
   
   TCommand = enum
      cmdCopy, cmdQuery, cmdInfo, cmdHelp, cmdPrint, cmdValidate


const
   msgDocVersionMissing = "For information on a document type you also need to specify a version (e.g. -v:1.0)"
   msgSourceOrDestMissing = "You need to specify a source file and a destination file (e.g: vektor copy source.asc dest.asc -e:...)."
   msgCommandMissing = "Please specify one of the following commands: info, show, copy or help."
   gTableLinePrefix = "| "
   gTableLineInfix = " | "
   gTableLinePostfix = " |"


var 
   copyFieldsArg: string
   copyFields: seq[FieldValueSpec] = @[]
   showFieldsArg: string
   showFields: seq[FieldSpec] = @[]
   filterFieldsArg: string
   outputPath: string = nil
   command: TCommand = cmdCopy
   commandArgs: seq[string] = @[]
   docType: DocumentType
   optVersion: int = -1
   optSubversion: int = -1
   commandWasRead: bool = false
   gRootContext: Context = nil
   gCurrentContext: Context = nil
   argDocTypeName: string
   optLineId: string
   argSourceFilePath: string
   argDestFilePath: string
   argReplacementScriptPath: string
   gReplacementQualifier: LineQualifier = nil
   gReplacementQualifierString: string = nil
   gSelectionQualifier: LineQualifier = nil
   gSelectionQualifierString: string = nil
   logLevel: string = nil
   gNames: seq[string] = nil
   subject: string
   gTotals: Accumulator
   gSubtotals: Accumulator
   gRandomizedValuesMap: TableRef[string, string]
   gSequenceNumber: int = 0
   cMaxErrors: int = 20
   gDebRecVersion: DebtorRecordVersion = drvDefault
   argDebRevVersionSpecified = false

proc setLoggingLevel(level: Level) =
   let filePath = joinPath(getAppDir(), "vektor.log")
   var fileLogger = newFileLogger(filePath, fmtStr = verboseFmtStr)
   addHandler(fileLogger)
   setLogFilter(level)


proc description(doctype: DocumentType): string =
   "$# v$#.$#   $#" % 
      [doctype.name, 
      intToStr(doctype.formatVersion), 
      intToStr(doctype.formatSubVersion), 
      doctype.description]

proc toString(fs: FieldSpec): string = 
   "FieldSpec leId: $#" % [fs.leType.lineElementId]

proc hasOwnRandomizationContext(line: string): bool =
   let lineIdNr = parseInt(line[0..1])
   lineIdNr <= 2 or lineIdNr == 99


proc setCurrentLine(line: string) =
   let lineType = docType.getLineTypeForLineId(line[0..1])
   if isNil(gCurrentContext):
      debug("setCurrentLine: setting root: " & line[0..4])
      gCurrentContext = createContext(lineType, line)
      gRootContext = gCurrentContext
   else:
      var parentContext = gCurrentContext.findParentContextForLineType(lineType.lineId)
      assert(not isNil(parentContext))
      gCurrentContext = createContext(lineType, line, parentContext)
      debug("setCurrentLine: parent: $#, line: $#" % [parentContext.lineType.lineId, line[0..13]])
   gCurrentContext.state = csRegistered


proc stripBlanks(source: string): string =
   strip(source, true, true, cBlanksSet)

proc fetch_doctype(line: string): DocumentType =
   let typeId = parseInt(line[2 .. 4])
   let version = parseInt(line[5 .. 6])
   let subversion = parseInt(line[7 .. 8])
   getDocumentType(typeId, version, subversion)

proc isDerivedValue(valueSpec: string): bool =
   valueSpec[0] == '@'

proc padright(source: string, length: int, fillChar: char = ' '): string =
   if source.len > length:
      source.substr(0, length-1)
   else:
      source & repeat(fillChar, length - source.len)

proc writeToStream(buf: seq[char], stream: Stream) = 
   for c in buf:
      stream.write(c)
   stream.write('\r')
   stream.write('\l')

proc mytrim(value: string, length: int): string = 
   result = if value.len > length: value[0..length-1] else: value

proc getNextSequenceNumber(): int =
   gSequenceNumber = gSequenceNumber + 1
   gSequenceNumber


proc copyChars(buf: var openArray[char], start: int, length: int, newValue: string) =
   assert newValue.len == length
   let newValueSeq = toSeq(newValue.items)
   # Nim range is inclusive
   for i in 0..(length-1):
      buf[start+i] = newValueSeq[i]

proc getFieldValueFullString(fSpec: FieldSpec): string =
   debug("getFieldValueFullString: " & fSpec.leType.lineElementId) 
   result = gRootContext.getElementValueFullString(fSpec.leType.lineElementId)

proc conditionIsMet(qualifier: LineQualifier): bool =
   if isNil(qualifier):
      result = true
   else:
      try:
         result = qualifier.qualifies(gRootContext)
      except ContextWithLineIdNotFoundError:
         result = false

proc maxLineIndex(fields: seq[FieldSpec]): int =
   foldl(fields, max(a, parseInt(b.leType.lineElementId[0..1])), 0)

proc printLineAddToSubtotals(context: var Context) =
   if context.state != csExported:
      if context.line.isContentLine():
         gSubTotals.addLine(context.line)
      context.state = csExported
   for sub in context.subContexts.mvalues:
      printLineAddToSubtotals(sub)

proc getHeaderForField(field: FieldSpec): string =
   let length = field.leType.length
   let leType = field.leType
   if length >= 4:
      if leType.isNumericType or leType.isAmountType:
         leType.lineElementId|R(length)
      else:
         leType.lineElementId|L(length)
   else:
      spaces(length)

proc tabularLine(fields: seq[FieldSpec], stringValue: proc(field: FieldSpec): string, 
                  prefix: string, infix: string, postfix: string): string =
   let values = lc[stringValue(field) | (field <- fields), string]
   result = prefix & values.join(infix) & postfix

proc printColumnHeaders(stream: Stream, fields: seq[FieldSpec]) =
   stream.write(tabularLine(fields, getHeaderForField, gTableLinePrefix, gTableLineInfix, gTableLinePostfix))
   stream.write("\n")

proc printLine(stream: Stream, line: string, fields: seq[FieldSpec]) =
   stream.write(tabularLine(fields, getFieldValueFullString, gTableLinePrefix, gTableLineInfix, gTableLinePostfix))
   stream.write("\n")


proc conditionallyPrintLine(outStream: Stream, line: string, fields: seq[FieldSpec], maxLineIndex: int) = 
   var tempStream = newStringStream()
   if parseInt(line[0..1]) <= maxLineIndex and conditionIsMet(gSelectionQualifier):
      try:
         printLine(tempStream, line, fields)
         outStream.write(tempStream.data)
      except ContextWithLineIdNotFoundError:
         debug(">>>>>> Referring to line id '$#' out of context." % [line[0..1]])
   
   if not isNil(gSubtotals):
      printLineAddToSubtotals(gRootContext)

proc printHorLine(stream: Stream, fields: seq[FieldSpec]) =
   stream.write("+-")
   var index = 0
   for field in fields:
      stream.write(repeat('-', Natural(field.leType.length)))
      index = index + 1
      if index < showFields.len:
         stream.write("-+-")
      else:
         stream.write("-+\n")

proc printHeaders(stream: Stream, fields: seq[FieldSpec]) = 
   printHorLine(stream, fields)
   printColumnHeaders(stream, fields)
   printHorLine(stream, fields)

proc writeToStream(line: string, stream: Stream) =
   if line.isContentLine():
      gTotals.addLine(line)
   writeToStream(toSeq(line.items), stream)

proc writeToStream(context: var Context, stream: Stream) =
   if context.state != csExported:
      writeToStream(context.line, stream)
      context.state = csExported
   for sub in context.subContexts.mvalues:
      writeToStream(sub, stream)

proc mutateAndWrite(line: var string, outStream: Stream) =
   debug("mutateAndWrite: " & line[0..13])
   let lineType = docType.getLineTypeForLineId(line[0..1])
   var buf = toSeq(line.mitems)
   # Bottom line cumulative values get updated
   # We don't allow bottom line values to be modified
   if line.startsWith(cBottomLineId):
      # Clean up context from residual content
      gRootContext.dropContentSubContexts()
      # Bottom line needs to first be updated with accumulated values
      if not gTotals.isEmpty():
         gTotals.write(buf)
         line = buf.toString()
         debug(line)
      writeToStream(buf, outStream)
   else:
      if conditionIsMet(gSelectionQualifier):
         debug("maw: selection qualifier is met")
         if conditionIsMet(gReplacementQualifier):
            debug("maw: replacement qualifier is met")
            # Only attempt replacement if there are target fields defined
            if not isNil(copyFields):
               for field in copyFields:
                  let leType = field.leType
                  if leType.isElementOfLine(line):
                     # if debtor record then field.leType is the default debtor record type, so get the real leType
                     # let leType = if line.isDebtorLine(): lineType.getLineElementType(field.leType.lineElementId) else: field.leType
                     let newValue = FieldValueSpec(field).value.serialize()
                     debug("maw: setting new value for leId '$#': '$#'" % [leType.lineElementId, newValue])
                     copyChars(buf, leType.startPosition-1, leType.length, newValue)
      
      if lineType.hasDependentElements:
         for leType in lineType.lineElementTypes:
            if not isNil(leType.sourceId):
               debug("maw: getting source value for '$#'" % [leType.sourceId])
               let newValue = gRootContext.getElementValueFullString(leType.sourceId)
               debug("maw: got new source value: '$#'" % [newValue])
               copyChars(buf, leType.startPosition-1, leType.length, newValue)
      
      gCurrentContext.line = buf.toString()
      writeToStream(gRootContext, outStream)


proc isSelected(dt: DocumentType): bool =
   (isNil(argDocTypeName) or dt.name.startsWith(argDocTypeName)) and 
      (optVersion == -1 or optVersion == dt.formatVersion) and 
      (optSubversion == -1 or optSubversion == dt.formatSubVersion)

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
      echo "$#   $#   $#   $#   $#   $#" % 
         [et.lineElementId, 
         et.code, 
         intToStr(et.startPosition, 4), 
         intToStr(et.length, 4), 
         padright(et.fieldType, 4), 
         et.description]

proc showDocumentTypeInfo(doctype: DocumentType) =
   echo description(doctype)
   echo "ID   Len   Description"
   for lineType in doctype.lineTypes:
      echo "$#   $#   $#" % [
         lineType.lineId, 
         intToStr(lineType.length,3), 
         lineType.name]

proc isVersionMissing(): bool = optVersion == -1 and optSubversion == -1

proc showInfo() =
   if isNil(argDocTypeName) or isVersionMissing():
      showDocumentTypes()
   else:
      let doctype = documentTypeMatching(argDocTypeName.toUpperAscii(), optVersion, optSubversion)
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

proc readQualifier(source: string, qualifier: var LineQualifier) =
   if not isNil(source):
      debug("readQualifier: $#" % source)
      qualifier = docType.parseQualifier(source)
      if isNil(gSubTotals):
         gSubTotals = newAccumulator(docType)
      else: discard
   else: discard

proc checkAndPrepareQualifiers() =
   readQualifier(gReplacementQualifierString, gReplacementQualifier)
   readQualifier(gSelectionQualifierString, gSelectionQualifier)


proc showHelp() =
   try:
       echo helpSubjects[subject]
   except KeyError:
      echo "There is no help on subject '$#'" % [subject]

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
   of "validate":
      command = cmdValidate
   else:
      quit(msgCommandMissing)
   commandWasRead = true

proc readExpression (leType: LineElementType, valueSpec: string): Expression =
   readExpression(valueSpec, leType.lineElementId, leType.code, leType.length)

proc checkSupportedLineType(leId: string) =
   if parseInt(leId[0..1]) >= 98:
      raise newException(FieldSpecError, "Unsupported line ID: '$#'" % [leId[0..1]])

proc readFieldSpec(spec: string): FieldSpec =
   if spec =~ fieldSpecPattern:
      let leTypeId = matches[0]
      checkSupportedLineType(leTypeId)
      let leType = docType.getLineElementType(leTypeId)
      result = FieldSpec(leType: leType)
   else:
      raise newException(FieldSpecError, "Invalid line element specification: '$#'" % [spec])

proc readFieldValueSpec(spec: string): FieldValueSpec =
   if spec =~ fieldValueSpecPattern:
      debug("readFieldValueSpec: matches: '$#', '$#'" % [matches[0], matches[1]])
      let leTypeId = matches[0]
      checkSupportedLineType(leTypeId)
      let value = matches[1]
      let leType = docType.getLineElementType(leTypeId)
      if leType.isDependent():
         raise newException(FieldSpecError, 
            "Modification of dependent line element '$#' not allowed. Modify element '$#' instead." % [leType.lineElementId, leType.sourceId])
      let valueExpression = readExpression(leType, value)
      result = FieldValueSpec(leType: leType, value: valueExpression)
      debug("readFieldValueSpec: leType: '$#', value: $#" % [leType.asString, valueExpression.asString])
   else:
      raise newException(FieldSpecError, "Invalid line element specification: '$#'" % [spec])

proc readFieldSpecs(value: string, fields: var seq[FieldSpec], argName: string) = 
   if not isNil(value):
      if value =~ fieldSpecsPattern:
         fields =  concat(fields, lc[readFieldSpec(s)|(s <- matches, not isNil(s)), FieldSpec])
      else:
         quit("Invalid elements specification in argument ($#): '$#'." % [argName, value])
   else: discard

proc readFieldValueSpecs(value: string, fields: var seq[FieldValueSpec], argName: string) = 
   if not isNil(value):
      if value =~ fieldSpecsPattern:
         fields = lc[readFieldValueSpec(s)|(s <- matches, not isNil(s)), FieldValueSpec]
      else:
         quit("Invalid element values specification in argument ($#)." % [argName])
   else: discard

proc readDebtorRecordVersion(value: string): DebtorRecordVersion =
   case value
   of "1": drvSB1
   of "2": drvSB2
   else: drvDefault

proc checkCommandArgs(minCount: int, errorMessage: string) =
   if commandArgs.len < minCount:
      quit(errorMessage)

proc readCommandArgument(arg: string) =
   commandArgs.add(arg)

proc fieldSpecArgName(): string =
   if command == cmdCopy:
      result = "-r, --replacements"
   else:
      result = "-e, --elements"

proc showFieldsRequired(): bool =
   command == cmdQuery

proc determineDebtorRecordVersion(): DebtorRecordVersion =
   result = drvDefault
   let input = newFileStream(argSourceFilePath, fmRead)
   var line: string = ""
   var i = 0
   while input.readLine(line) and i < 50:
      i = i + 1
      if isDebtorLine(line):
         if line.matchesDebtorRecordVersion(drvSB1):
            result = drvSB1
         elif line.matchesDebtorRecordVersion(drvSB2):
            result = drvSB2
         else:
            result = drvDefault
   close(input)

proc processCommandArgs() =
   if command == cmdInfo:
      if commandArgs.len > 0:
         argDocTypeName = commandArgs[0].toUpperAscii()
         if commandArgs.len > 1:
            readVersion(commandArgs[1])
         else: discard
      else: discard
   elif command == cmdCopy:
      checkCommandArgs(2, msgSourceOrDestMissing)
      argSourceFilePath = commandArgs[0]
      argDestFilePath = commandArgs[1]
   elif command == cmdQuery:
      argSourceFilePath = commandArgs[0]
   elif command == cmdValidate:
      checkCommandArgs(1, "Missing argument filename.")
      argSourceFilePath = commandArgs[0]
   elif command == cmdHelp:
      if commandArgs.len > 0:
         subject = commandArgs[0]
      else:
         subject = "none"
   else: discard

for kind, key, value in getopt():
   case kind
   of cmdLongoption, cmdShortOption:
      case key 
      of "D", "debug-level":
         logLevel = value
      of "d", "debtor-record":
         argDebRevVersionSpecified = true
         gDebRecVersion = readDebtorRecordVersion(value)
      of "r", "replacements":
         copyFieldsArg = value
      of "R", "replacement-script":
         argReplacementScriptPath = value
      of "e", "elements":
         showFieldsArg = value
      of "f", "filter":
         filterFieldsArg = value
      of "l", "lineid":
         optLineId = value
      of "v", "version":
         readVersion(value)
      of "c", "condition":
         gReplacementQualifierString = value
      of "s", "selection":
         gSelectionQualifierString = value
   of cmdArgument:
      if commandWasRead:
         readCommandArgument(key)
      else:
         readCommand(key)
   of cmdEnd: assert(false) # cannot happen

if not isNil(logLevel):
   setLoggingLevel(readLogLevel(logLevel))
else: discard
# Initialize the random generator
randomize()

initializeExpressionReaders()
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
else:
   if not existsFile(argSourceFilePath):
      quit("Specified source file not found: $#" % [argSourceFilePath])
   elif showFieldsRequired() and (isNil(showFieldsArg) or showFieldsArg.len == 0):
      quit("You need to specify line elements (-e:0203,0207 or --elements 0203,0207 )")
   else:
      if not argDebRevVersionSpecified:
         gDebRecVersion = determineDebtorRecordVersion()
      let input = newFileStream(argSourceFilePath, fmRead)
      var line: string = ""
      if input.readLine(line):
         if line.startswith(cTopLineId):
            try:
               docType = fetch_doctype(line)
               loadDebtorRecordType(docType, gDebRecVersion)
               if command == cmdQuery:
                  gTotals = newAccumulator(docType)
                  checkAndPrepareQualifiers()
                  let topLineType = docType.getLineTypeForLineId(cTopLineId)
                  setCurrentLine(line)
                  echo("Document type: $#, SB311v$#" % [description(docType), repr(gDebRecVersion)])
                  readFieldSpecs(showFieldsArg, showFields, fieldSpecArgName())
                  let outStream = newFileStream(stdout)
                  printHeaders(outStream, showFields)
                  let maxShownLineIndex = maxLineIndex(showFields)
                  conditionallyPrintLine(outStream, line, showFields, maxShownLineIndex)
                  while input.readLine(line):
                     if line.isDebtorLine and not line.matchesDebtorRecordVersion(gDebRecVersion):
                        quit("Input file has unexpected value for debtor record version in 03 lines.")
                     setCurrentLine(line)
                     conditionallyPrintLine(outStream, line, showFields, maxShownLineIndex)
                     gTotals.addLine(line)
                  printHorLine(outStream, showFields)
                  if not isNil(gSubtotals):
                     echo "Subtotals: " & gSubtotals.asString()
                  echo "Totals:    " & gTotals.asString()
               elif command == cmdCopy:
                  gTotals = newAccumulator(docType)
                  checkAndPrepareQualifiers()
                  let topLineType = docType.getLineTypeForLineId(cTopLineId)
                  setCurrentLine(line)
                  echo("Document type: $#, SB311v$#" % [description(docType), repr(gDebRecVersion)])
                  var script: string
                  if not isNil(argReplacementScriptPath):
                     try:
                        script = system.readFile(argReplacementScriptPath)
                        readFieldValueSpecs(script, copyFields, "-R (--replacementscript)")
                     except IOError:
                        quit("Cannot open file $#" % argReplacementScriptPath)
                  readFieldValueSpecs(copyFieldsArg, copyFields, fieldSpecArgName())
                  var outStream: Stream = newFileStream(argDestFilePath, fmWrite)
                  if not isNil(outStream):
                     mutateAndWrite(line, outStream)
                     while input.readLine(line):
                        if line.hasOwnRandomizationContext():
                           gRandomizedValuesMap = newTable[string, string]()
                        setCurrentLine(line)
                        mutateAndWrite(line, outStream)
                     outStream.close()
                  else:
                     quit("Could not create file '$#'" % [outputPath])
               elif command == cmdValidate:
                  gTotals = newAccumulator(docType)
                  var lineNr = 1
                  var errors: seq[ValidationResult] = @[]
                  docType.validate(line, lineNr, errors)
                  while input.readLine(line) and errors.len < cMaxErrors:
                     lineNr = lineNr + 1
                     docType.validate(line, lineNr, errors)
                  if errors.len == 0:
                     echo "OK."
                  else:
                     for error in errors:
                        echo error.asString()
            except Exception:
               quit(getCurrentExceptionMsg())
         else:
            quit("File is not a Vektis format (first two characters should be 01)")
      input.close
   

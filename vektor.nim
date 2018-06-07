import os, parseopt2, strutils, sequtils, json, future, streams, random, pegs, times, tables, logging
import "doctypes", "context", "qualifiers", "common", "accumulator", "vektorhelp", "validation", "formatting", "expressions", "expressionsreader", "vektorjson", "jobs", "infojob", "utils"

const
   msgDocVersionMissing = "For information on a document type you also need to specify a version (e.g. -v:1.0)"
   msgSourceOrDestMissing = "You need to specify a source file and a destination file (e.g: vektor copy source.asc dest.asc -e:...)."
   msgCommandMissing = "Please specify one of the following commands: info, show, copy or help."
   gTableLinePrefix = "| "
   gTableLineInfix = " | "
   gTableLinePostfix = " |"
   cMaxErrors: int = 20


var 
   copyFieldsArg: string
   copyFields: seq[FieldValueSpec] = @[]
   showFieldsArg: string
   showFields: seq[FieldSpec] = @[]
   outputPath: string = nil
   command: TCommand = cmdCopy
   commandArgs: seq[string] = @[]
   docType: DocumentType
   optVersion: int = -1
   optSubversion: int = -1
   commandWasRead: bool = false
   gSequenceNumber: int = 0
   argDebRevVersionSpecified = false

proc setLoggingLevel(level: Level) =
   let filePath = getVektorLogPath()
   var fileLogger = newFileLogger(filePath, fmtStr = verboseFmtStr)
   addHandler(fileLogger)
   setLogFilter(level)


proc toString(fs: FieldSpec): string =
   "FieldSpec leId: $#" % [fs.leType.lineElementId]

proc hasOwnRandomizationContext(line: string): bool =
   let lineIdNr = parseInt(line[0..1])
   lineIdNr <= 2 or lineIdNr == 99


proc stripBlanks(source: string): string =
   strip(source, true, true, cBlanksSet)

proc fetch_doctype(line: string): DocumentType =
   let typeId = parseInt(line[2 .. 4])
   let version = parseInt(line[5 .. 6])
   let subversion = parseInt(line[7 .. 8])
   getDocumentType(typeId, version, subversion)

proc isDerivedValue(valueSpec: string): bool =
   valueSpec[0] == '@'

proc getNextSequenceNumber(): int =
   gSequenceNumber = gSequenceNumber + 1
   gSequenceNumber


proc copyChars(buf: var openArray[char], start: int, length: int, newValue: string) =
   assert newValue.len == length
   let newValueSeq = toSeq(newValue.items)
   # Nim range is inclusive
   for i in 0..(length-1):
      buf[start+i] = newValueSeq[i]

proc getFieldValueFullString(rootContext: Context, fSpec: FieldSpec): string =
   debug("get FieldValueFullString: " & fSpec.leType.lineElementId)
   result = rootContext.getElementValueFullString(fSpec.leType.lineElementId)

proc conditionIsMet(context: Context, qualifier: LineQualifier): bool =
   if isNil(qualifier):
      result = true
   else:
      try:
         result = qualifier.qualifies(context)
      except ContextWithLineIdNotFoundError:
         debug("condition Is Met: '$#'" % getCurrentExceptionMsg())
         result = false

proc maxLineTypeIndex(fields: seq[FieldSpec]): int =
   foldl(fields, max(a, parseInt(getLineId(b.leType.lineElementId))), 0)

proc accumulate(context: var Context, acc: Accumulator) =
   if context.state != csExported:
      if context.line.isContentLine():
         acc.addLine(context.line)
      context.state = csExported
   for subcontext in context.subContexts.mvalues:
      accumulate(subcontext, acc)

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

proc tabularLine(ctx: Context, fields: seq[FieldSpec], stringValue: proc(field: FieldSpec): string,
                  prefix: string, infix: string, postfix: string): string =
   let values = lc[stringValue(field) | (field <- fields), string]
   result = prefix & values.join(infix) & postfix

proc printColumnHeaders(ctx: Context, fields: seq[FieldSpec], stream: Stream) =
   stream.write(tabularLine(ctx, fields, getHeaderForField, gTableLinePrefix, gTableLineInfix, gTableLinePostfix))
   stream.write("\n")

proc printLine(ctx: Context, fields: seq[FieldSpec], stream: Stream) =
   stream.write(tabularLine(ctx, fields,
                            proc (fs: FieldSpec): string = getElementValueFullString(ctx, fs.leType.lineElementId),
                            gTableLinePrefix,
                            gTableLineInfix,
                            gTableLinePostfix))
   stream.write("\n")


proc conditionallyPrintLine(job: ShowJob, outStream: Stream) =
   var rootContext = job.context
   let currentContext = rootContext.current()
   var tempStream = newStringStream()
   # Do not print subtypes of the subbest record type in the field specs (index > maxLineTypeIndex)
   if currentContext.lineType.index <= job.maxLineTypeIndex and rootContext.conditionIsMet(job.selectionQualifier):
      try:
         printLine(rootContext, job.fields, tempStream)
         outStream.write(tempStream.data)
         if not isNil(job.accumulator):
            accumulate(rootContext, job.accumulator)
      except ContextWithLineIdNotFoundError:
         debug(">>>>>> Referring to line id '$#' out of context." % [currentContext.lineType.lineId])


proc printHorLine(fields: seq[FieldSpec], stream: Stream) =
   stream.write("+-")
   var index = 0
   for field in fields:
      stream.write(repeat('-', Natural(field.leType.length)))
      index = index + 1
      if index < showFields.len:
         stream.write("-+-")
      else:
         stream.write("-+\n")

proc printHeaders(ctx: Context, fields: seq[FieldSpec], stream: Stream) =
   printHorLine(fields, stream)
   printColumnHeaders(ctx, fields, stream)
   printHorLine(fields, stream)

proc writeLineToStream(line: string, stream: Stream) =
   writeCharsToStream(toSeq(line.items), stream)

proc writeContextToStream(context: var Context, stream: Stream) =
   if context.state != csExported:
      writeLineToStream(context.line, stream)
      context.state = csExported
   for sub in context.subContexts.mvalues:
      writeContextToStream(sub, stream)

proc updateDependentLineElements(rootContext: Context, linebuffer: var openArray[char]) =
  let context = rootContext.currentSubContext
  if context.lineType.hasDependentElements:
     for leType in context.lineType.lineElementTypes:
        if not isNil(leType.sourceId):
           debug("maw: getting source value for '$#'" % [leType.sourceId])
           let newValue = rootContext.getElementValueFullString(leType.sourceId)
           debug("maw: got new source value: '$#'" % [newValue])
           copyChars(lineBuffer, leType.startPosition-1, leType.length, newValue)


proc mutateAndWrite(job: var CopyJob, outStream: Stream) =
   var rootContext = job.context
   let context = rootContext.currentSubContext
   var lineBuffer = toSeq(context.line.mitems)

   # Bottom line cumulative values get updated
   # We don't allow bottom line values to be modified
   if context.lineType.lineId == cBottomLineId:
      debug("maw: writing bottom line")
      # Clean up context from residual content
      rootContext.dropContentSubContexts()
      # Bottom line needs to first be updated with accumulated values
      job.accumulator.write(lineBuffer)
      context.line = lineBuffer.toString()
      writeCharsToStream(lineBuffer, outStream)
   else:
      if rootContext.conditionIsMet(job.selectionQualifier):
         debug("maw: selection qualifier is met")
         if rootContext.conditionIsMet(job.replacementQualifier):
            debug("maw: replacement qualifier is met")
            # Only attempt replacement if there are target fields defined
            if not isNil(job.fieldValues):
               for field in job.fieldValues:
                  let leType = field.leType
                  if leType.isElementOfLine(context.line):
                     # if debtor record then field.leType is the default debtor record type, so get the real leType
                     # let leType = if line.isDebtorLine(): lineType.getLineElementType(field.leType.lineElementId) else: field.leType
                     let newValue = field.value.serialize()
                     debug("maw: setting new value for leId '$#': '$#'" % [leType.lineElementId, newValue])
                     copyChars(lineBuffer, leType.startPosition-1, leType.length, newValue)
         else: discard

         updateDependentLineElements(rootContext, linebuffer)
         context.line = lineBuffer.toString()
         job.accumulator.addLine(context.line)
         writeContextToStream(rootContext, outStream)



proc showHelp(subject: string) =
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

proc readFieldSpec(job: ShowJob, spec: string): FieldSpec =
   if spec =~ fieldSpecPattern:
      let leTypeId = matches[0]
      checkProcessableLineType(leTypeId)
      let leType = job.docType.getLineElementType(leTypeId)
      result = FieldSpec(leType: leType)
   else:
      raise newException(FieldSpecError, "Invalid line element specification: '$#'" % [spec])

proc readFieldValueSpec(job: CopyJob, spec: string): FieldValueSpec =
   if spec =~ fieldValueSpecPattern:
      debug("readFieldValueSpec: matches: '$#', '$#'" % [matches[0], matches[1]])
      let leTypeId = matches[0]
      checkProcessableLineType(leTypeId)
      let value = matches[1]
      let leType = job.docType.getLineElementType(leTypeId)
      if leType.isDependent():
         raise newException(FieldSpecError, 
            "Setting the value of derived field '$#' is not allowed. \nSet value of field $# instead and Vektor will also update field $# accordingly." % [leType.lineElementId, leType.sourceId, leType.lineElementId])
      let valueExpression = readExpression(leType, value)
      result = FieldValueSpec(leType: leType, value: valueExpression)
      debug("readFieldValueSpec: leType: '$#', value: $#" % [leType.asString, valueExpression.asString])
   else:
      raise newException(FieldSpecError, "Invalid line element specification: '$#'" % [spec])

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
   let input = newFileStream(documentPath, fmRead)
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

proc printHeaders(job: ShowJob, stream: Stream) =
    printHorLine(job.fields, stream)
    printColumnHeaders(job.context, job.fields, stream)
    printHorLine(job.fields, stream)


proc initializeFieldValueSpecs(job: CopyJob) =
    if isNil(job.fieldValuesString) and not isNil(job.fieldValuesFile):
        job.fieldValuesString = system.readFile(job.fieldValuesFile)
    else: discard

    if not isNil(job.fieldValuesString):
        if job.fieldValuesString =~ fieldSpecsPattern:
            job.fieldValues = lc[readFieldValueSpec(job, spec)|(spec <- matches, not isNil(spec)), FieldValueSpec]
        else:
            raise newException(ValueError, "Invalid replacement values specified: $#" % job.fieldValuesString)
    else: discard


proc initializeFieldSpecs(job: ShowJob) =
    if not isNil(job.fieldsString):
        if job.fieldsString =~ fieldSpecsPattern:
            job.fields =  lc[readFieldSpec(job, spec)|(spec <- matches, not isNil(spec)), FieldSpec]
            job.maxLineTypeIndex = maxLineTypeIndex(job.fields)
        else:
            raise newException(ValueError, "Invalid fields specification: $#." % job.fieldsString)
    else:
        raise newException(ValueError, "Missing fields specification.")


proc initializeSelectionQualifier(job: SelectiveJob) =
    if not isNil(job.selectionQualifierString):
        job.selectionQualifier = job.docType.parseQualifier(job.selectionQualifierString)
    else: discard


proc initializeReplacementQualifier(job: CopyJob) =
    if not isNil(job.replacementQualifierString):
        job.replacementQualifier = job.docType.parseQualifier(job.replacementQualifierString)
    else: discard



proc determineDebRecVersion(input: Stream): DebtorRecordVersion =
   var i: int = 0
   var line = ""
   result = drvDefault
   while input.readLine(line) and i < 50:
      i = i + 1
      if isDebtorLine(line):
         if line.matchesDebtorRecordVersion(drvSB1):
            result = drvSB1
            break
         elif line.matchesDebtorRecordVersion(drvSB2):
            result = drvSB2
            break
         else: discard

proc loadDocumentType(job: DocumentJob) =
   var debRecVsn = drvDefault
   let input = newFileStream(job.documentPath, fmRead)
   var line: string = ""
   var i = 0
   if input.readLine(line):
       if line.startswith(cTopLineId):
          job.docType = fetch_doctype(line)
       job.debRecVersion = determineDebRecVersion(input)
   close(input)
   loadDebtorRecordType(job.docType, debRecVsn)
   job.accumulator = newAccumulator(job.docType)

proc checkLine(job: DocumentJob, line: string) =
    if line.isDebtorLine and not line.matchesDebtorRecordVersion(job.debRecVersion):
        raise newException(ValueError, "Encountered line with unexpected debtor record version on line $#." % intToStr(job.lineNr))
    else: discard

proc run(job: VektorJob) =
    showHelp("none")

proc run(job: ShowJob) =
    job.loadDocumentType()
    job.initializeFieldSpecs()
    job.initializeSelectionQualifier()

    let input = newFileStream(job.documentPath, fmRead)
    var line: string = ""
    if input.readLine(line):
        job.initializeContext(line)
        let outStream = newFileStream(stdout)
        job.printHeaders(outStream)
        conditionallyPrintLine(job, outStream)
        while input.readLine(line):
            job.checkLine(line)
            job.addLine(line)
            job.conditionallyPrintLine(outStream)
        stderr.writeLine ( "Totals |$#" % [job.accumulator.asString()] )
    else:
        raise newException(DocumentReadError, "Could not read document: $#" % job.documentPath)
    input.close()

proc run(job: var CopyJob) =
    job.loadDocumentType()
    job.initializeFieldValueSpecs()
    job.initializeSelectionQualifier()
    job.initializeReplacementQualifier()

    let input = newFileStream(job.documentPath, fmRead)
    var line: string = ""
    if input.readLine(line):
        job.initializeContext(line)
        stderr.writeline("Document type: $#, SB311v$#" % [summary(job.docType), repr(job.debRecVersion)])
        var outStream: Stream = newFileStream(job.outputPath, fmWrite)
        if not isNil(outStream):
            job.mutateAndWrite(outStream)
            while input.readLine(line):
                job.checkLine(line)
                job.addLine(line)
                job.mutateAndWrite(outStream)
            outStream.close()
        else:
            raise newException(DocumentWriteError, "Could not write to file: $#" % job.outputPath)
    else:
        raise newException(DocumentReadError, "Could not read document: $#" % job.documentPath)

    input.close()

proc run(job: ValidateJob) =
    loadDocumentType(job)
    var errors: seq[ValidationResult] = @[]

    let input = newFileStream(job.documentPath, fmRead)
    var line: string = ""
    if input.readLine(line):
        while input.readLine(line) and errors.len < cMaxErrors:
            if line.lineHasId(cBottomLineId):
                job.validateBottomLine(line, errors)
            else:
                job.validate(line, errors)
    else:
        raise newException(DocumentReadError, "Could not read document: $#" % job.documentPath)
    input.close()

    if errors.len == 0:
        stderr.writeLine( "OK.")
    else:
        for error in errors:
            echo error.asString()


proc run(job: InfoJob) =
    let outStream = newFileStream(stdout)
    writeInfo(job, outStream)


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

proc readConfigurationFile() =
    let path = getConfigPath()
    if existsFile(path):
        let jsonNode = system.readFile(path).parseJson()
        gAppConfig = readAppConfig(jsonNode)
    else:
        gAppConfig = AppConfig(dataDir: defaultDataDir(), logFile: defaultLogPath())
        #quit("Vektor configuration file not found at: $#\nMaybe you forgot to set the VEKTOR_CONFIG environment variable?" % path)

try:
    randomize()
    readConfigurationFile()
    initializeExpressionReaders()
    readDocumentTypes()

    var cmdLineOptions = initOptParser()
    var job = readJob(cmdLineOptions)
    case job.name
    of "info":
        InfoJob(job).run()
except Exception:
    quit(getCurrentExceptionMsg())
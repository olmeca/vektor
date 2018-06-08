import os, parseopt2, strutils, sequtils, json, future, streams, random, pegs, times, tables, logging
import "doctypes", "context", "qualifiers", "common", "accumulator", "vektorhelp", "validation", "formatting", "expressions", "expressionsreader", "vektorjson", "jobs", "copyjob", "infojob", "showjob", "utils"

const
   msgDocVersionMissing = "For information on a document type you also need to specify a version (e.g. -v:1.0)"
   msgSourceOrDestMissing = "You need to specify a source file and a destination file (e.g: vektor copy source.asc dest.asc -e:...)."
   msgCommandMissing = "Please specify one of the following commands: info, show, copy or help."
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


proc hasOwnRandomizationContext(line: string): bool =
   let lineIdNr = parseInt(line[0..1])
   lineIdNr <= 2 or lineIdNr == 99


proc fetch_doctype(line: string): DocumentType =
   let typeId = parseInt(line[2 .. 4])
   let version = parseInt(line[5 .. 6])
   let subversion = parseInt(line[7 .. 8])
   getDocumentType(typeId, version, subversion)


proc showHelp(subject: string) =
   try:
       echo helpSubjects[subject]
   except KeyError:
      echo "There is no help on subject '$#'" % [subject]


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

        job.printHorLine(outStream)
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
    of cCommandInfo:
        InfoJob(job).run()
    of cCommandShow:
        ShowJob(job).run()
    of cCommandValidate:
        ValidateJob(job).run()
    of cCommandCopy:
        var copyJob = CopyJob(job)
        copyJob.run()
except Exception:
    quit(getCurrentExceptionMsg())
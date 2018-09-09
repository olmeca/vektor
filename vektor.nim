import os, parseopt2, strutils, sequtils, json, future, streams, random, pegs, times, tables, logging
import "doctypes", "context", "qualifiers", "common", "accumulator", "vektorhelp", "validation", "formatting", "expressions", "expressionsreader", "vektorjson", "jobs", "copyjob", "infojob", "showjob", "validatejob", "utils"

const
   msgDocVersionMissing = "For information on a document type you also need to specify a version (e.g. -v:1.0)"
   msgSourceOrDestMissing = "You need to specify a source file and a destination file (e.g: vektor copy source.asc dest.asc -e:...)."
   msgCommandMissing = "Please specify one of the following commands: info, show, copy or help."
   cDefaultLogLevel = lvlDebug

proc activateLogging() =
   let filePath = getVektorLogPath()
   var fileLogger = newFileLogger(filePath, fmtStr = verboseFmtStr)
   addHandler(fileLogger)
   setLogFilter(cDefaultLogLevel)

proc setLoggingLevel(level: Level) =
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



proc run(job: VektorJob) =
    showHelp("none")

proc backupPath(filePath: string): string =
    "$#.bak" % filePath

proc createBackup(filePath: string) =
    if existsFile(filePath):
        copyFile(filePath, backupPath(filePath))
    else:
        raise newException(ValueError, "File does not exist: $#" % filePath)

proc restoreBackup(filePath: string) =
    let backup = backupPath(filePath)
    if existsFile(backup):
        removeFile(filePath)
        moveFile(backup, filePath)
    else:
        raise newException(ValueError, "No backup file exists for: $#" % filePath)

proc run(job: RevertJob) =
    restoreBackup(job.documentPath)

proc run(job: ShowJob) =
    setLoggingLevel(job.logLevel)
    job.loadDocumentType()
    job.initializeFieldSpecs()
    job.initializeSelectionQualifier()

    let input = newFileStream(job.documentPath, fmRead)
    let output = newFileStream(stdout)
    var line: string = ""
    job.process(input, output)
    input.close()

proc checkOutputPath(job: var CopyJob) =
    if isNil(job.outputPath):
        createBackup(job.documentPath)
        job.outputPath = job.documentPath
    else: discard

proc run(job: var CopyJob) =
    setLoggingLevel(job.logLevel)
    job.loadDocumentType()
    job.initializeFieldValueSpecs()
    job.initializeSelectionQualifier()
    job.initializeReplacementQualifier()
    job.checkOutputPath()

    let inStream = newFileStream(job.documentPath, fmRead)
    var outStream: Stream = newFileStream(job.outputPath, fmWrite)
    if isNil(outStream):
        raise newException(DocumentWriteError, "Could not write to path: $#" % job.documentPath)
    else:
        try:
            job.process(inStream, outStream)
        except:
            raise
        finally:
            if not isNil(inStream): inStream.close() else: discard
            outStream.close()


proc run(job: ValidateJob) =
    setLoggingLevel(job.logLevel)
    loadDocumentType(job)
    var errors: seq[ValidationResult] = @[]

    let input = newFileStream(job.documentPath, fmRead)
    errors = job.validate(input)
    input.close()

    if errors.len == 0:
        stderr.writeLine( "OK.")
    else:
        for error in errors:
            echo error.asString()


proc run(job: InfoJob) =
    setLoggingLevel(job.logLevel)
    let outStream = newFileStream(stdout)
    writeInfo(job, outStream)


proc readConfigurationFile() =
    let configFilePath = getConfigPath()
    if existsFile(configFilePath):
        let inStream = newFileStream(configFilePath, fmRead)
        setAppConfig(readProperties(inStream))
        inStream.close()
    else:
        initDefaultAppConfig()



try:
    randomize()
    readConfigurationFile()
    activateLogging()
    initializeExpressionReaders()
    readDocumentTypes()

    var cmdLineOptions = initOptParser()
    var job = readJob(cmdLineOptions)
    case job.name
    of cCommandInfo:
        InfoJob(job).run()
    of cCommandShow:
        ShowJob(job).run()
    of cCommandRevert:
        RevertJob(job).run()
    of cCommandValidate:
        ValidateJob(job).run()
    of cCommandCopy, cCommandEdit:
        var copyJob = CopyJob(job)
        copyJob.run()
except Exception:
    quit(getCurrentExceptionMsg())
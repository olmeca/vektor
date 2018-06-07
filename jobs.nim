import os, logging, sets, strutils, sequtils, parseopt2
import "common", "qualifiers", "doctypes", "accumulator", "context"

const cCommandInfo = "info"
const cCommandShow = "show"
const cCommandCopy = "copy"
const cCommandValidate = "validate"
const cCommandHelp = "help"

const cParamNameFieldsString* = 'e'
const cParamNameFieldsFile* = 'E'
const cParamNameFieldValuesString* = 'r'
const cParamNameFieldValuesFile* = 'R'
const cParamNameSelection* = 's'
const cParamNameCondition* = 'c'
const cParamNameOutputPath* = 'o'
const cParamNameDebugLevel* = 'D'
const cParamNameLineId* = 'l'

const cCommonParamSet = { cParamNameDebugLevel }
const cInfoParamSet = cCommonParamSet + { cParamNameLineId }
const cSelectiveParamSet = cCommonParamSet + { cParamNameSelection }
const cCopyParamSet = cSelectiveParamSet + { cParamNameCondition, cParamNameFieldValuesString, cParamNameFieldValuesFile, cParamNameOutputPath }
const cShowParamSet = cSelectiveParamSet + { cParamNameFieldsString, cParamNameFieldsFile }

const cHelpParamCount = 1
const cHelpParamIndexSubject = 0

const cInfoParamCount = 2
const cInfoParamIndexDocTypeName = 0
const cInfoParamIndexDocTypeVersion = 1

const cCommonParamIndexDocument = 0

type
    VektorJob* = ref VektorJobObject
    VektorJobObject = object of RootObj
        name*: string
        logLevel*: Level
        applyIndexedImpl: proc (job: VektorJob, param: JobParam)
        applyNamedImpl: proc (job: VektorJob, param: NamedJobParam)
        initializeImpl: proc (job: VektorJob)
        runImpl*: proc(job: VektorJob)
        paramNames: set[char]
        paramIndex: int
        maxParamIndex: int

    HelpJob* = ref HelpJobObject
    HelpJobObject = object of VektorJobObject
        subject*: string

    DocTypeJob = ref DocTypeJobObject
    DocTypeJobObject = object of VektorJobObject
        docType*: DocumentType

    InfoJob* = ref InfoJobObject
    InfoJobObject = object of DocTypeJobObject
        docTypeName*: string
        docTypeVersion*: int
        docTypeSubversion*: int
        lineId*: string


    DocumentJob* = ref DocumentJobObject
    DocumentJobObject = object of DocTypeJobObject
        documentPath*: string
        debRecVersion*: DebtorRecordVersion
        accumulator*: Accumulator
        context*: Context
        lineNr*: int

    ValidateJob* = ref object of DocumentJob

    SelectiveJob* = ref SelectiveJobObject
    SelectiveJobObject = object of DocumentJobObject
        selectionQualifier*: LineQualifier
        selectionQualifierString*: string

    ShowJob* = ref ShowJobObject
    ShowJobObject = object of SelectiveJobObject
        fieldsString*: string
        fieldsConfigKey*: string
        fields*: seq[FieldSpec]
        maxLineTypeIndex*: int

    CopyJob* = ref CopyJobObject
    CopyJobObject = object of SelectiveJobObject
        fieldValuesString*: string
        fieldValuesFile*: string
        fieldValues*: seq[FieldValueSpec]
        replacementQualifierString*: string
        replacementQualifier*: LineQualifier
        outputPath*: string

    JobParam = ref JobParamObject
    JobParamObject = object of RootObj
        rawValue: string
        apply: proc(param: JobParam, job: VektorJob)

    NamedJobParam = ref NamedJobParamObject
    NamedJobParamObject = object of JobParamObject
        name: char

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
      raise newException(ValueError, $("Invalid logging level: $#", level))

proc initialize(job: VektorJob) =
    job.initializeImpl(job)

proc applyIndexedParam(job: VektorJob, param: JobParam) =
    if job.paramIndex > job.maxParamIndex:
        raise newException(ValueError, "Too many parameters specified.")
    job.applyIndexedImpl(job, param)

proc applyNamedParam(job: VektorJob, param: NamedJobParam) =
    if job.paramNames.contains(param.name):
        job.applyNamedImpl(job, param)
    else:
        raise newException(ValueError, $("Invalid parameter '$#' for command '$#'", param.name, job.name))

proc applyVektorJobNamedParam(job: VektorJob, param: NamedJobParam) =
    case param.name
    of cParamNameDebugLevel:
        job.logLevel = readLogLevel(param.rawValue)
    else:
        raise newException(ValueError, $("Unknown parameter: $#", param.name))

proc applyHelpJobIndexedParam(job: VektorJob, param: JobParam) =
    let helpJob = HelpJob(job)
    if job.paramIndex == cHelpParamIndexSubject:
        helpJob.subject = param.rawValue
        inc(helpJob.paramIndex)

proc setDocTypeVersion(job: InfoJob, version: string) =
    if not isNil(version):
        if len(version) == 1 and isDigit(version):
            job.docTypeVersion = parseInt(version)
        else:
            let items = version.split('.')
            job.docTypeVersion = parseInt(items[0])
            job.docTypeSubversion = parseInt(items[1])
    else: discard

proc isVersionSpecified*(job: InfoJob): bool =
    job.docTypeVersion != -1


proc applyInfoJobIndexedParam(job: VektorJob, param: JobParam) =
    let infoJob = InfoJob(job)
    case job.paramIndex
    of cInfoParamIndexDocTypeName:
        infoJob.docTypeName = param.rawValue
        inc(infoJob.paramIndex)
    of cInfoParamIndexDocTypeVersion:
        infoJob.setDocTypeVersion(param.rawValue)
        inc(infoJob.paramIndex)
    else:
        raise newException(ValueError, "Too many parameters for command '$#'" % [job.name])

proc applyInfoJobNamedParam(job: VektorJob, param: NamedJobParam) =
    let infoJob = InfoJob(job)
    case param.name
    of cParamNameLineId:
        infoJob.lineId = param.rawValue
    else:
        applyVektorJobNamedParam(job, param)

proc apply*(param: JobParam, job: VektorJob) =
    applyIndexedParam(job, param)

proc apply*(param: NamedJobParam, job: VektorJob) =
    applyNamedParam(job, param)

proc newJobParam*(value: string): JobParam =
    JobParam(rawValue: value)

proc newNamedJobParam*(name: char, value: string): NamedJobParam =
    NamedJobParam(name: name, rawValue: value)

proc applyDocJobIndexedParam (job: VektorJob, param: JobParam) =
    let docJob = DocumentJob(job)
    if job.paramIndex == cCommonParamIndexDocument:
        if isNil(param.rawValue):
            raise newException(ValueError, "No input file specified.")
        else:
            docJob.documentPath = param.rawValue
            inc(docJob.paramIndex)

proc applySelectiveJobNamedParam(job: VektorJob, param: NamedJobParam) =
    let selJob = SelectiveJob(job)
    case param.name
    of cParamNameSelection:
        selJob.selectionQualifierString = param.rawValue
    else:
        applyVektorJobNamedParam(job, param)

proc applyShowJobNamedParam(job: VektorJob, param: NamedJobParam) =
    let showJob = ShowJob(job)
    case param.name
    of cParamNameFieldsString:
        showJob.fieldsString = param.rawValue
    of cParamNameFieldsFile:
        showJob.fieldsConfigKey = param.rawValue
    else:
        applySelectiveJobNamedParam(job, param)

proc applyCopyJobNamedParam(job: VektorJob, param: NamedJobParam) =
    let copyJob = CopyJob(job)
    case param.name
    of cParamNameFieldValuesString:
        copyJob.fieldValuesString = param.rawValue
    of cParamNameFieldValuesFile:
        copyJob.fieldValuesFile = param.rawValue
    of cParamNameCondition:
        copyJob.replacementQualifierString = param.rawValue
    of cParamNameOutputPath:
        copyJob.outputPath = param.rawValue
    else:
        applySelectiveJobNamedParam(job, param)

proc newInfoJob*(): InfoJob =
    new(result)
    result.name = "info"
    result.paramNames = cInfoParamSet
    result.maxParamIndex = 1
    result.applyIndexedImpl = applyInfoJobIndexedParam
    result.applyNamedImpl = applyInfoJobNamedParam
    result.docTypeVersion = -1
    result.docTypeSubversion = -1

proc newHelpJob*(): HelpJob =
    new(result)
    result.name = "help"
    result.paramNames = { }
    result.applyIndexedImpl = applyHelpJobIndexedParam
    result.applyNamedImpl = applyVektorJobNamedParam

proc newShowJob*(): ShowJob =
    new(result)
    result.name = "show"
    result.paramNames = cShowParamSet
    result.applyIndexedImpl = applyDocJobIndexedParam
    result.applyNamedImpl = applyShowJobNamedParam

proc newCopyJob*(): CopyJob =
    new(result)
    result.paramNames = cCopyParamSet
    result.name = "copy"
    result.applyIndexedImpl = applyDocJobIndexedParam
    result.applyNamedImpl = applyCopyJobNamedParam

proc createJobForCommand(cmdString: string): VektorJob =
    case cmdString
    of "info":
        result = newInfoJob()
    of "help":
        result = newHelpJob()
    of "show":
        result = newShowJob()
    of "copy":
        result = newCopyJob()
    else:
        raise newException(ValueError, "Invalid command: $#" % cmdString)

proc createNamedParam(key: string, value: string): NamedJobParam =
    if len(key) > 1:
        raise newException(ValueError, "Invalid command option: $#" % key)
    elif isNil(value) or len(value) == 0:
        raise newException(ValueError, "Missing value for option: $#" % key)
    else:
        result = newNamedJobParam(toSeq(key.items)[0], value)


proc readJob*(parser: var OptParser): VektorJob =
    for kind, key, value in getopt(parser):
        case kind
        of cmdArgument:
            if isNil(result):
                result = createJobForCommand(key)
            else:
                let param = newJobParam(key)
                apply(param, result)
        of cmdShortOption:
            if isNil(result):
                raise newException(ValueError, "Missing vektor command.")
            else:
                let param = createNamedParam(key, value)
                apply(param, result)
        else:
            raise newException(ValueError, "Invalid command option: $#" % key)

proc initializeContext*(job: DocumentJob, line: string) =
    let topLineType = job.docType.getLineTypeForLineId(cTopLineId)
    job.context = createContext(job.docType, topLineType, line)
    job.lineNr = 1

proc addLine*(job: DocumentJob, line: string) =
    job.accumulator.addLine(line)
    if not isNil(job.context):
        job.context.addLine(line)
    else: discard
    inc(job.lineNr)
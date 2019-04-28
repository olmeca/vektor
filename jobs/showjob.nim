import os, parseopt, strutils, sequtils, json, sugar, streams, random, pegs, times, tables, logging

import doctype, context, qualifiers, expressions, common, accumulator, job, utils, formatting, formatters, lineparsing, serialization

const cParamNameFieldsString = 'e'
const cParamNameFieldSet = 'E'
const cParamNameShowTotals = 't'
const
   cShowParamSet = cSelectiveParamSet + { cParamNameFieldsString, cParamNameFieldSet, cParamNameShowTotals }

   gTableLinePrefix = "| "
   gTableLineInfix = " | "
   gTableLinePostfix = " |"


proc maxLineTypeIndex(fields: seq[FieldSpec]): int =
   foldl(fields, max(a, parseInt(getLineId(b.leType.lineElementId))), 0)

proc toString(fs: FieldSpec): string =
   "FieldSpec leId: $#" % [fs.leType.lineElementId]

proc readFieldSpec(job: ShowJob, spec: string): FieldSpec =
   if spec =~ fieldSpecPattern:
      let leTypeId = matches[0]
      let leTypeTitle = matches[1]
      checkProcessableLineType(leTypeId)
      let leType = job.docType.getLineElementType(leTypeId)
      result = FieldSpec(leType: leType, leTitle: leTypeTitle)
   else:
      raise newException(FieldSpecError, "Invalid line element specification: '$#'" % [spec])

proc initializeFieldSpecs*(job: ShowJob) =
    if job.fieldsString == "":
        if job.fieldsConfigKey == "":
            # Check for a default configuration that can be used
            let configKey = "fieldset.$#" % job.docType.name
            try:
                job.fieldsString = getAppConfig(configKey)
            except KeyError:
                raise newException(ValueError, "Missing fields specification. Please specify the fields.")
        else:
            let configKey = "fieldset.$#.$#" % [job.docType.name, job.fieldsConfigKey]
            job.fieldsString = getAppConfig(configKey)
    else: discard
    job.formatter = newReadableFieldFormatter()

    if job.fieldsString != "":
        if job.fieldsString =~ fieldSpecsPattern:
            job.fields =  lc[readFieldSpec(job, spec)|(spec <- matches, spec != ""), FieldSpec]
            job.maxLineTypeIndex = maxLineTypeIndex(job.fields)
        else:
            raise newException(ValueError, "Invalid fields specification: $#." % job.fieldsString)
    else:
        raise newException(ValueError, "Missing fields specification. Please specify the fields.")

proc colwidth(leType: LineElementType): int =
    case leType.valueType
    of DateValueType:
        leType.length + 2
    of SignedAmountValueType:
        leType.length
    of UnsignedAmountValueType:
        leType.length
    else:
        leType.length


proc columnTitle(field: FieldSpec): string =
    if field.leTitle == "": field.leType.lineElementId else: field.leTitle


proc length(field: FieldSpec): int =
    max(colwidth(field.leType), field.columnTitle.len)

proc getHeaderForField(field: FieldSpec, job: ShowJob): string =
   let colWidth = field.length
   let leType = field.leType
   let leTitle = if field.leTitle == NIL: leType.lineElementId else: field.leTitle
   if colWidth >= leTitle.len:
      if leType.isNumericType or leType.isAmountType:
         leTitle|R(colWidth)
      else:
         leTitle|L(colWidth)
   else:
      spaces(colWidth)


proc serializeField(field: FieldSpec, job: ShowJob): string =
    let context = job.context.contextWithLineId(getLineId(field.leType.lineElementId))
    let lineElement = parse(field.leType, context.line)
    job.formatter.format(lineElement.value, field.length)

proc tabularLine(job: ShowJob, serialize: proc(field: FieldSpec, job: ShowJob): string,
                  prefix: string, infix: string, postfix: string): string =
   let values = lc[serialize(field, job) | (field <- job.fields), string]
   result = prefix & values.join(infix) & postfix

proc printColumnHeaders(job: ShowJob, stream: Stream) =
   stream.write(tabularLine(job, getHeaderForField, gTableLinePrefix, gTableLineInfix, gTableLinePostfix))
   stream.write("\n")


proc printLine*(job: ShowJob, stream: Stream) =
   debug("showjob.printLine: linenr: $#, rootCtx: $#, ctx: $#" % [intToStr(job.lineNr), $(job.context), $(job.context.current())])
   stream.write(tabularLine(job,
                            serializeField,
                            gTableLinePrefix,
                            gTableLineInfix,
                            gTableLinePostfix))
   stream.write("\n")

proc printHorLine*(job: ShowJob, stream: Stream) =
   stream.write("+-")
   var index = 0
   for field in job.fields:
      stream.write(repeat('-', Natural(field.length)))
      index = index + 1
      if index < job.fields.len:
         stream.write("-+-")
      else:
         stream.write("-+\n")

proc printHeaders*(job: ShowJob, stream: Stream) =
    job.printHorLine(stream)
    job.printColumnHeaders(stream)
    job.printHorLine(stream)

proc conditionallyPrintLine*(job: ShowJob, outStream: Stream) =
   var rootContext = job.context
   let currentContext = rootContext.current()
   var tempStream = newStringStream()
   # Do not print subtypes of the subbest record type in the field specs (index > maxLineTypeIndex)
   debug("showjob.conditionallyPrintLine: rootCtx: $#, currentContext: $#" % [$(rootContext), $(currentContext)])
   if currentContext.lineType.index <= job.maxLineTypeIndex and rootContext.conditionIsMet(job.selectionQualifier):
      try:
         printLine(job, tempStream)
         outStream.write(tempStream.data)
         if not isNil(job.accumulator):
            job.accumulator.accumulate(rootContext)
      except ContextWithLineIdNotFoundError:
         debug(">>>>>> Referring to line id '$#' out of context." % [currentContext.lineType.lineId])

proc process*(job: ShowJob, input: Stream, output: Stream) =
    debug("showjob.process entered")
    var line: string = NIL
    if input.readLine(line):
        job.initializeContext(line)
        job.printHeaders(output)
        conditionallyPrintLine(job, output)
        while input.readLine(line):
            job.addLine(line)
            job.conditionallyPrintLine(output)

        job.printHorLine(output)
        if job.printTotals:
            let totalsline = job.accumulator.asString()
            let bottomline = repeat('-', len(totalsline) + 10)
            output.writeLine ( "| Totals |$# |" %  totalsline)
            output.writeline("+$#+" % bottomline)
    else:
        raise newException(DocumentReadError, "Could not read from stream.")


proc applyShowJobNamedParam(job: VektorJob, param: NamedJobParam) =
    debug("applyShowJobNamedParam: $#" % [$param])
    let showJob = ShowJob(job)
    showJob.printTotals = false
    case param.name
    of cParamNameFieldsString:
        showJob.fieldsString = param.rawValue
    of cParamNameFieldSet:
        showJob.fieldsConfigKey = param.rawValue
    of cParamNameShowTotals:
        showJob.printTotals = true
    else:
        applySelectiveJobNamedParam(job, param)


proc initializeShowJob*(job: VektorJob) =
    initializeSelectiveJob(job)
    ShowJob(job).initializeFieldSpecs()


proc newShowJob*(): ShowJob =
    new(result)
    result.name = cCommandShow
    result.paramNames = cShowParamSet
    result.applyIndexedImpl = applyDocJobIndexedParam
    result.applyNamedImpl = applyShowJobNamedParam
    result.initializeImpl = initializeShowJob
    result.logLevel = lvlNone


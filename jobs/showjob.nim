import os, parseopt, strutils, sequtils, json, sugar, streams, random, pegs, times, tables, logging

import doctype, context, qualifiers, expressions, common, accumulator, job, utils, formatting

const
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
        leType.length # + 2
    of SignedAmountValueType:
        leType.length # + 2
    of UnsignedAmountValueType:
        leType.length # + 1
    else:
        leType.length


proc columnTitle(field: FieldSpec): string =
    if field.leTitle == "": field.leType.lineElementId else: field.leTitle


proc length(field: FieldSpec): int =
    max(colwidth(field.leType), field.columnTitle.len)

proc getHeaderForField(field: FieldSpec): string =
   let colWidth = field.length
   let leType = field.leType
   let leTitle = if field.leTitle == "": leType.lineElementId else: field.leTitle
   if colWidth >= leTitle.len:
      if leType.isNumericType or leType.isAmountType:
         leTitle|R(colWidth)
      else:
         leTitle|L(colWidth)
   else:
      spaces(colWidth)

proc tabularLine(ctx: Context, fields: seq[FieldSpec], stringValue: proc(field: FieldSpec): string,
                  prefix: string, infix: string, postfix: string): string =
   let values = lc[stringValue(field) | (field <- fields), string]
   result = prefix & values.join(infix) & postfix

proc printColumnHeaders(job: ShowJob, stream: Stream) =
   stream.write(tabularLine(job.context, job.fields, getHeaderForField, gTableLinePrefix, gTableLineInfix, gTableLinePostfix))
   stream.write("\n")

proc pad(value: string, field: FieldSpec): string =
    if field.leType.isNumeric or field.leType.isAmountType:
        value|R(field.length)
    else:
        value|L(field.length)

proc printLine*(job: ShowJob, stream: Stream) =
   stream.write(tabularLine(job.context, job.fields,
                            proc (fs: FieldSpec): string = pad(getElementValueFullString(job.context, fs.leType), fs),
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
   if currentContext.lineType.index <= job.maxLineTypeIndex and rootContext.conditionIsMet(job.selectionQualifier):
      try:
         printLine(job, tempStream)
         outStream.write(tempStream.data)
         if not isNil(job.accumulator):
            job.accumulator.accumulate(rootContext)
      except ContextWithLineIdNotFoundError:
         debug(">>>>>> Referring to line id '$#' out of context." % [currentContext.lineType.lineId])

proc process*(job: ShowJob, input: Stream, output: Stream) =
    var line: string = ""
    if input.readLine(line):
        job.initializeContext(line)
        job.printHeaders(output)
        conditionallyPrintLine(job, output)
        while input.readLine(line):
            job.addLine(line)
            job.conditionallyPrintLine(output)

        job.printHorLine(output)
        #stderr.writeLine ( "Totals |$#" % [job.accumulator.asString()] )
    else:
        raise newException(DocumentReadError, "Could not read from stream.")

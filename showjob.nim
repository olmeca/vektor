import os, parseopt2, strutils, sequtils, json, future, streams, random, pegs, times, tables, logging

import "doctypes", "context", "qualifiers", "expressions", "common", "accumulator", "jobs", "utils", "formatting"

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
      checkProcessableLineType(leTypeId)
      let leType = job.docType.getLineElementType(leTypeId)
      result = FieldSpec(leType: leType)
   else:
      raise newException(FieldSpecError, "Invalid line element specification: '$#'" % [spec])

proc initializeFieldSpecs*(job: ShowJob) =
    if not isNil(job.fieldsString):
        if job.fieldsString =~ fieldSpecsPattern:
            job.fields =  lc[readFieldSpec(job, spec)|(spec <- matches, not isNil(spec)), FieldSpec]
            job.maxLineTypeIndex = maxLineTypeIndex(job.fields)
        else:
            raise newException(ValueError, "Invalid fields specification: $#." % job.fieldsString)
    else:
        raise newException(ValueError, "Missing fields specification.")

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

proc printColumnHeaders(job: ShowJob, stream: Stream) =
   stream.write(tabularLine(job.context, job.fields, getHeaderForField, gTableLinePrefix, gTableLineInfix, gTableLinePostfix))
   stream.write("\n")

proc printLine*(job: ShowJob, stream: Stream) =
   stream.write(tabularLine(job.context, job.fields,
                            proc (fs: FieldSpec): string = getElementValueFullString(job.context, fs.leType.lineElementId),
                            gTableLinePrefix,
                            gTableLineInfix,
                            gTableLinePostfix))
   stream.write("\n")

proc printHorLine*(job: ShowJob, stream: Stream) =
   stream.write("+-")
   var index = 0
   for field in job.fields:
      stream.write(repeat('-', Natural(field.leType.length)))
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
            accumulate(rootContext, job.accumulator)
      except ContextWithLineIdNotFoundError:
         debug(">>>>>> Referring to line id '$#' out of context." % [currentContext.lineType.lineId])


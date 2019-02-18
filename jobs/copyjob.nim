import os, parseopt, strutils, sequtils, json, sugar, streams, random, pegs, times, tables, logging

import doctype, context, qualifiers, expressions, common, accumulator, job, utils, formatting, expressionsreader, serialization




proc initializeExpressionReaders*(job: CopyJob) =
    job.expressionReader = newGeneralExpressionReader(getUserExpressionReaders())


proc readFieldValueSpec(job: CopyJob, spec: string): FieldValueSpec =
   if spec =~ fieldValueSpecPattern:
      debug("readFieldValueSpec: matches: '$#', '$#'" % [matches[0], matches[1]])
      let leTypeId = matches[0]
      checkProcessableLineType(leTypeId)
      let value = matches[1]
      let leType = job.docType.getLineElementType(leTypeId)
      if leType.isDependent():
         raise newException(FieldSpecError,
            "Setting the value of derived field '$#' is not allowed. \nSet value of field $# instead and Vektor will also update field $# accordingly." %
                [leType.lineElementId, leType.sourceId, leType.lineElementId])
      let expression = job.expressionReader.readExpression(value, leType.valueType)
      # Short circuit the following check by preemptively setting the value type correctly
      expression.valuetype = leType.valueType
      # Sanity check on interpreted expression value type
      if expression.valueType != leType.valueType and expression.valueType != EmptyValueType:
          raise newException(ExpressionError, "readFieldValueSpec: Wrong value type for field '$#'. Expected $#, but got $#" % [leType.lineElementId, $(leType.valueType), $(expression.valueType)])
      else: discard
      result = FieldValueSpec(leType: leType, value: expression)
      debug("readFieldValueSpec: leType: '$#', value: $#" % [leType.asString, expression.asString])
   else:
      raise newException(FieldSpecError, "Invalid line element specification: '$#'" % [spec])


proc initializeFieldValueSpecs*(job: CopyJob) =
    if job.fieldValuesString == "" and job.fieldValuesFile != "":
        job.fieldValuesString = system.readFile(job.fieldValuesFile)
    else: discard

    if job.fieldValuesString != "":
        if job.fieldValuesString =~ fieldSpecsPattern:
            job.fieldValues = lc[readFieldValueSpec(job, spec)|(spec <- matches, spec != ""), FieldValueSpec]
        else:
            raise newException(ValueError, "Invalid replacement values specified: $#" % job.fieldValuesString)
    else: discard

proc initializeReplacementQualifier*(job: CopyJob) =
    if job.replacementQualifierString != "":
        job.replacementQualifier = job.docType.parseQualifier(job.replacementQualifierString)
    else: discard


proc isDerivedValue(valueSpec: string): bool =
   valueSpec[0] == '@'


proc writeLineToStream(line: string, stream: Stream) =
   writeCharsToStream(toSeq(line.items), stream)

proc writeContextToStream(context: var Context, stream: Stream) =
   if context.state != csExported:
      writeLineToStream(context.line, stream)
      context.state = csExported
   for sub in context.subContexts.mvalues:
      writeContextToStream(sub, stream)

proc updateDependentLineElements(rootContext: Context, linebuffer: var openArray[char]) =
  debug("updateDependentLineElements: context $#" % [rootContext.currentSubContext.toString()])
  let context = rootContext.currentSubContext
  if context.lineType.hasDependentElements:
     debug("updateDependentLineElements: line has dependent elements")
     for leType in context.lineType.lineElementTypes:
        if leType.sourceId != NIL:
           debug("updateDependentLineElements: getting source value for '$#'" % [leType.sourceId])
           let newValue = rootContext.getSourceElementValueFullString(leType)
           debug("updateDependentLineElements: got new source value: '$#'" % [newValue])
           copyChars(lineBuffer, leType.startPosition-1, leType.length, newValue)


proc mutateAndWrite*(job: var CopyJob, outStream: Stream) =
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
            for field in job.fieldValues:
               let leType = field.leType
               if leType.isElementOfLine(context.line):
                  let newValue = field.value.evaluate(context).serialize(leType.length)
                  debug("maw: setting new value for leId '$#': '$#'" % [leType.lineElementId, newValue])
                  copyChars(lineBuffer, leType.startPosition-1, leType.length, newValue)
         else: discard

         updateDependentLineElements(rootContext, linebuffer)
         context.line = lineBuffer.toString()
         job.accumulator.accumulate(context.line)
         writeContextToStream(rootContext, outStream)

proc process*(job: var CopyJob, inStream: Stream, outStream: Stream) =
    var line: string = ""
    if inStream.readLine(line):
        job.initializeContext(line)
        # stderr.writeline("Document type: $#, SB311v$#" % [summary(job.docType), repr(job.debRecVersion)])
        job.mutateAndWrite(outStream)
        while inStream.readLine(line):
            job.checkLine(line)
            job.addLine(line)
            job.mutateAndWrite(outStream)
    else:
        raise newException(DocumentReadError, "Could not read from input.")


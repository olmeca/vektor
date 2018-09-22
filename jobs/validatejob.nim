import os, parseopt2, strutils, sequtils, json, future, streams, random, pegs, times, tables, logging, streams

import doctype, context, qualifiers, expressions, common, accumulator, job, utils, formatting, validation

const
   cMaxValidationErrors: int = 20

proc validate*(job: DocumentJob, line: string, errors: var seq[ValidationResult]) =
    job.addLine(line)
    debug("validation '$#'" % line)
    validate(job.docType, line, job.lineNr, errors)
    job.accumulate()


proc validateBottomLine*(job: DocumentJob, line: string, errors: var seq[ValidationResult]) =
    for total in job.accumulator.totals.items():
        let leType = total.leType
        let itemValue = getIntegerValue(job.docType, leType, line)
        if itemValue != total.value:
            var errorString = ""
            if total.leType.isAmountType():
                errorString = "Value of field $# ($#) not equal to the sum ($#) of $# field values." %
                              [ intToStr(itemValue), leType.description, intTostr(total.value), leType.countable ]
            else:
                errorString = "Value of field $# ($#) not equal to the number ($#) of $# records." %
                              [ intToStr(itemValue), leType.description, intTostr(total.value), getLineId(leType.countable) ]
            errors.add(ValidationResult(lineNr: job.lineNr,
                                            leId: leType.lineElementId,
                                            vrType: vrSummationError,
                                            info: errorString))
            debug("Validation error: line $#, el: $#, $#" % [intToStr(job.lineNr), leType.lineElementId, errorString])
        else: discard


proc process*(job: ValidateJob, input: Stream, errors: var seq[ValidationResult]) =
    var line: string = ""
    if input.readLine(line):
        job.initializeContext(line)
        #job.validate(line, errors)
        while input.readLine(line) and errors.len < cMaxValidationErrors:
            if line.lineHasId(cBottomLineId):
                job.validateBottomLine(line, errors)
            else:
                job.validate(line, errors)
    else:
        raise newException(DocumentReadError, "Could not read from stream.")


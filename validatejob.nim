import os, parseopt2, strutils, sequtils, json, future, streams, random, pegs, times, tables, logging, streams

import "doctypes", "context", "qualifiers", "expressions", "common", "accumulator", "jobs", "utils", "formatting", "validation"

const
   cMaxValidationErrors: int = 20

proc validate*(job: DocumentJob, line: string, errors: var seq[ValidationResult]) =
    job.addLine(line)
    validate(job.docType, line, job.lineNr, errors)


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
        else: discard


proc validate*(job: ValidateJob, input: Stream): seq[ValidationResult] =
    var errors: seq[ValidationResult] = @[]
    var line: string = ""
    while input.readLine(line) and errors.len < cMaxValidationErrors:
        if line.lineHasId(cBottomLineId):
            job.validateBottomLine(line, errors)
        else:
            job.validate(line, errors)
    result = errors

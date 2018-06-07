import strutils
import "common", "doctypes", "jobs", "accumulator"

proc validate(leType: LineElementType, line: string, nr: int, errors: var seq[ValidationResult]) =
   let stringValue = line.getElementValueString(leType)
   if leType.isEmptyValue(stringValue):
      if leType.isValueMandatory:
         errors.add(ValidationResult(lineNr:nr, 
                                    leId: leType.lineElementId, 
                                    vrType: vrMissingFieldValue, 
                                    info: "Empty value not allowed: '$#'" % [stringValue]))
      else: discard
   else:
      if leType.isNumeric:
         if leType.isDate:
            try:
               let date = parseVektisDate(stringValue)
            except ValueError:
               errors.add(ValidationResult(lineNr:nr, 
                                             leId: leType.lineElementId, 
                                             vrType: vrInvalidFieldValue, 
                                             info: "Invalid date: '$#'" % [stringValue]))
         else:
            if not stringValue.isDigit:
               errors.add(ValidationResult(lineNr:nr, 
                                             leId: leType.lineElementId, 
                                             vrType: vrInvalidFieldValue, 
                                             info: "Invalid number: '$#'" % [stringValue]))
      else: discard


proc validate*(docType: DocumentType, line: string, nr: int, errors: var seq[ValidationResult]) = 
   if line.len != docType.lineLength:
      errors.add(ValidationResult(lineNr: nr, 
                                    leId: nil, 
                                    vrType: vrInvalidLineLength, 
                                    info: "Line length is $# but should be $#" % [intToStr(line.len), intToStr(docType.lineLength)]))

   for leType in docType.getLineTypeForLine(line).lineElementTypes:
      leType.validate(line, nr, errors)

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

import strutils
import common, doctype, job, accumulator

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
            if not stringValue.isNumericString:
               errors.add(ValidationResult(lineNr:nr, 
                                             leId: leType.lineElementId, 
                                             vrType: vrInvalidFieldValue, 
                                             info: "Invalid number: '$#'" % [stringValue]))
      else: discard


proc validate*(docType: DocumentType, line: string, nr: int, errors: var seq[ValidationResult]) = 
   if line.len != docType.lineLength:
      errors.add(ValidationResult(lineNr: nr, 
                                    leId: "",
                                    vrType: vrInvalidLineLength, 
                                    info: "Line length is $# but should be $#" % [intToStr(line.len), intToStr(docType.lineLength)]))

   for leType in docType.getLineTypeForLine(line).lineElementTypes:
      leType.validate(line, nr, errors)


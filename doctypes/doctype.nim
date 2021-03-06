import os, ospaths, sugar, sequtils, strutils, logging, tables, times
import common, codeddoctypes, formatting, utils

type
   DocTypeSpec* = tuple[typeId: int, version: int, subversion: int, debtorType: DebtorRecordVersion]

const 
   cDebtorRecordLineId* = "03"
   cDebtorRecordVersionStartIndex = 297
   cDebtorRecordVersionEndIndex = 298
   cSB311v0 = "  "
   cSB311v1 = "01"
   cSB311v2 = "02"
   cStandardLineLength = 310

var
   gDocTypes: seq[DocumentType]
   gDebtorRecordTypes: seq[DocumentType]
   
#let gDocTypes = lc[readDocumentType(node) | (node <- getJsonData(cDocTypesJsonFileName)), DocumentType]
#let gDebtorRecordTypes = lc[readDocumentType(node) | (node <- getJsonData(cSB311TypesJsonFileName)), DocumentType]

proc `$`(spec: DocTypeSpec): string =
    let (tid, version, sub, drv) = spec
    "(typeId: $#, version: $#, sub: $#, debRecType: $#)" % [intToStr(tid), intToStr(version), intToStr(sub), repr(drv)]

proc getLineId*(line: string): string =
   # TODO: first condition below should be superfluous if strings always initialized to empty
   if line == "" or line.len < cRecordIdSize:
      raise newException(ValueError, "Cannot get line id from '$#'" % [line])
   else:
      result = line[0 .. (cRecordIdSize - 1)]

proc lineId*(leType: LineElementType): string =
    leType.lineElementId[0..1]

proc getLineElementSubId*(leId: string): string =
   # TODO: first condition below should be superfluous if strings always initialized to empty
   if leId == "" or leId.len < cFieldIdSize:
      raise newException(ValueError, "Cannot get line element id from '$#'" % [leId])
   else:
      result = leId[cRecordIdSize .. (cFieldIdSize - 1)]

proc lineHasId*(line: string, id: string): bool =
    getLineId(line) == id

proc indexes(leId: string): array[0..1, int] =
   assert(len(leId) == cFieldIdSize)
   #assert(isDigit(leId))
   result = [parseInt(leId[0 .. cRecordIdSize - 1]), parseInt(leId[cRecordIdSize .. cFieldIdSize - 1])]

proc isDependent*(leType: LineElementType): bool =
   leType.sourceId != ""

proc toString*(version: DebtorRecordVersion): string =
   case version
   of drvDefault: cSB311v0
   of drvSB1: cSB311v1
   of drvSB2: cSB311v2

proc repr*(drv: DebtorRecordVersion): string =
   case drv
   of drvDefault: "0"
   of drvSB1: "1"
   of drvSB2: "2"

proc matchesDebtorRecordVersion*(line: string, version: DebtorRecordVersion): bool =
   line[cDebtorRecordVersionStartIndex..cDebtorRecordVersionEndIndex] == version.toString()

proc indexOfLineType*(docType: DocumentType, lineId: string): int =
   docType.lineTypes.firstIndexMatching(proc(lt: LineType): bool = lt.lineId = lineId)

proc getLineTypeForLineId*(doctype: DocumentType, lineId: string): LineType =
   #debug("getLineTypeForLineId: '$#'" % [lineId])
   let lineTypes = doctype.lineTypes.filter(proc (lt: LineType): bool = lt.lineId == lineId)
   if lineTypes.len == 0:
      raise newException(ValueError, 
         "Document $# does not have a line type with ID '$#'" % [doctype.name, lineId])
   else:
      result = lineTypes[0]

proc getLineTypeForLine*(docType: DocumentType, line: string): LineType =
    getLineTypeForLineId(docType, getLineId(line))

proc isDebtorLine*(line: string): bool =
   lineHasId(line, cDebtorLineId)

proc enableSB311Types*(lineLength: int) =
   if gDebtorRecordTypes == @[]:
      gDebtorRecordTypes = getDebtorRecordTypes(lineLength)

proc loadDebtorRecordType*(docType: DocumentType, version: DebtorRecordVersion) =
   if version != drvDefault:
      enableSB311Types(docType.lineLength)
      let chosenDebRecDocType = if version == drvSB1: gDebtorRecordTypes[0] else: gDebtorRecordTypes[1]
      # Remove default debtor record from the doc type
      docType.lineTypes.keepIf(proc (lt: LineType): bool = lt.lineId != cDebtorRecordLineId)
      # Now add the chosen debtor record line type
      docType.lineTypes.add(chosenDebRecDocType.lineTypes[0])


proc readDocumentTypes*() =
   gDocTypes = getDocumentTypes(0)

proc isOneCharRepeated(value: string, theChar: char): bool =
   result = true
   for c in toSeq(value.items):
      if c != theChar:
         result = false

proc isContentLine*(line: string): bool =
   not lineHasId(line, cTopLineId) and not lineHasId(line, cBottomLineId)

proc isTypeOfLine*(lineType: LineType, line: string): bool =
    lineHasId(line, lineType.lineId)

# TODO: refactor following functions to use VektisValueType

proc isDate*(leType: LineElementType): bool =
   leType.length == 8 and leType.code.startsWith(cDateCodePrefix)

proc isAlphaNum*(leType: LineElementType): bool =
   leType.fieldType == cFieldTypeAlphaNum

proc isNumeric*(leType: LineElementType): bool =
   leType.fieldType == cFieldTypeNumeric

proc isAmountType*(leType: LineElementType): bool = 
    leType.isNumeric() and (leType.code.startsWith(cAmountCodePrefix) or leType.code.startsWith(cCountCodePrefix))

proc isNumericType*(leType: LineElementType): bool = 
    leType.isNumeric() and leType.code.startsWith(cNumberCodePrefix)

proc isEmptyValue*(leType: LineElementType, value: string): bool =
   if value.len == 0:
      true
   elif leType.isNumeric():
      value.isOneCharRepeated('0')
   else:
      value.isOneCharRepeated(' ')

proc isValueMandatory*(leType: LineElementType): bool = 
   leType.required

proc getDocumentType*(typeId: int, version: int, subversion: int): DocumentType = 
   let matches = filter(gDocTypes, 
                        proc(t: DocumentType): bool = 
                           t.vektisEICode == typeId and 
                              t.formatVersion == version and 
                              t.formatSubVersion == subversion)
   if matches.len == 0:
      raise newException(DocumentTypeError, 
         "Unknown declatation format: Vektis EI code: '$#', version: $#, subversion: $#" % 
            [intToStr(typeId), intToStr(version), intToStr(subversion)])
   else:
      result = matches[0]

proc getDocumentType*(spec: DocTypeSpec): DocumentType =
    let (typeId, version, subversion, debRecType) = spec
    result = getDocumentType(typeId, version, subversion)
    result.loadDebtorRecordType(debRecType)


proc allDocumentTypes*(): seq[DocumentType] =
   enableSB311Types(cStandardLineLength)
   concat(gDocTypes, gDebtorRecordTypes)

proc documentTypeMatching*(name: string, version: int, subversion: int): DocumentType = 
   let matches = filter(allDocumentTypes(), 
                        proc(t: DocumentType): bool = 
                           t.name == name and 
                              t.formatVersion == version and 
                              t.formatSubVersion == subversion)
   if matches.len == 0:
      raise newException(DocumentTypeError, 
         "Unknown declaration format: name: '$#', version: $#, subversion: $#" % 
            [name, intToStr(version), intToStr(subversion)])
   else:
      result = matches[0]


proc subLineLinkWithId*(lineType: LineType, lineId: string): LineTypeLink =
   result = nil
   try:
        result = lineType.childLinks.firstItemMatching(proc(link: LineTypeLink): bool = link.subLineId = lineId)
   except(NoMatchingItemFound):
        raise newException(ChildLinkWithLineIdNotFoundError, "line type $# supports no sublines of type $#" % [lineType.lineId, lineId])

proc hasSubLineTypeWithId*(docType: DocumentType, lineType: LineType, lineId: string): bool =
   if lineType.childLinks.anyIt(it.subLineId == lineId):
      result = true
   else:
      for childLink in lineType.childLinks:
         let subLineType = getLineTypeForLineId(docType, childLink.subLineId)
         if hasSubLineTypeWithId(docType, subLineType, lineId):
            result = true
            break

proc getLineElementType*(lineType: LineType, leId: string): LineElementType =
   #debug("getLineElementType: lt: $#, leId: $#" % [lineType.lineId, leId])
   #assert(leId.startsWith(lineType.lineId))
   let results = filter(lineType.lineElementTypes,
                        proc(et: LineElementType): bool = et.lineElementId == leId)
   if results.len == 0:
      raise newException(ValueError, 
         "LineType '$#' does not have an element with id '$#'." % [lineType.lineId, leId])
   else:
      result = results[0]

proc isElementOfLine*(leType: LineElementType, line: string): bool =
   getLineId(leType.lineElementId) == getLineId(line)

proc getLineElementType*(docType: DocumentType, leId: string): LineElementType =
   #debug("getLineType: d: $#, leId: $#" % [docType.name, leId])
   let lineType = getLineTypeForLineId(docType, getLineId(leId))
   result = lineType.getLineElementType(leId)

proc getElementValueFullString(line: string, leType: LineElementType): string =
   let start = leType.startPosition-1
   let fin = start + leType.length-1
   result = line[start..fin]

proc getElementValueFullString*(docType: DocumentType, line: string, lineElementId: string): string =
   #debug("getElementValueFullString: '$#'" % [lineElementId])
   assert line[0..1] == lineElementId[0..1]
   let lineType = docType.getLineTypeForLine(line)
   let leType = lineType.getLineElementType(lineElementId)
   getElementValueFullString(line, leType)

proc getElementValueString*(docType: DocumentType, line: string, lineElementId: string): string =
   result = stripBlanks(getElementValueFullString(docType, line, lineElementId))

proc getElementValueString*(line: string, leType: LineElementType): string =
   result = stripBlanks(getElementValueFullString(line, leType))

proc getElementValueInt*(line: string, leType: LineElementType): int =
   parseInt(getElementValueString(line, leType))

proc getElementValueDate*(line: string, leType: LineElementType): DateTime =
    parseVektisDate(getElementValueFullString(line, leType))

proc getElementValueFormatted*(line: string, leType: LineElementType): string =
   if leType.isAmountType():
      getElementValueInt(line, leType)|R(leType.length)
   elif leType.isNumericType():
      getElementValueInt(line, leType)|R(leType.length)
   else:
      getElementValueFullString(line, leType)

proc nextLeId(leId: string): string =
   let leSuccessorIndex = parseInt(leId[2..3]) + 1
   result = leId[0..1] & intToStr(leSuccessorIndex, 2)

proc getElementValueSigned*(docType: DocumentType, leType: LineElementType, line: string): int =
   if not isElementOfLine(leType, line):
      raise newException(LineTypeMisMatch, "Cannot get value of type $# on line of type $#" % [leType.lineElementId, getLineId(line)])
   # Precondition: leType must be of type "BED***"
   if leType.valueType != SignedAmountValueType:
      raise newException(LineTypeMisMatch, "Cannot get signed value for line elment '$#'" % leType.lineElementId)
   let source = getElementValueString(docType, line, leType.lineElementId)
   debug("doctype.getElementValueSigned: '$#'" % source)
   let digits = source[0..^2]
   let signum = source[^1..^1]
   let intValue = parseInt(digits)
   # according to ap304v80 spec: default is Debit
   case signum
   of cSignumCredit:
      result = -1 * intValue
   else:
      result = intValue
   #   raise newException(ValueError, "Invalid value for signum in line element of type '$#', value: '$#'" % [leType.lineElementId, source])

proc summary*(doctype: DocumentType): string =
   "$# v$#.$#   $#" %
      [doctype.name,
      intToStr(doctype.formatVersion),
      intToStr(doctype.formatSubVersion),
      doctype.description]




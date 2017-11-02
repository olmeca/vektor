import json, os, ospaths, future, sequtils, strutils, logging, tables, times
import "common", "vektorjson"

const 
   cDebtorRecordLineId* = "03"
   cDebtorRecordVersionStartIndex = 297
   cDebtorRecordVersionEndIndex = 298
   cDocTypesJsonFileName = "doctypes.json"
   cSB311TypesJsonFileName = "sb311-types.json"
   cSB311v1 = "01"
   cSB311v2 = "02"

var
   types: seq[DocumentType]
   debtorRecordTypes: seq[DocumentType]
   
#let types = lc[readDocumentType(node) | (node <- getJsonData(cDocTypesJsonFileName)), DocumentType]
#let debtorRecordTypes = lc[readDocumentType(node) | (node <- getJsonData(cSB311TypesJsonFileName)), DocumentType]


proc readTypes(fileName: string): seq[DocumentType] =
   result = lc[readDocumentType(node) | (node <- getJsonData(fileName)), DocumentType]

proc readDocumentTypes*() =
   types = readTypes(cDocTypesJsonFileName)
   debtorRecordTypes = readTypes(cSB311TypesJsonFileName)

proc parseVektisDate*(dateString: string): TimeInfo =
   try:
      result = parse(dateString, cVektisDateFormat)
   except Exception:
      raise newException(ValueError, "Invalid date format: '$#'" % [dateString])


proc isOneCharRepeated(value: string, theChar: char): bool =
   result = true
   for c in toSeq(value.items):
      if c != theChar:
         result = false


proc isDate*(leType: LineElementType): bool =
   leType.length == 8 and leType.code.startsWith("DAT")

proc isAlphaNum*(leType: LineElementType): bool =
   leType.fieldType == cFieldTypeAlphaNum

proc isNumeric*(leType: LineElementType): bool =
   leType.fieldType == cFieldTypeNumeric

proc isEmptyValue*(leType: LineElementType, value: string): bool =
   if value.len == 0:
      true
   elif leType.isNumeric():
      value.isOneCharRepeated('0')
   else:
      value.isOneCharRepeated(' ')

proc isValueMandatory*(leType: LineElementType): bool = 
   leType.required

proc stripBlanks(source: string): string =
   strip(source, true, true, cBlanksSet)

proc getDocumentType*(typeId: int, version: int, subversion: int): DocumentType = 
   let matches = filter(types, 
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

proc allDocumentTypes*(): seq[DocumentType] = 
   concat(types, debtorRecordTypes)

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

proc getLineTypeForLineId*(doctype: DocumentType, lineId: string): LineType =
   debug("getLineTypeForLineId: '$#'" % [lineId])
   let lineTypes = doctype.lineTypes.filter(proc (lt: LineType): bool = lt.lineId == lineId)
   if lineTypes.len == 0:
      raise newException(ValueError, 
         "Document $# does not have a line type with ID '$#'" % [doctype.name, lineId])
   else:
      result = lineTypes[0]

proc getLineTypeForFullLine*(defaultDocType: DocumentType, line: string): LineType =
   let lineId = line[0..1]
   result = getLineTypeForLineId(defaultDocType, lineId)
   if lineId == cDebtorRecordLineId:
      debug("handling debtor record, version: " & line[cDebtorRecordVersionStartIndex..cDebtorRecordVersionEndIndex])
      if line.len > cDebtorRecordVersionEndIndex:
         var doctype = defaultDocType
         case line[cDebtorRecordVersionStartIndex..cDebtorRecordVersionEndIndex]
         of cSB311v1:
            debug("Using SB311v1 record")
            doctype = debtorRecordTypes[0]
         of cSB311v2:
            debug("Using SB311v2 record")
            doctype = debtorRecordTypes[1]
         else: discard
         result = getLineTypeForLineId(doctype, lineId)
      else:
         raise newException(VektisFormatError, 
            "Invalid line length for debtor record: $#" % [intToStr(line.len)])

proc contextWithLineId*(context: Context, lineId: string): Context =
   assert(not isNil(lineId))
   debug( "contextWithLineId: ctx:$#, lid: $#" % [context.lineType.lineId, lineId])
   if context.lineType.lineId == lineId:
      result = context
   elif len(context.subContexts) == 0:
      raise newException(NotFoundError, "No context found with line id $#" % [lineId])
   elif context.subContexts.hasKey(lineId):
      result = context.subContexts[lineId]
   else:
      for sub in context.subContexts.values:
         let found = contextWithLineId(sub, lineId)
         if not isNil(found):
            result = found
            break
         else: discard


proc getLineId*(line: string): string = 
   if isNil(line) or line.len < 4:
      raise newException(ValueError, "Cannot get line id from '$#'" % [line])
   else:
      result = line[0 .. 1]

proc getLineElementType*(lineType: LineType, leId: string): LineElementType =
   debug("getLineElementType: lt: $#, leId: $#" % [lineType.lineId, leId])
   #assert(leId.startsWith(lineType.lineId))
   let results = filter(lineType.lineElementTypes,
                        proc(et: LineElementType): bool = et.lineElementId == leId)
   if results.len == 0:
      raise newException(ValueError, 
         "LineType '$#' does not have an element with id '$#'." % [lineType.lineId, leId])
   else:
      result = results[0]

proc isElementOfLine*(leType: LineElementType, line: string): bool =
   leType.lineElementId[0..1] == line[0..1]

proc getLineElementType*(docType: DocumentType, leId: string): LineElementType =
   debug("getLineType: d: $#, leId: $#" % [docType.name, leId])
   let lineType = getLineTypeForLineId(docType, getLineId(leId))
   result = lineType.getLineElementType(leId)

proc getElementValueFullString(line: string, leType: LineElementType): string =
   let start = leType.startPosition-1
   let fin = start + leType.length-1
   result = line[start..fin]

proc getElementValueFullString*(rootContext: Context, lineElementId: string): string =
   let lineId = lineElementId[0..1]
   let context = rootContext.contextWithLineId(lineId)
   debug("getElementValueFullString: rootctx: $#, leId: $#, subctx: $#" % 
         [rootContext.lineType.lineId, lineId, context.lineType.lineId])
   assert(context.line.startsWith(lineId))
   let leType = context.lineType.getLineElementType(lineElementId)
   let start = leType.startPosition-1
   let fin = start + leType.length-1
   result = context.line[start..fin]

proc getElementValueString*(context: Context, leId: string): string =
   stripBlanks(getElementValueFullString(context, leId))

proc getElementValueFullString*(docType: DocumentType, line: string, lineElementId: string): string =
   debug("getElementValueFullString: '$#'" % [lineElementId])
   assert line[0..1] == lineElementId[0..1]
   let lineType = docType.getLineTypeForFullLine(line)
   let leType = lineType.getLineElementType(lineElementId)
   getElementValueFullString(line, leType)

proc getElementValueString*(docType: DocumentType, line: string, lineElementId: string): string =
   result = stripBlanks(getElementValueFullString(docType, line, lineElementId))

proc getElementValueString*(line: string, leType: LineElementType): string =
   result = stripBlanks(getElementValueFullString(line, leType))

proc getElementValueInt*(line: string, leType: LineElementType): int =
   parseInt(getElementValueString(line, leType))
   

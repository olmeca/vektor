import tables, json, os, ospaths, logging, strutils, times, pegs

type
   DocumentTypeError* = object of Exception
   ContextWithLineIdNotFoundError* = object of Exception
   ChildLinkWithLineIdNotFoundError* = object of Exception
   NoMatchingItemFound* = object of Exception
   LineTypeMisMatch* = object of Exception
   DebtorRecordVersion* = enum
      drvDefault, drvSB1, drvSB2
   
   LineElementType* = ref object
      lineElementId*: string
      code*: string
      fieldType*: string
      startPosition*: int
      length*: int
      description*: string
      countable*: string
      sourceId*: string
      slaveId*: string
      required*: bool
   
   LineTypeLink* = ref object
      subLineId*: string
      multiple*: bool
      required*: bool
   
   LineType* = ref object
      name*: string
      length*: int
      lineId*: string
      index*: int
      lineElementTypes*: seq[LineElementType]
      childLinks*: seq[LineTypeLink]
      hasDependentElements*: bool
   
   DocumentType* = ref object
      name*: string
      description*: string
      formatVersion*: int
      formatSubVersion*: int
      vektisEICode*: int
      lineLength*: int
      lineTypes*: seq[LineType]
   
   VektisFormatError* = object of Exception
   
   
   # Validation
   ValidationResultType* = enum
      vrMissingFieldValue, vrInvalidFieldValue, vrInvalidLineLength, vrSummationError
   TooManyErrors* = object of Exception
   ValidationResult* = ref object
      lineNr*: int
      leId*: string
      vrType*: ValidationResultType
      info*: string


const
   cDataDir* = "vektor-data"
   cBlanksSet*: set[char] = { ' ' }
   cRecordIdSize* = 2
   cFieldIdSize* = 4
   cBottomLineId* = "99"
   cTopLineId* = "01"
   cPatientLineId* = "02"
   cDebtorLineId* = "03"
   cFieldTypeNumeric* = "N"
   cFieldTypeAlphaNum* = "AN"
   cVektisDateFormat* = "yyyyMMdd"
   cAmountCodePrefix* = "BED"
   cNumberCodePrefix* = "NUM"
   cDateCodePrefix* = "DAT"
   cAmountCredit* = "C"

let
   vektisDatePattern* = peg"""#
   Pattern <- ^ VektisDate !.
   VektisDate <- \d \d \d \d \d \d \d \d
   """

proc getJsonData*(fileName: string): JsonNode =
   let fullPath = joinPath(getAppDir(), cDataDir, fileName)
   debug("getJsonData reading from: " & fullPath)
   let jsonString = system.readFile(fullPath)
   result = parseJson(jsonString)
   debug("getJsonData: done reading.")

proc stripBlanks*(source: string): string =
   strip(source, true, true, cBlanksSet)

proc isDateType*(code: string): bool =
   return code.startsWith(cDateCodePrefix)

proc isNumericType*(code: string): bool =
   return code.startsWith(cNumberCodePrefix) or code.startsWith(cAmountCodePrefix)

proc isAmountType*(code: string): bool =
   return code.startsWith(cAmountCodePrefix)

proc isTextType*(code: string): bool =
   not isDateType(code) and not isNumericType(code)

proc asString*(doctype: DocumentType): string =
   "$# v$#.$#   $#" % 
      [doctype.name, 
      intToStr(doctype.formatVersion), 
      intToStr(doctype.formatSubVersion), 
      doctype.description]

proc asString*(lt: LineType): string =
   "LT[id: '$#', len: '$#', par: '$#', name: '$#']" % [
      lt.lineId,
      intToStr(lt.length),
      lt.name
   ]

proc asString*(leType: LineElementType): string =
   "LET[leId:'$#', code: '$#', fType: '$#', start: '$#', len: '$#', dsc: '$#', cnt: '$#']" % [
      leType.lineElementId,
      leType.code,
      leType.fieldType,
      intToStr(leType.startPosition),
      intToStr(leType.length),
      leType.description,
      (if isNil(leType.countable): "nil" else: leType.countable)
   ]

proc asString*(err: ValidationResult): string =
   let leId = if isNil(err.leId): "" else: ", field " & err.leId
   "Line $#$#: $#" % [intToStr(err.lineNr), leId, err.info]

proc parseVektisDate*(dateString: string): DateTime =
   try:
      result = parse(dateString, cVektisDateFormat)
   except Exception:
      raise newException(ValueError, "Invalid date format: '$#'" % [dateString])

proc firstItemMatching*[T](list: seq[T], pred: proc(item: T): bool {.closure.}): T {.inline.} =
   for i in 0..<list.len:
      if pred(list[i]):
         return list[i]
   raise newException(NoMatchingItemFound, "No item in list matching given criteria")

proc firstIndexMatching*[T](list: seq[T], pred: proc(item: T): bool {.closure.}): int {.inline.} =
   for i in 0..<list.len:
      if pred(list[i]):
         return i
   raise newException(NoMatchingItemFound, "No item in list matching given criteria")


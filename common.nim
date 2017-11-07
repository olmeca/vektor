import tables, json, os, ospaths, logging, strutils

type
   DocumentTypeError* = object of Exception
   NotFoundError* = object of Exception
   
   LineElementType* = ref object
      lineElementId*: string
      code*: string
      fieldType*: string
      startPosition*: int
      length*: int
      description*: string
      countable*: string
      required*: bool
   
   LineType* = ref object
      name*: string
      length*: int
      lineId*: string
      sublineTypeIds*: seq[string]
      lineElementTypes*: seq[LineElementType]
   
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
      vrMissingFieldValue, vrInvalidFieldValue, vrInvalidLineLength
   TooManyErrors* = object of Exception
   ValidationResult* = ref object
      lineNr*: int
      leId*: string
      vrType*: ValidationResultType
      info*: string


const
   cDataDir* = "vektor-data"
   cBlanksSet*: set[char] = { ' ' }
   cBottomLineId* = "99"
   cTopLineId* = "01"
   cPatientLineId* = "02"
   cDebtorLineId* = "03"
   cFieldTypeNumeric* = "N"
   cFieldTypeAlphaNum* = "AN"
   cVektisDateFormat* = "yyyyMMdd"
   cAmountCodePrefix* = "BED"
   cNumberCodePrefix* = "NUM"
   cAmountCredit* = "C"

proc getJsonData*(fileName: string): JsonNode =
   let fullPath = joinPath(getAppDir(), cDataDir, fileName)
   debug("getJsonData reading from: " & fullPath)
   let jsonString = system.readFile(fullPath)
   result = parseJson(jsonString)
   debug("getJsonData: done reading.")

proc stripBlanks*(source: string): string =
   strip(source, true, true, cBlanksSet)

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
   let leId = if isNil(err.leId): "" else: ", element " & err.leId
   "Line $#$#: $#" % [intToStr(err.lineNr, 4), leId, err.info]
import tables, json, os, ospaths, logging, strutils, sequtils, future, times, pegs, streams

type
   DocumentTypeError* = object of Exception
   ContextWithLineIdNotFoundError* = object of Exception
   ChildLinkWithLineIdNotFoundError* = object of Exception
   NoMatchingItemFound* = object of Exception
   LineTypeMisMatch* = object of Exception
   DocumentReadError* = object of Exception
   DocumentWriteError* = object of Exception

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

   AppConfig* = ref object
        dataDir*: string
        logFile*: string
        showElementSets*: TableRef[string, seq[string]]

   #Expressions
   ExpressionError* = object of Exception
   Expression* = ref ExpressionObj
   ExpressionObj* = object of RootObj
      serializeImpl*: proc(expr: Expression): string
      asStringImpl*: proc(expr: Expression): string
      isDerived*: bool

   ExpressionReader* = ref ExpressionReaderObj
   ExpressionReaderObj* = object of RootObj
      pattern*: Peg
      readImpl*: proc(valueSpec: string, leId: string, typeCode: string, length: int): Expression

   # FieldSpecs
   FieldSpec* = ref FieldSpecObj
   FieldSpecObj = object of RootObj
      leType*: LineElementType
      leTitle*: string
   FieldValueSpec* = ref FieldValueSpecObj
   FieldValueSpecObj = object of FieldSpecObj
      value*: Expression

   FieldSpecError* = object of Exception

   TCommand = enum
      cmdCopy, cmdQuery, cmdInfo, cmdHelp, cmdPrint, cmdValidate

const
   cDataDir* = "vektor-data"
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
   cVektorConfigFileKey* = "VEKTOR_CONFIG"
   cVektorDataDirKey* = "vektor.datadir"
   cVektorLogFileKey* = "vektor.logfile"
   cLogFileName* = "vektor.log"
   cDefaultConfigFileName = "vektor.properties"

let
   vektisDatePattern* = peg"""
   Pattern <- ^ VektisDate !.
   VektisDate <- \d \d \d \d \d \d \d \d
   """

   propertyEntryPattern = peg"""
   Property <- ^ Left Equals Right !.
   Left <- {Name} Sp
   Equals <- '=' Sp
   Right <- {Value}
   Name <- \ident '.' Name / \ident
   Value <- .*
   Sp <- \s*
   """

var
   gAppConfig: TableRef[string, string]

proc defaultDataDir*(): string =
    joinPath(getAppDir(), cDataDir)

proc defaultLogPath*(): string =
    joinPath(getAppDir(), cLogFileName)

proc getAppConfig*(key: string): string =
    result = gAppConfig[key]
    debug("getAppconfig $# -> $#" % [key, result])

proc setAppConfig*(config: TableRef[string, string]) =
    gAppConfig = config

proc initDefaultAppConfig*() =
    var config = newTable[string, string]()
    config[cVektorDataDirKey] = defaultDataDir()
    config[cVektorConfigFileKey] = defaultLogPath()
    setAppConfig(config)


proc getVektorLogPath*(): string =
    getAppConfig(cVektorLogFileKey)

proc getVektorDataDir*(): string =
    getAppConfig(cVektorDataDirKey)

proc getConfigPath*(): string =
    getEnv(cVektorConfigFileKey, joinPath(getAppDir(), cDefaultConfigFileName))

proc getJsonData*(fileName: string): JsonNode =
   let fullPath = joinPath(getVektorDataDir(), fileName)
   debug("getJsonData reading from: " & fullPath)
   let jsonString = system.readFile(fullPath)
   result = parseJson(jsonString)
   debug("getJsonData: done reading.")

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


proc readProperties*(input: Stream): TableRef[string, string] =
    var line: string = ""
    var i = 0
    result = newTable[string, string]()
    while input.readLine(line):
        i = i + 1
        if len(line) > 0 and line[0] != '#':
            if line =~ propertyEntryPattern:
                let key = matches[0]
                let value = matches[1]
                result[key] = value


proc checkProcessableLineType*(leId: string) =
   if leId[0..1] == cBottomLineId:
      raise newException(FieldSpecError, "Unsupported line ID: '$#'" % [leId[0..1]])


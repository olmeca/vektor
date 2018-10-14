import tables, json, os, ospaths, logging, strutils, sequtils, future, times, pegs, streams, formatting

type
   DocumentTypeError* = object of Exception
   ContextWithLineIdNotFoundError* = object of Exception
   ChildLinkWithLineIdNotFoundError* = object of Exception
   NoMatchingItemFound* = object of Exception
   LineTypeMisMatch* = object of Exception
   DocumentReadError* = object of Exception
   DocumentWriteError* = object of Exception

   # Vektis value types
   VektisValueType* = enum
       StringValueType, NaturalValueType, DateValueType, AmountValueType, EmptyValueType

   VektisValue* = ref object
       case kind*: VektisValueType
       of StringValueType:
            stringValue*: string
       of NaturalValueType:
            naturalValue*: uint
       of AmountValueType:
            amountValue*: int
       of DateValueType:
            dateValue*: DateTime
       of EmptyValueType:
            nil

   DebtorRecordVersion* = enum
      drvDefault, drvSB1, drvSB2
   
   LineElementType* = ref object
      lineElementId*: string
      valueType*: VektisValueType
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
   
   ContextState* = enum
      csInitial, csRegistered, csExported
   Context* = ref object
      parent*: Context
      state*: ContextState
      docType*: DocumentType
      lineType*: LineType
      leType*: LineElementType
      line*: string
      subContexts*: OrderedTableRef[string, Context]
      currentSubContext*: Context


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


   ExpressionError* = object of Exception

   Expression* = ref ExpressionObj
   ExpressionObj* = object of RootObj
      valueType*: VektisValueType
      asStringImpl*: proc(expr: Expression): string
      evaluateImpl*: proc(expr: Expression, context: Context): VektisValue
      isDerived*: bool

   ExpressionReader* = ref ExpressionReaderObj
   ExpressionReaderObj* = object of RootObj
      name*: string
      valueType*: VektisValueType
      pattern*: Peg
      readImpl*: proc(valueSpec: string): Expression

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
   cAlphaLower* = "abcdefghijklmnopqrstuvwxyz"
   cAlphaUpper* = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
   cAlphaDigit* = "0123456789"
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
   cReadableDateFormat* = "yyyy-MM-dd"
   cVektisEmptyDate* = "00000000"
   cAmountCodePrefix* = "BED"
   cNumberCodePrefix* = "NUM"
   cDateCodePrefix* = "DAT"
   cAlphaNumCodePrefix* = "COD"
   cReserveCodePrefix* = "TEC"
   cFamedCodePrefix* = "FAM"
   cAmountCredit* = "C"
   cVektorConfigFileKey* = "VEKTOR_CONFIG"
   cVektorDataDirKey* = "vektor.datadir"
   cVektorLogFileKey* = "vektor.logfile"
   cLogFileName* = "vektor.log"
   cDefaultConfigFileName = "vektor.properties"
   cEmptyVektisValueLiteral* = "null"

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

proc serialize*(value: VektisValue, length: uint): string =
   case value.kind:
   of StringValueType:
       let normalized = if isNil(value.stringValue): "" else: value.stringValue
       if normalized.len < int(length):
        result = normalized|L(length)
       else:
        result = normalized[0..length-1]
   of NaturalValueType:
        result = intToStr(int(value.naturalValue - 0), length)
   of AmountValueType:
        result = intToStr(abs(value.amountValue), length)
   of DateValueType:
        result = format(value.dateValue, cVektisDateFormat)
   of EmptyValueType:
        result = nil

proc asString*(value: VektisValue): string =
   case value.kind:
   of StringValueType:
       let normalized = if isNil(value.stringValue): "nil" else: value.stringValue
       result = "\"$#\"" % normalized
   of NaturalValueType:
        result = intToStr(int(value.naturalValue))
   of AmountValueType:
        result = (value.amountValue.float / 100).formatFloat(ffDecimal, 2)
   of DateValueType:
        result = format(value.dateValue, cReadableDateFormat)
   of EmptyValueType:
        result = "nil"

proc `$`*(valueType: VektisValueType): string =
   case valueType
   of StringValueType:
       "StringValueType"
   of NaturalValueType:
        "NaturalValueType"
   of AmountValueType:
        "AmountValueType"
   of DateValueType:
        "DateValueType"
   of EmptyValueType:
        "EmptyValueType"

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
    config[cVektorLogFileKey] = defaultLogPath()
    setAppConfig(config)


proc getVektorLogPath*(): string =
    getAppConfig(cVektorLogFileKey)

proc getVektorDataDir*(): string =
    getAppConfig(cVektorDataDirKey)

proc getConfigPath*(): string =
    getEnv(cVektorConfigFileKey, joinPath(getAppDir(), cDefaultConfigFileName))

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



proc readConfigurationFile*() =
    let configFilePath = getConfigPath()
    if existsFile(configFilePath):
        let inStream = newFileStream(configFilePath, fmRead)
        setAppConfig(readProperties(inStream))
        inStream.close()
    else:
        initDefaultAppConfig()


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

proc createLink*(subLineId: string, multiple: bool, required: bool): LineTypeLink =
    LineTypeLink(subLineId: subLineId, multiple: multiple, required: required)


proc getVektisValueType(code: string, fieldType: string): VektisValueType =
    if fieldType == cFieldTypeNumeric:
        if code == cDateCodePrefix:
            DateValueType
        elif code == cAmountCodePrefix:
            AmountValueType
        else:
            NaturalValueType
    else:
        StringValueType

proc newLeType*(leId: string, code: string, ftype: string, start: int, len: int, cntblref: string, srcId: string, slvId: string, req: bool, desc: string): LineElementType =
   result = LineElementType(
      lineElementId: leId,
      valueType: getVektisValueType(code[0..2], ftype),
      code: code,
      fieldType: ftype,
      startPosition: start,
      length: len,
      description: desc,
      countable: cntblref,
      sourceId: srcId,
      slaveId: slvId,
      required: req
   )


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
   result = "Line $#$#: $#" % [intToStr(err.lineNr), leId, err.info]


proc parseVektisDate*(dateString: string): DateTime =
   try:
      result = parse(dateString, cVektisDateFormat)
   except Exception:
      raise newException(ValueError, "Invalid date format: '$#'" % [dateString])

proc parseLiteralDateExpression*(dateString: string): DateTime =
   try:
      result = parse(dateString, cReadableDateFormat)
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


proc checkProcessableLineType*(leId: string) =
   if leId[0..1] == cBottomLineId:
      raise newException(FieldSpecError, "Unsupported line ID: '$#'" % [leId[0..1]])


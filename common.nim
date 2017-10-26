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
   
   LineType* = ref object
      name*: string
      length*: int
      lineId*: string
      parentLineId*: string
      lineElementTypes*: seq[LineElementType]
   
   DocumentType* = ref object
      name*: string
      description*: string
      formatVersion*: int
      formatSubVersion*: int
      vektisEICode*: int
      lineTypes*: seq[LineType]
   
   VektisFormatError* = object of Exception
   
   Context* = ref object
      lineType*: LineType
      line*: string
      subContexts*: TableRef[string, Context]
      

const
   cDataDir* = "vektor-data"
   cBlanksSet*: set[char] = { ' ' }

proc getJsonData*(fileName: string): JsonNode =
   let fullPath = joinPath(getAppDir(), cDataDir, fileName)
   debug("getJsonData reading from: " & fullPath)
   let jsonString = system.readFile(fullPath)
   result = parseJson(jsonString)
   debug("getJsonData: done reading.")

proc asString*(lt: LineType): string =
   "LT[id: '$#', len: '$#', par: '$#', name: '$#']" % [
      lt.lineId,
      intToStr(lt.length),
      if isNil(lt.parentLineId): "nil" else: lt.parentLineId,
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
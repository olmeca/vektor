import tables, json, os, ospaths, logging

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


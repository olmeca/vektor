import json, os, ospaths, sugar, sequtils, strutils, logging, tables, times
import common, vektorjson

const
   cDocTypesJsonFileName = "doctypes.json"
   cSB311TypesJsonFileName = "sb311-types.json"

proc getDocTypes(filePath: string, lineLength: int): seq[DocumentType] =
    result = getJsonData(filePath).elems.map(node => readDocumentType(node, lineLength))

proc getDocumentTypes*(lineLength: int): seq[DocumentType] =
   getDocTypes(cDocTypesJsonFileName, lineLength)

proc getDebtorRecordTypes*(lineLength: int): seq[DocumentType] =
   getDocTypes(cSB311TypesJsonFileName, lineLength)

proc getAllDocumentTypes*(): seq[DocumentType] =
    concat(getDocumentTypes(0), getDebtorRecordTypes(0))

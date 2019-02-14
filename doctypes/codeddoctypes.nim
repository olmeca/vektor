import json, os, ospaths, sugar, sequtils, strutils, logging, tables, times

import common, vektorjson
import MZ30113, AP30472, AP30480, SB31110, SB31120

var genDocTypes: seq[DocumentType]
var sbDocTypes: seq[DocumentType]


proc getDocumentTypes*(lineLength: int): seq[DocumentType] =
    if genDocTypes == @[]:
        genDocTypes = @[createDocTypeAP30472(), createDocTypeAP30480(), createDocTypeMZ30113()]
    genDocTypes


proc getDebtorRecordTypes*(lineLength: int): seq[DocumentType] =
    if sbDocTypes == @[]:
        sbDocTypes = @[createDocTypeSB31110(), createDocTypeSB31120()]
    sbDocTypes


proc getAllDocumentTypes*(): seq[DocumentType] =
    concat(getDocumentTypes(0), getDebtorRecordTypes(0))

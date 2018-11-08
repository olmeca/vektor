import json, sequtils, future, logging, strutils, tables
import common, factory


proc readLineElementType*(node: JsonNode): LineElementType =
    let code = node["code"].getStr()
    let ftype = node["fieldType"].getStr()
    let valueType = if node.hasKey("signed"): SignedAmountValueType else: getVektisValueType(code, ftype)
    result = newLeType(
         node["lineElementId"].getStr(),
         node["code"].getStr(),
         node["fieldType"].getStr(),
         int(node["startPosition"].getNum()),
         int(node["length"].getNum()),
         getStr(node{"countable"}, nil),
         getStr(node{"sourceId"}, nil),
         getStr(node{"slaveId"}, nil),
         node["required"].getBool(),
         valueType,
         node["description"].getStr()
    )
   # debug(result.asString())


proc readLineTypeLink*(node: JsonNode): LineTypeLink =
   createLink(
      node["subLineId"].getStr(),
      node["multiple"].getBVal(),
      node["required"].getBVal()
   )

proc readLineType*(node: JsonNode, lineLength: int): LineType =
   let lineId = node["lineId"].getStr()
   var leTypes = lc[readLineElementType(item) | (item <- node["lineElementTypes"].items()), LineElementType]
   if lineId == cDebtorLineId:
      leTypes[leTypes.len-1].length = lineLength - leTypes[leTypes.len-1].startPosition
   else: discard
   let children = lc[readLineTypeLink(item) | (item <- node["childLinks"].items()), LineTypeLink]
   let hasDependentEls = leTypes.anyIt(not isNil(it.sourceId))
   result = LineType(
      name: node["name"].getStr(),
      length: int(node["length"].getNum()),
      lineId: lineId,
      index: parseInt(lineId),
      childLinks: children,
      lineElementTypes: leTypes,
      hasDependentElements: hasDependentEls
   )

proc readDocumentType*(node: JsonNode, lineLength: int): DocumentType =
   let docLineLength = if lineLength == 0: int(getNum(node{"lineLength"}, 310)) else: lineLength
   let lineTypes = lc[readLineType(item, docLineLength) | (item <- node["lineTypes"].items()), LineType]
   result = DocumentType(
      name: node["name"].getStr(),
      description: node["description"].getStr(),
      formatVersion: int(node["formatVersion"].getNum()),
      formatSubVersion: int(node["formatSubVersion"].getNum()),
      vektisEICode: int(node["vektisEICode"].getNum()),
      lineLength: docLineLength,
      lineTypes: lineTypes
   )

proc readElementSet(setNode: JsonNode): seq[string] =
    lc[getStr(node) | (node <- setNode.elems), string]

proc readElementSets(table: OrderedTable[string, JsonNode]): TableRef[string, seq[string]] =
    result = newTable[string, seq[string]]()
    for key, node in table.pairs():
        result[key] = readElementSet(node)

proc readAppConfig*(node: JsonNode): AppConfig =
    let dataDir = getStr(node{"dataDir"}, defaultDataDir())
    let logFile = getStr(node{"logFile"}, defaultLogPath())
    let setsNode = node{"showElementSets"}
    result = AppConfig(dataDir: dataDir, logFile: logFile)
    if not isNil(setsNode):
        result.showElementSets = readElementSets(setsNode.fields)

import json, sequtils, sugar, logging, strutils, tables
import common, factory


proc readLineElementType*(node: JsonNode): LineElementType =
    let code = node["code"].getStr()
    let ftype = node["fieldType"].getStr()
    let valueType = if node.hasKey("signed"): SignedAmountValueType else: getVektisValueType(code, ftype)
    result = newLeType(
         node["lineElementId"].getStr(),
         node["code"].getStr(),
         node["fieldType"].getStr(),
         node["startPosition"].getInt(),
         node["length"].getInt(),
         getStr(node{"countable"}, ""),
         getStr(node{"sourceId"}, ""),
         getStr(node{"slaveId"}, ""),
         node["required"].getBool(),
         valueType,
         node["description"].getStr()
    )
   # debug(result.asString())


proc readLineTypeLink*(node: JsonNode): LineTypeLink =
   createLink(
      node["subLineId"].getStr(),
      node["multiple"].getBool(),
      node["required"].getBool()
   )

proc readLineType*(node: JsonNode, lineLength: int): LineType =
   let lineId = node["lineId"].getStr()
   var leTypes = node["lineElementTypes"].elems.map(item => readLineElementType(item))
   if lineId == cDebtorLineId:
      leTypes[leTypes.len-1].length = lineLength - leTypes[leTypes.len-1].startPosition
   else: discard
   let children = node["childLinks"].elems.map(readLineTypeLink)
   let hasDependentEls = leTypes.anyIt(it.sourceId != "")
   result = LineType(
      name: node["name"].getStr(),
      length: node["length"].getInt(),
      lineId: lineId,
      index: parseInt(lineId),
      childLinks: children,
      lineElementTypes: leTypes,
      hasDependentElements: hasDependentEls
   )

proc readDocumentType*(node: JsonNode, lineLength: int): DocumentType =
   let docLineLength = if lineLength == 0: getInt(node{"lineLength"}, 310) else: lineLength
   let lineTypes = node["lineTypes"].elems.map(item => readLineType(item, docLineLength))
   result = DocumentType(
      name: node["name"].getStr(),
      description: node["description"].getStr(),
      formatVersion: node["formatVersion"].getInt(),
      formatSubVersion: node["formatSubVersion"].getInt(),
      vektisEICode: node["vektisEICode"].getInt(),
      lineLength: docLineLength,
      lineTypes: lineTypes
   )

proc readElementSet(setNode: JsonNode): seq[string] =
    setNode.elems.map(node => getStr(node))

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

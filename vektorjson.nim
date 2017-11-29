import json, sequtils, future, logging
import "common"

proc readLineElementType*(node: JsonNode): LineElementType =
   result = LineElementType(
      lineElementId: node["lineElementId"].getStr(),
      code: node["code"].getStr(),
      fieldType: node["fieldType"].getStr(),
      startPosition: int(node["startPosition"].getNum()),
      length: int(node["length"].getNum()),
      description: node["description"].getStr(),
      countable: getStr(node{"countable"}, nil),
      sourceId: getStr(node{"sourceId"}, nil),
      slaveId: getStr(node{"slaveId"}, nil),
      required: node["required"].getBVal()
   )
   # debug(result.asString())

proc readLineTypeLink*(node: JsonNode): LineTypeLink =
   result = LineTypeLink(
      subLineId: node["subLineId"].getStr(),
      multiple: node["multiple"].getBVal(),
      required: node["required"].getBVal()
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

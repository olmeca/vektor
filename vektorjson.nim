import json, future, logging
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
      required: node["required"].getBVal()
   )
   # debug(result.asString())

proc readLineType*(node: JsonNode): LineType =
   let leTypes = lc[readLineElementType(item) | (item <- node["lineElementTypes"].items()), LineElementType]
   let subTypes = lc[getStr(item) | (item <- node["sublineTypeIds"].items()), string]
   result = LineType(
      name: node["name"].getStr(),
      length: int(node["length"].getNum()),
      lineId: node["lineId"].getStr(),
      sublineTypeIds: subTypes,
      lineElementTypes: leTypes
   )

proc readDocumentType*(node: JsonNode): DocumentType =
   let lineTypes = lc[readLineType(item) | (item <- node["lineTypes"].items()), LineType]
   result = DocumentType(
      name: node["name"].getStr(),
      description: node["description"].getStr(),
      formatVersion: int(node["formatVersion"].getNum()),
      formatSubVersion: int(node["formatSubVersion"].getNum()),
      vektisEICode: int(node["vektisEICode"].getNum()),
      lineLength: int(getNum(node{"lineLength"}, 310)),
      lineTypes: lineTypes
   )

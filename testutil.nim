import utils, common, doctypes, context, jobs

proc newLeType*(recordNr: int, fieldNr: int, code: string, datatype: string, start: int, len: int): LineElementType =
   result = LineElementType(
      lineElementId: leTypeId(recordNr, fieldNr),
      code: code,
      fieldType: datatype,
      startPosition: start,
      length: len,
      description: "Test field",
      countable: nil,
      sourceId: nil,
      slaveId: nil,
      required: true
   )

proc newLineType*(index: int, len: int, children: seq[LineTypeLink], leTypes: seq[LineElementType], hasDeps: bool ): LineType =
   result = LineType(
      name: "Record",
      length: len,
      lineId: id(index),
      index: index,
      childLinks: children,
      lineElementTypes: leTypes,
      hasDependentElements: hasDeps
   )

proc newDocType*(docTypeId: int, docTypeVersion: int, docTypeSubversion: int, lineLength: int, lineTypes: seq[LineType]): DocumentType =
   result = DocumentType(
      name: "DocTypeName",
      description: "",
      formatVersion: docTypeVersion,
      formatSubVersion: docTypeSubversion,
      vektisEICode: docTypeId,
      lineLength: lineLength,
      lineTypes: lineTypes
   )

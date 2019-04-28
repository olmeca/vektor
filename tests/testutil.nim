import os, utils, common, doctype, factory, context, job, logging


proc newLeType*(recordNr: int, fieldNr: int, code: string, title: string, datatype: string, start: int, len: int): LineElementType =
    newLeType(
        leTypeId(recordNr, fieldNr),
        code,
        datatype,
        start,
        len,
        NIL,
        NIL,
        NIL,
        true,
        title
    )


proc newLeTypeOfValueType*(recordNr: int, fieldNr: int, code: string, title: string, datatype: string, start: int, len: int, valueType: VektisValueType): LineElementType =
    factory.newLeType(
        leTypeId(recordNr, fieldNr),
        code,
        datatype,
        start,
        len,
        NIL,
        NIL,
        NIL,
        true,
        valueType,
        title
    )


proc newLineType*(index: int, len: int, name: string, children: seq[LineTypeLink], leTypes: seq[LineElementType], hasDeps: bool ): LineType =
   result = LineType(
      name: name,
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


proc activateLogging*() =
   let filePath = getEnv(cLogPathKey, "/tmp/vektor.log")
   var fileLogger = newFileLogger(filePath, fmtStr = verboseFmtStr)
   addHandler(fileLogger)
   setLogFilter(lvlDebug)


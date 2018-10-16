import sequtils, common, tables, expressions


type
    GeneralExpressionReader* = ref object of RootObj
        readers*: TableRef[VektisValueType, seq[ExpressionReader]]


proc newGeneralExpressionReader*(readers: seq[ExpressionReader]): GeneralExpressionReader =
    let readersMap = newTable[VektisValueType, seq[ExpressionReader]]()
    for reader in readers:
        if not readersMap.hasKey(reader.valueType):
            readersMap[reader.valueType] = @[]
        else: discard
        readersMap[reader.valueType].add(reader)

    GeneralExpressionReader(readers: readersMap)


proc readExpression*(reader: GeneralExpressionReader, valueSpec: string, valueType: VektisValueType): Expression =
    reader.readers[valueType].readExpression(valueSpec)

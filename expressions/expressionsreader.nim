import sequtils, common, tables, expressions, valueset, literal, randomdate, randomstring, number, postcode, function


type
    GeneralExpressionReader* = ref object of RootObj
        readers*: TableRef[VektisValueType, seq[ExpressionReader]]


proc getUserExpressionReaders*(): seq[ExpressionReader] =
    @[
        newRandomNominalTextExpressionReader(),
        newRandomNominalNaturalExpressionReader(),
        newRandomDateExpressionReader(),
        newRandomCapsExpressionReader(),
        newRandomStringExpressionReader(),
        newRandomNaturalExpressionReader(),
        newRandomPostcodeExpressionReader(),
        newLiteralDateReader(),
        newLiteralSignedAmountReader(),
        newLiteralUnsignedAmountReader(),
        newLiteralNaturalReader(),
        newLiteralTextReader(),
        newFieldValueExpressionReader(StringValueType),
        newFieldValueExpressionReader(DateValueType),
        newFieldValueExpressionReader(NaturalValueType),
        newFieldValueExpressionReader(SignedAmountValueType),
        newFieldValueExpressionReader(UnsignedAmountValueType)

    ]


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

import unittest, common, context, expressions, literal, randomdate, number, times, valueset, tables, copyjob

suite "Reader tests":

    setup:
        let context = createContext(nil, nil, NIL)
        gValueSets = newTable[string, seq[VektisValue]]()

    test "Reading non-empty literal text":
        let reader = newLiteralTextReader()
        let exp = reader.read("\"word\"")
        check:
            not isNil(exp)
            exp.valueType == StringValueType
        let value = exp.evaluate(context)
        check:
            not isNil(value)
            value.stringValue == "word"
            value.asString == "\"word\""


    test "read empty literal text":
        let reader = newLiteralTextReader()
        let exp = reader.read("\"\"")
        check:
            not isNil(exp)
            exp.valueType == StringValueType
        let value = exp.evaluate(context)
        check:
            not isNil(value)
            value.kind == StringValueType
            isEmpty(value.stringValue)


    test "Reading natural number is accurate":
        let reader = newLiteralNaturalReader()
        let exp = reader.read("1234")
        check:
            not isNil(exp)
            exp.valueType == NaturalValueType
        let value = exp.evaluate(context)
        check:
            not isNil(value)
            value.naturalValue == 1234


    test "Reading amount is accurate":
        let reader = newLiteralUnsignedAmountReader()
        let exp = reader.read("1234.56")
        check:
            not isNil(exp)
            exp.valueType == UnsignedAmountValueType
        let value = exp.evaluate(context)
        check:
            not isNil(value)
            value.amountValue == 123456
            value.asString == "1234.56"


    test "Reading valid date value is accurate":
        let reader = newLiteralDateReader()
        let exp = reader.read("  2010-09-13 ")
        check:
            not isNil(exp)
            exp.valueType == DateValueType
        let value = exp.evaluate(context)
        check:
            not isNil(value)
            value.asString == "2010-09-13"


    test "Reading empty date gives expression with empty value":
        let reader = newLiteralDateReader()
        let exp = reader.read("null")
        check:
            not isNil(exp)
            exp.valueType == DateValueType
        let value = exp.evaluate(context)
        check:
            not isNil(value)
            value.kind == DateValueType
            isNil(value.dateValue)

    test "Reading random natural expression":
        let reader = newRandomNaturalExpressionReader()
        let exp = reader.read("natural(100)")
        check:
            not isNil(exp)
            exp.valueType == NaturalValueType
        let value = exp.evaluate(context)
        check:
            not isNil(value)
            value.kind == NaturalValueType


    test "Reading random natural expression with spaces":
        let reader = newRandomNaturalExpressionReader()
        let exp = reader.read("  natural  (  100 ) ")
        check:
            not isNil(exp)
            exp.valueType == NaturalValueType
        let value = exp.evaluate(context)
        check:
            not isNil(value)
            value.kind == NaturalValueType
            value.naturalValue >= uint(0) and value.naturalValue < uint(100)


    test "Reading random item from value set":
        gValueSets["myset"] = @[VektisValue(kind: StringValueType, stringValue: "one")]
        let reader = newRandomNominalTextExpressionReader()
        let exp = reader.read("  any  (  \"myset\" ) ")
        check:
            not isNil(exp)
            exp.valueType == StringValueType
        let value = exp.evaluate(context)
        check:
            not isNil(value)
            value.kind == StringValueType
            value.stringValue == "one"


    test "Read random date works.":
        let reader = newRandomDateExpressionReader()
        let exp = reader.read(" date ( 2013-09-13, 2014-01-09 ) ")
        check:
            not isNil(exp)
            exp.valueType == DateValueType
        let vektisValue = exp.evaluate(context)
        check:
            not isNil(vektisValue)
            vektisValue.kind == DateValueType


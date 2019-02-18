import logging, unittest, times, valueset, tables, pegs
import common, context, expressions, literal, randomdate, copyjob, factory


proc enableLogging() =
   initDefaultAppConfig()
   let filePath = getVektorLogPath()
   var fileLogger = newFileLogger(filePath, fmtStr = verboseFmtStr)
   addHandler(fileLogger)
   setLogFilter(lvlDebug)

enableLogging()


suite "Expressions reader tests":

    setup:
        gValueSets = newTable[string, seq[VektisValue]]()
        let context = createContext(nil, nil, NIL)

    test "Read literal string without padding works.":
        let readers = @[newLiteralTextReader()]
        let exp = readers.readExpression("\"test\"", StringValueType)
        check:
            not isNil(exp)
            exp.valueType == StringValueType
        let vektisValue = exp.evaluate(context)
        check:
            not isNil(vektisValue)
            vektisValue.stringValue == "test"
            vektisValue.asString == "\"test\""


    test "Read literal string with padding works.":
        let readers = @[newLiteralTextReader()]
        let exp = readers.readExpression("  \"test\"  ", StringValueType)
        check:
            not isNil(exp)
            exp.valueType == StringValueType
        let vektisValue = exp.evaluate(context)
        check:
            not isNil(vektisValue)
            vektisValue.stringValue == "test"
            vektisValue.asString == "\"test\""


    test "Read literal natural without padding works.":
        let readers = @[newLiteralNaturalReader()]
        let exp = readers.readExpression("123456789", NaturalValueType)
        check:
            not isNil(exp)
            exp.valueType == NaturalValueType
        let vektisValue = exp.evaluate(context)
        check:
            not isNil(vektisValue)
            vektisValue.naturalValue == 123456789
            vektisValue.asString == "123456789"

    test "Read literal amount without padding works.":
        let readers = @[newLiteralUnsignedAmountReader()]
        let exp = readers.readExpression("1234567.89", UnsignedAmountValueType)
        check:
            not isNil(exp)
            exp.valueType == UnsignedAmountValueType
        let vektisValue = exp.evaluate(context)
        check:
            not isNil(vektisValue)
            vektisValue.amountValue == 123456789
            vektisValue.asString == "1234567.89"


    test "Read negative literal signed amount without padding works.":
        let readers = @[newLiteralSignedAmountReader()]
        let exp = readers.readExpression("-1234567.89", SignedAmountValueType)
        check:
            not isNil(exp)
            exp.valueType == SignedAmountValueType
        let vektisValue = exp.evaluate(context)
        check:
            not isNil(vektisValue)
            vektisValue.signedAmountValue == -123456789
            vektisValue.asString == "-1234567.89"


    test "Read positive literal signed amount without padding works.":
        let readers = @[newLiteralSignedAmountReader()]
        let exp = readers.readExpression("+1234567.89", SignedAmountValueType)
        check:
            not isNil(exp)
            exp.valueType == SignedAmountValueType
        let vektisValue = exp.evaluate(context)
        check:
            not isNil(vektisValue)
            vektisValue.signedAmountValue == 123456789
            vektisValue.asString == "1234567.89"


    test "Read arbitrary value from value set with padding works.":
        let readers = @[newRandomNominalTextExpressionReader()]
        gValueSets["myset"] = @[VektisValue(kind: StringValueType, stringValue: "one")]
        let exp = readers.readExpression("  any  (  \"myset\" ) ", StringValueType)
        check:
            not isNil(exp)
            exp.valueType == StringValueType
        let vektisValue = exp.evaluate(context)
        check:
            not isNil(vektisValue)
            vektisValue.stringValue == "one"


    test "Read random date works.":
        enableLogging()
        let readers = @[newRandomDateExpressionReader()]
        let exp = readers.readExpression(" date ( 2013-09-13, 2014-01-09 ) ", DateValueType)
        check:
            not isNil(exp)
            exp.valueType == DateValueType
        let vektisValue = exp.evaluate(context)
        check:
            not isNil(vektisValue)
            vektisValue.kind == DateValueType


    test "Amount reading patterns work.":
        check:
            "-123.45" =~ literalSignedAmountPattern
            "+123.45" =~ literalSignedAmountPattern
            "1233.45" =~ literalUnsignedAmountPattern

    test "Vektis value type determination works":
        check:
            getVektisValueType("BED123", "N") == UnsignedAmountValueType
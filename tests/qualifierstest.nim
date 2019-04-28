import unittest, times
import qualifiers, expressions, expressionsreader, common, context, literal, vektisvalues, testutil

suite "qualifiers":

    setup:
        let leType = LineElementType(lineElementId: "0201", fieldType: cFieldTypeNumeric, code: "NUM123", startPosition: 3, length:4, valueType: NaturalValueType)
        let leType2 = LineElementType(lineElementId: "0202", fieldType: cFieldTypeNumeric, code: "BED456", startPosition: 7, length:8, valueType: UnsignedAmountValueType)
        let leType3 = LineElementType(lineElementId: "0203", fieldType: cFieldTypeAlphaNum, code: "COD789", startPosition: 15, length:6, valueType: StringValueType)
        let leType4 = LineElementType(lineElementId: "0204", fieldType: cFieldTypeNumeric, code: "DAT678", startPosition: 21, length:8, valueType: DateValueType)
        let ranges = "<><--><------><----><------>"
        let line =   "02012300005678test  19860709"
        let lType = LineType(lineId: "02", lineElementTypes: @[leType, leType2, leType3, leType4])
        var docType = DocumentType(lineTypes: @[lType])
        let ctx = Context(docType: docType, lineType: lType, line: line)
        activateLogging()


    test "elementary natural qualifier is recognized":
        let lineQual = parseQualifier(docType, "0201=123", newGeneralExpressionReader(@[newLiteralNaturalReader()]))
        let elemQual = (ElementaryQualifier) lineQual
        check:
            elemQual.leType == leType

        let refValue: VektisValue = VektisValue(kind: NaturalValueType, naturalValue: 123)
        let value: VektisValue = elemQual.refValue.evaluate(ctx)
        check:
            value.kind == NaturalValueType
            eq(value, refValue)
            elemQual.operator == OpEquals


    test "elementary unsigned amount qualifier is recognized":
        let lineQual = parseQualifier(docType, "0202=123.45", newGeneralExpressionReader(@[newLiteralUnsignedAmountReader()]))
        let elemQual = (ElementaryQualifier) lineQual
        check:
            elemQual.leType == leType2

        let refValue: VektisValue = VektisValue(kind: UnsignedAmountValueType, amountValue: 12345)
        let value: VektisValue = elemQual.refValue.evaluate(ctx)
        check:
            value.kind == UnsignedAmountValueType
            eq(value, refValue)
            elemQual.operator == OpEquals


    test "composite qualifier with spaces is recognized":
        let expReader = newGeneralExpressionReader(@[newLiteralNaturalReader(), newLiteralUnsignedAmountReader()])
        let qual = parseQualifier(docType, "  0201 = 123 & 0202 = 4.56 ", expReader)
        let cq = CompositeQualifier(qual)
        check:
            cq.operator == OpAnd
            cq.qualifiers.len == 2
        let eq = ElementaryQualifier(cq.qualifiers[0])
        let eq2 = ElementaryQualifier(cq.qualifiers[1])
        check:
             eq.leType == leType
             eq.operator == OpEquals
             eq2.leType == leType2
             eq2.operator == OpEquals

        let refNatValue: VektisValue = VektisValue(kind: NaturalValueType, naturalValue: 123)
        let natValue = eq.refValue.evaluate(ctx)
        check:
            eq(natValue, refNatValue)

        let refAmtValue: VektisValue = VektisValue(kind: UnsignedAmountValueType, amountValue: 456)
        let amtValue = eq2.refValue.evaluate(ctx)
        check:
            eq(amtValue, refAmtValue)


    test "composite qualifier without spaces is recognized":
        let expReader = newGeneralExpressionReader(@[newLiteralNaturalReader(), newLiteralUnsignedAmountReader()])
        let qual = parseQualifier(docType, "0201=123&0202=4.56", expReader)
        let cq = CompositeQualifier(qual)
        check:
            cq.operator == OpAnd
            cq.qualifiers.len == 2
        let eq = ElementaryQualifier(cq.qualifiers[0])
        let eq2 = ElementaryQualifier(cq.qualifiers[1])
        check:
             eq.leType == leType
             eq.operator == OpEquals
             eq2.leType == leType2
             eq2.operator == OpEquals

        let refNatValue: VektisValue = VektisValue(kind: NaturalValueType, naturalValue: 123)
        let natValue = eq.refValue.evaluate(ctx)
        check:
            eq(natValue, refNatValue)

        let refAmtValue: VektisValue = VektisValue(kind: UnsignedAmountValueType, amountValue: 456)
        let amtValue = eq2.refValue.evaluate(ctx)
        check:
            eq(amtValue, refAmtValue)


    test "composite qualifier with more than two subqualifiers is recognized":
        let expReader = newGeneralExpressionReader(@[newLiteralNaturalReader(), newLiteralUnsignedAmountReader(), newLiteralTextReader()])
        let qual = parseQualifier(docType, "  0201 = 123 & 0202 = 4.56 & 0203 != \"789\" ", expReader)
        let cq = CompositeQualifier(qual)
        check:
            cq.operator == OpAnd
            cq.qualifiers.len == 3
        let eq = ElementaryQualifier(cq.qualifiers[0])
        let eq2 = ElementaryQualifier(cq.qualifiers[1])
        check:
             eq.leType == leType
             eq.operator == OpEquals
             eq2.leType == leType2
             eq2.operator == OpEquals

        let refNatValue: VektisValue = VektisValue(kind: NaturalValueType, naturalValue: 123)
        let natValue = eq.refValue.evaluate(ctx)
        check:
            eq(natValue, refNatValue)

        let refAmtValue: VektisValue = VektisValue(kind: UnsignedAmountValueType, amountValue: 456)
        let amtValue = eq2.refValue.evaluate(ctx)
        check:
            eq(amtValue, refAmtValue)


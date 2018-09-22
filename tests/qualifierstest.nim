import unittest, times
import "qualifiers", "common", "context"

suite "qualifiers":

    setup:
        let leType = LineElementType(lineElementId: "0201", fieldType: cFieldTypeNumeric, code: "NUM123", startPosition: 3, length:4)
        let leType2 = LineElementType(lineElementId: "0202", fieldType: cFieldTypeNumeric, code: "BED456", startPosition: 7, length:8)
        let leType3 = LineElementType(lineElementId: "0203", fieldType: cFieldTypeAlphaNum, code: "COD789", startPosition: 15, length:6)
        let leType4 = LineElementType(lineElementId: "0204", fieldType: cFieldTypeNumeric, code: "DAT678", startPosition: 21, length:8)
        let ranges = "<><--><------><----><------>"
        let line =   "02012300005678test  19860709"
        let lType = LineType(lineId: "02", lineElementTypes: @[leType, leType2, leType3, leType4])
        var docType = DocumentType(lineTypes: @[lType])
        let ctx = Context(docType: docType, lineType: lType, line: line)

    test "elementary qualifier with spaces is recognized":
        let eq = NumberQualifier(parseQualifier(docType, " 0201 = 123" ))
        check:
            eq.leType == leType
            eq.refValue == 123
            eq.operator == OpEquals

    test "elementary qualifier without spaces is recognized":
        let eq = NumberQualifier(parseQualifier(docType, "0201=123"))
        check:
            eq.leType == leType
            eq.refValue == 123
            eq.operator == OpEquals

    test "composite qualifier without spaces is recognized":
        let cq = CompositeQualifier(parseQualifier(docType, "(0201=123&0202=456)"))
        check:
            cq.operator == OpAnd
            cq.qualifiers.len == 2

    test "composite qualifier with spaces is recognized":
        let cq = CompositeQualifier(parseQualifier(docType, " ( 0201 = 123 & 0202 = 456 ) "))
        check:
            cq.operator == OpAnd
            cq.qualifiers.len == 2
        let eq = NumberQualifier(cq.qualifiers[0])
        let eq2 = NumberQualifier(cq.qualifiers[1])
        check:
             eq.leType == leType
             eq.refValue == 123
             eq.operator == OpEquals
             eq2.leType == leType2
             eq2.refValue == 456
             eq2.operator == OpEquals

    test "composite qualifier with more than two subqualifiers is recognized":
        let cq = CompositeQualifier(parseQualifier(docType, "(0201=123&0202<456&0203!=\"789\")"))
        check:
            cq.operator == OpAnd
            cq.qualifiers.len == 3
        let eq = NumberQualifier(cq.qualifiers[0])
        let eq2 = NumberQualifier(cq.qualifiers[1])
        let eq3 = StringQualifier(cq.qualifiers[2])
        check:
             eq.leType == leType
             eq.refValue == 123
             eq.operator == OpEquals
             eq2.leType == leType2
             eq2.refValue == 456
             eq2.operator == OpLessThan
             eq3.leType == leType3
             eq3.refValue == "789"
             eq3.operator == OpUnequal

    test "date qualifier is recognized":
        let eq = DateQualifier(parseQualifier(docType, "0204=20000101"))
        check:
            eq.leType == leType4
            eq.refValue.format(cVektisDateFormat) == "20000101"
            eq.operator == OpEquals

    test "number qualifier match":
        check:
            parseQualifier(docType, " 0201 = 123" ).qualifies(ctx)
            parseQualifier(docType, " 0201 > 122" ).qualifies(ctx)
            parseQualifier(docType, " 0201 < 124" ).qualifies(ctx)
            parseQualifier(docType, " 0201 != 122" ).qualifies(ctx)
            not parseQualifier(docType, " 0201 = 122" ).qualifies(ctx)
            not parseQualifier(docType, " 0201 > 123" ).qualifies(ctx)

    test "string qualifier match":
        check:
            parseQualifier(docType, " 0203 = \"test\"" ).qualifies(ctx)
            parseQualifier(docType, " 0203 < \"test \"" ).qualifies(ctx)
            parseQualifier(docType, " 0203 != \"test \"" ).qualifies(ctx)
            not parseQualifier(docType, " 0203 = \"test \"" ).qualifies(ctx)

    test "date qualifier match":
        check:
            parseQualifier(docType, " 0204 = 19860709" ).qualifies(ctx)
            parseQualifier(docType, " 0204 > 19860708" ).qualifies(ctx)
            parseQualifier(docType, " 0204 < 19860710" ).qualifies(ctx)
            parseQualifier(docType, " 0204 != 19860710" ).qualifies(ctx)

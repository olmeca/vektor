import unittest
import "qualifiers", "common"

suite "qualifiers":

   setup:
      let leType = LineElementType(lineElementId: "0201", fieldType: cFieldTypeNumeric, code: "NUM123")
      let leType2 = LineElementType(lineElementId: "0202", fieldType: cFieldTypeNumeric, code: "BED456")
      let leType3 = LineElementType(lineElementId: "0203", fieldType: cFieldTypeAlphaNum, code: "COD789")
      let lType = LineType(lineId: "02", lineElementTypes: @[leType, leType2, leType3])
      var docType = DocumentType(lineTypes: @[lType])

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


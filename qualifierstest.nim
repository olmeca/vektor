import unittest
import "qualifiers", "common"

suite "qualifiers":

   setup:
      var docType: DocumentType = nil

   test "elementary qualifier with spaces is recognized":
      let eq = ElementaryQualifier(parseQualifier(docType, " 0201 = 123" ))
      check:
         eq.key == "0201"
         eq.value == "123"
         eq.operator == OpEquals

   test "elementary qualifier without spaces is recognized":
      let eq = ElementaryQualifier(parseQualifier(docType, "0201=123"))
      check:
         eq.key == "0201"
         eq.value == "123"
         eq.operator == OpEquals

   test "composite qualifier without spaces is recognized":
      let cq = CompositeQualifier(parseQualifier(docType, "(0201=123&0204=456)"))
      check:
         cq.operator == OpAnd
         cq.qualifiers.len == 2

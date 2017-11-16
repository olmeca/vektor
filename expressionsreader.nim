import pegs, strutils, sequtils, random, times, logging, ospaths, os
import "common", "expressions", "randomstring", "randomdate", "literal", "names"

var readers: seq[ExpressionReader]

proc initializeExpressionReaders*() =
   readers = @[]
   readers.add(newRandomDateExpressionReader())
   readers.add(newRandomNameExpressionReader())
   readers.add(newRandomCapsExpressionReader())
   readers.add(newRandomStringExpressionReader())
   readers.add(newLiteralExpressionReader())

proc readExpression*(valueSpec: string, leId: string, typeCode: string, length: int): Expression =
   assert(readers.len > 0)
   for reader in readers:
      result = reader.read(valueSpec, leId, typeCode, length)
      if not isNil(result):
         break


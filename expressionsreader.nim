import pegs, strutils, sequtils, random, times, logging, ospaths, os
import "common", "expressions", "randomstring", "randomdate", "literal", "names"

var dateExpressionReaders: seq[ExpressionReader] = @[]
var numericExpressionReaders: seq[ExpressionReader] = @[]
var alphaNumExpressionReaders: seq[ExpressionReader] = @[]

proc initializeExpressionReaders*() =
   dateExpressionReaders.add(newRandomDateExpressionReader())
   dateExpressionReaders.add(newLiteralDateReader())
   
   numericExpressionReaders.add(newLiteralNumberReader())
   
   alphaNumExpressionReaders.add(newRandomNameExpressionReader())
   alphaNumExpressionReaders.add(newRandomCapsExpressionReader())
   alphaNumExpressionReaders.add(newRandomStringExpressionReader())
   alphaNumExpressionReaders.add(newLiteralTextReader())

proc readTypedExpression(readers: seq[ExpressionReader], valueSpec: string, leId: string, typeCode: string, length: int): Expression =
   assert(readers.len > 0)
   for reader in readers:
      result = reader.read(valueSpec, leId, typeCode, length)
      if not isNil(result):
         debug("readExpression: leId: '$#', type: '$#', len: $#, spec: '$#' -> $#" % [leId, typeCode, intToStr(length), valueSpec, result.asString()])
         break
   if isNil(result):
      raise newException(ExpressionError, 
         "Invalid value expression '$#' for field '$#' with Vektis type '$#'." % [valueSpec, leId, typeCode])

proc readExpression*(valueSpec: string, leId: string, typeCode: string, length: int): Expression =
   if isDateType(typeCode):
      readTypedExpression(dateExpressionReaders, valueSpec, leId, typeCode, length)
   elif isNumericType(typeCode):
      readTypedExpression(numericExpressionReaders, valueSpec, leId, typeCode, length)
   else:
      readTypedExpression(alphaNumExpressionReaders, valueSpec, leId, typeCode, length)


import strutils, sequtils, random, pegs
import "common", "expressions", "formatting"

const
   cAlphaLower = "abcdefghijklmnopqrstuvwxyz"
   cAlphaUpper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

type
   RandomStringExpression* = ref RandomStringExpressionObj
   RandomStringExpressionObj = object of ExpressionObj
      fieldLength: int
      minLength: int
      maxLength: int
      capitalize: bool

let
   randomStringPattern* = peg"""#
   Pattern <- ^ '{' Spc RandomStringSpec Spc '}' !.
   RandomStringSpec <- Symbol Spc '(' Spc Params Spc ')' Spc / Symbol
   Params <- Digits Spc ',' Spc Digits / Digits
   Symbol <- 'text'
   Digits <- {\d+}
   Spc <- \s*
   """

   randomCapsPattern* = peg"""#
   Pattern <- ^ '{' Spc RandomStringSpec Spc '}' !.
   RandomStringSpec <- Symbol Spc '(' Spc Params Spc ')' Spc / Symbol
   Params <- Digits Spc ',' Spc Digits / Digits
   Symbol <- 'TEXT'
   Digits <- {\d+}
   Spc <- \s*
   """

proc getRandomString*(minlen: int, maxlen: int, capitalize: bool): string =
   let length = minlen + random(maxlen+1 - minlen)
   let source = if capitalize: cAlphaUpper else: cAlphaLower
   result = ""
   for i in 0..length-1:
      result.add(source[random(26)])


proc evaluateRSE(expr: Expression): string =
   let rse = RandomStringExpression(expr)
   getRandomString(rse.minLength, rse.maxLength, rse.capitalize)|L(rse.fieldLength)

proc newRandomStringExpression*(flen: int, minlen: int, maxlen: int, caps: bool): RandomStringExpression =
   result = RandomStringExpression(fieldLength: flen, minLength: minlen, maxLength: maxlen, capitalize: caps, isDerived: true)
   result.evaluateImpl = evaluateRSE

proc readRSE(valueSpec: string, leId: string, typeCode: string, length: int): Expression =
   if valueSpec =~ randomStringPattern:
      if isTextType(typeCode):
         var minlen, maxlen: int
         if isNil(matches[0]):
            minlen = length div 4
            maxlen = length
         else:
            minlen = parseInt(matches[0])
            maxlen = if isNil(matches[1]): minlen else: min(parseInt(matches[1]), length)
         result = newRandomStringExpression(length, minlen, maxlen, false)
      else:
         raise newException(ExpressionError, 
            "Cannot apply random string expression '$#' to field '$#' with Vektis type '$#'." % [valueSpec, leId, typeCode])

proc readRCE(valueSpec: string, leId: string, typeCode: string, length: int): Expression =
   if valueSpec =~ randomCapsPattern:
      if isTextType(typeCode):
         var minlen, maxlen: int
         if isNil(matches[0]):
            minlen = length div 4
            maxlen = length
         else:
            minlen = parseInt(matches[0])
            maxlen = if isNil(matches[1]): minlen else: min(parseInt(matches[1]), length)
         result = newRandomStringExpression(length, minlen, maxlen, true)
      else:
         raise newException(ExpressionError, 
            "Cannot apply random string expression '$#' to field '$#' with Vektis type '$#'." % [valueSpec, leId, typeCode])

proc newRandomCapsExpressionReader*(): ExpressionReader =
   ExpressionReader(pattern: randomCapsPattern, readImpl: readRCE)

proc newRandomStringExpressionReader*(): ExpressionReader =
   ExpressionReader(pattern: randomStringPattern, readImpl: readRSE)
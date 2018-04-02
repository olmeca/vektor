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
   # Expression defining a random lower case string
   # variations: '{randomtext}' or '{randomtext(3)}' or '{randomtext(3, 6)}'
   randomStringPattern* = peg"""#
   Pattern <- ^ RandomStringSpec Spc !.
   RandomStringSpec <- Symbol Spc '(' Spc Params Spc ')' Spc / Symbol
   Params <- Digits Spc ',' Spc Digits / Digits
   Symbol <- 'randomtext'
   Digits <- {\d+}
   Spc <- \s*
   """

   # Expression defining a random lower case string
   # variations: '{RANDOMTEXT}' or '{RANDOMTEXT(3)}' or '{RANDOMTEXT(3, 6)}'
   randomCapsPattern* = peg"""#
   Pattern <- ^ Spc RandomStringSpec Spc !.
   RandomStringSpec <- Symbol Spc '(' Spc Params Spc ')' Spc / Symbol
   Params <- Digits Spc ',' Spc Digits / Digits
   Symbol <- 'RANDOMTEXT'
   Digits <- {\d+}
   Spc <- \s*
   """

proc getRandomString*(minlen: int, maxlen: int, capitalize: bool): string =
   let length = minlen + random(maxlen+1 - minlen)
   let source = if capitalize: cAlphaUpper else: cAlphaLower
   result = ""
   for i in 0..length-1:
      result.add(source[random(26)])

proc asStringRSE(expression: Expression): string =
   let exp = RandomStringExpression(expression)
   "RandomStringExpression(fieldLength: $#, minlen: $#, maxlen:$#, caps:$#)" % 
                           [intToStr(exp.fieldLength), intToStr(exp.minLength), intToStr(exp.maxLength), if exp.capitalize: "true" else: "false"]

proc serializeRSE(expr: Expression): string =
   let rse = RandomStringExpression(expr)
   getRandomString(rse.minLength, rse.maxLength, rse.capitalize)|L(rse.fieldLength)

proc newRandomStringExpression*(flen: int, minlen: int, maxlen: int, caps: bool): RandomStringExpression =
   result = RandomStringExpression(fieldLength: flen, minLength: minlen, maxLength: maxlen, capitalize: caps, isDerived: true)
   result.serializeImpl = serializeRSE
   result.asStringImpl = asStringRSE

proc readRSE(valueSpec: string, leId: string, vektisTypeCode: string, length: int): Expression =
   if valueSpec =~ randomStringPattern:
      if isTextType(vektisTypeCode):
         let minlenString = matches[0]
         let maxlenString = matches[1]
         var minlen, maxlen: int
         if isNil(minlenString):
            minlen = length div 4
            maxlen = length
         else:
            minlen = parseInt(minlenString)
            maxlen = if isNil(maxlenString): minlen else: min(parseInt(maxlenString), length)
         result = newRandomStringExpression(length, minlen, maxlen, false)
      else:
         raise newException(ExpressionError, 
            "Cannot apply random string expression '$#' to field '$#' with Vektis type '$#'." % [valueSpec, leId, vektisTypeCode])

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
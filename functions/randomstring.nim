import strutils, sequtils, random, pegs
import "common", "expressions", "formatting"


type
   RandomStringExpression* = ref RandomStringExpressionObj
   RandomStringExpressionObj = object of ExpressionObj
      fieldLength: int
      minLength: int
      maxLength: int
      source: string

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

   # Expression defining a random upper case string
   # variations: '{RANDOMTEXT}' or '{RANDOMTEXT(3)}' or '{RANDOMTEXT(3, 6)}'
   randomCapsPattern* = peg"""#
   Pattern <- ^ Spc RandomStringSpec Spc !.
   RandomStringSpec <- Symbol Spc '(' Spc Params Spc ')' Spc / Symbol
   Params <- Digits Spc ',' Spc Digits / Digits
   Symbol <- 'RANDOMTEXT'
   Digits <- {\d+}
   Spc <- \s*
   """

   # Expression defining a random digits string
   # variations: '{randomdigits}' or '{randomdigits(3)}' or '{randomdigits(3, 6)}'
   randomDigitsPattern* = peg"""#
   Pattern <- ^ RandomDigitsSpec Spc !.
   RandomDigitsSpec <- Symbol Spc '(' Spc Params Spc ')' Spc / Symbol
   Params <- Digits
   Symbol <- 'randomdigits'
   Digits <- {\d+}
   Spc <- \s*
   """

proc getRandomString*(minlen: int, maxlen: int, source: string): string =
   let length = minlen + random(maxlen+1 - minlen)
   result = ""
   for i in 0..length-1:
      result.add(rand(source))

proc asStringRSE(expression: Expression): string =
   let exp = RandomStringExpression(expression)
   "RandomStringExpression(fieldLength: $#, minlen: $#, maxlen:$#, source:'$#')" %
                           [intToStr(exp.fieldLength), intToStr(exp.minLength), intToStr(exp.maxLength), exp.source]

proc serializeRSE(expr: Expression): string =
   let rse = RandomStringExpression(expr)
   getRandomString(rse.minLength, rse.maxLength, rse.source)|L(rse.fieldLength)

proc newRandomStringExpression*(flen: int, minlen: int, maxlen: int, source: string): RandomStringExpression =
   result = RandomStringExpression(fieldLength: flen, minLength: minlen, maxLength: maxlen, source: source, isDerived: true)
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
         result = newRandomStringExpression(length, minlen, maxlen, cAlphaLower)
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
         result = newRandomStringExpression(length, minlen, maxlen, cAlphaUpper)
      else:
         raise newException(ExpressionError, 
            "Cannot apply random string expression '$#' to field '$#' with Vektis type '$#'." % [valueSpec, leId, typeCode])


proc readRDE(valueSpec: string, leId: string, typeCode: string, length: int): Expression =
   if valueSpec =~ randomDigitsPattern:
      if isTextType(typeCode):
         var minlen, maxlen: int
         if isNil(matches[0]):
            minlen = length div 4
            maxlen = length
         else:
            minlen = parseInt(matches[0])
            maxlen = if isNil(matches[1]): minlen else: min(parseInt(matches[1]), length)
         result = newRandomStringExpression(length, minlen, maxlen, cAlphaDigit)
      else:
         raise newException(ExpressionError,
            "Cannot apply random digits expression '$#' to field '$#' with Vektis type '$#'." % [valueSpec, leId, typeCode])


proc newRandomCapsExpressionReader*(): ExpressionReader =
   ExpressionReader(name: "random upper case text exp. reader", pattern: randomCapsPattern, readImpl: readRCE)


proc newRandomStringExpressionReader*(): ExpressionReader =
   ExpressionReader(name: "random lower case exp. reader", pattern: randomStringPattern, readImpl: readRSE)


proc newRandomDigitsExpressionReader*(): ExpressionReader =
   ExpressionReader(name: "random digits exp. reader", pattern: randomDigitsPattern, readImpl: readRDE)


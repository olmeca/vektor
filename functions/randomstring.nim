import strutils, sequtils, random, pegs
import "common", "expressions", "formatting"


type
   RandomStringExpression* = ref RandomStringExpressionObj
   RandomStringExpressionObj = object of ExpressionObj
      minLength: int
      maxLength: int
      source: string

let
   # Expression defining a random lower case string
   # variations: '{text}' or '{text(3)}' or '{text(3, 6)}'
   randomStringPattern* = peg"""#
   Pattern <- ^ RandomStringSpec Spc !.
   RandomStringSpec <- Symbol Spc '(' Spc Params Spc ')' Spc / Symbol
   Params <- Digits Spc ',' Spc Digits / Digits
   Symbol <- 'text'
   Digits <- {\d+}
   Spc <- \s*
   """

   # Expression defining a random upper case string
   # variations: '{TEXT}' or '{TEXT(3)}' or '{TEXT(3, 6)}'
   randomCapsPattern* = peg"""#
   Pattern <- ^ Spc RandomStringSpec Spc !.
   RandomStringSpec <- Symbol Spc '(' Spc Params Spc ')' Spc / Symbol
   Params <- Digits Spc ',' Spc Digits / Digits
   Symbol <- 'TEXT'
   Digits <- {\d+}
   Spc <- \s*
   """

   # Expression defining a random digits string
   # variations: '{digits}' or '{digits(3)}' or '{digits(3, 6)}'
   randomDigitsPattern* = peg"""#
   Pattern <- ^ RandomDigitsSpec Spc !.
   RandomDigitsSpec <- Symbol Spc '(' Spc Params Spc ')' Spc / Symbol
   Params <- Digits
   Symbol <- 'digits'
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
   "RandomStringExpression(minlen: $#, maxlen:$#, source:'$#')" %
                           [intToStr(exp.minLength), intToStr(exp.maxLength), exp.source]


proc evaluateRSE(expr: Expression, context: Context): VektisValue =
    let rse = RandomStringExpression(expr)
    let value = getRandomString(rse.minLength, rse.maxLength, rse.source)
    VektisValue(kind: StringValueType, stringValue: value)


proc newRandomStringExpression*(minlen: int, maxlen: int, source: string): RandomStringExpression =
   result = RandomStringExpression(minLength: minlen, maxLength: maxlen, source: source, isDerived: true)
   result.asStringImpl = asStringRSE


proc readRandomStringExpression(valueSpec: string, pattern: PEG, source: string, description: string): Expression =
    if valueSpec =~ pattern:
        let minlenString = matches[0]
        let maxlenString = matches[1]
        var minlen, maxlen: int
        minlen = parseInt(minlenString)
        maxlen = parseInt(maxlenString)
        result = newRandomStringExpression(minlen, maxlen, source)
    else:
        result = nil


proc readRSE(valueSpec: string): Expression =
    readRandomStringExpression(valueSpec, randomStringPattern, cAlphaLower, "random lowercase text")


proc readRCE(valueSpec: string): Expression =
    readRandomStringExpression(valueSpec, randomCapsPattern, cAlphaUpper, "random uppercase text")


proc readRDE(valueSpec: string): Expression =
    readRandomStringExpression(valueSpec, randomDigitsPattern, cAlphaDigit, "random digits")


proc newRandomCapsExpressionReader*(): ExpressionReader =
   ExpressionReader(name: "random upper case text exp. reader", valueType: StringValueType, pattern: randomCapsPattern, readImpl: readRCE)


proc newRandomStringExpressionReader*(): ExpressionReader =
   ExpressionReader(name: "random lower case exp. reader", valueType: StringValueType, pattern: randomStringPattern, readImpl: readRSE)


proc newRandomDigitsExpressionReader*(): ExpressionReader =
   ExpressionReader(name: "random digits exp. reader", valueType: StringValueType, pattern: randomDigitsPattern, readImpl: readRDE)


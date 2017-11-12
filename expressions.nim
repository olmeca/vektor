import pegs, strutils, sequtils, random, times, logging
import "common", "formatting"

const
   cAlphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

type
   ExpressionError = object of Exception
   Expression* = ref ExpressionObj
   ExpressionObj = object of RootObj
      evaluateImpl: proc(expr: Expression): string
      isDerived*: bool

proc evaluate*(expr: Expression): string =
   expr.evaluateImpl(expr)

type 
   RandomStringExpression* = ref RandomStringExpressionObj
   RandomStringExpressionObj = object of ExpressionObj
      fieldLength: int
      minLength: int
      maxLength: int

   RandomDateExpression* = ref RandomDateExpressionObj
   RandomDateExpressionObj = object of ExpressionObj
      fromSeconds: float
      toSeconds: float

   LiteralValueExpression* = ref LiteralValueExpressionObj
   LiteralValueExpressionObj = object of ExpressionObj
      value: string

let
   fieldSpecPattern* = peg"""#
   Pattern <- ^ {ElementId} !.
   ElementId <- \d \d \d \d
   """

   fieldValueSpecPattern* = peg"""#
   Pattern <- ^ ElementSpec !.
   ElementSpec <-  {ElementId} '=' {ElementValue} / {ElementId}
   ElementId <- \d \d \d \d
   ElementValue <- .*
   """

   # Comma separated list of element spec
   fieldSpecsPattern* = peg"""#
   Pattern <- ^ ElementsSpec !.
   ElementsSpec <- ElementSpec ElementSpecSeparator ElementsSpec / ElementSpec
   ElementSpec <- {(!ElementSpecSeparator .)+}
   ElementSpecSeparator <- ','
   """
   
   randomDatePattern* = peg"""#
   Pattern <- ^ RandomDateSpec !.
   RandomDateSpec <- '@date:' {Date} '-' {Date}
   Date <- \d \d \d \d \d \d \d \d
   """

   vektisDatePattern* = peg"""#
   Pattern <- ^ VektisDate !.
   VektisDate <- \d \d \d \d \d \d \d \d
   """

   randomStringPattern* = peg"""#
   Pattern <- ^ RandomStringSpec !.
   RandomStringSpec <- Symbol ':' Params / Symbol
   Params <- Digits '-' Digits / Digits
   Symbol <- '@alpha'
   Digits <- {\d+}
   """


proc getRandomString(minlen: int, maxlen: int): string =
   let length = minlen + random(maxlen+1 - minlen)
   result = ""
   for i in 0..length-1:
      result.add(cAlphabet[random(cAlphabet.len)])


proc evaluateRSE(expr: Expression): string =
   let rse = RandomStringExpression(expr)
   getRandomString(rse.minLength, rse.maxLength)|L(rse.fieldLength)

proc evaluateRDE(expr: Expression): string =
   let rde = RandomDateExpression(expr)
   let randomSeconds = random(rde.toSeconds-rde.fromSeconds) + rde.fromSeconds
   let randomDate = fromSeconds(randomSeconds).getLocalTime()
   format(randomDate, cVektisDateFormat)

proc evaluateLVE(expr: Expression): string =
   let lve = LiteralValueExpression(expr)
   lve.value

proc newRandomStringExpression*(flen: int, minlen: int, maxlen: int): RandomStringExpression =
   result = RandomStringExpression(fieldLength: flen, minLength: minlen, maxLength: maxlen, isDerived: true)
   result.evaluateImpl = evaluateRSE

proc newLiteralExpression*(literal: string, typeCode: string, length: int): LiteralValueExpression =
   var value = literal
   if isNil(value):
      if isTextType(typeCode):
         value = spaces(length)
      else:
         value = intToStr(0, length)
   let safeLength = min(len(value), length)
   result = LiteralValueExpression(value: value[0 .. <safeLength]|L(length), isDerived: false)
   result.evaluateImpl = evaluateLVE

proc newRandomDateExpression*(min: float, max: float): RandomDateExpression =
   result = RandomDateExpression(fromSeconds: min, toSeconds: max, isDerived: true)
   result.evaluateImpl = evaluateRDE

proc readExpression*(valueSpec: string, leId: string, typeCode: string, length: int): Expression =
   if isNil(valueSpec) or len(valueSpec) == 0:
      result = newLiteralExpression(nil, typeCode, length)
   elif valueSpec =~ randomDatePattern:
      if isDateType(typeCode):
         let fromSeconds = parseVektisDate(matches[0]).toTime().toSeconds()
         let toSeconds = parseVektisDate(matches[1]).toTime().toSeconds()
         result = newRandomDateExpression(fromSeconds, toSeconds)
      else:
         raise newException(ExpressionError, "Cannot apply random date expression '$#' to field '$#' with Vektis type '$#'." % [valueSpec, leId, typeCode])
   elif valueSpec =~ randomStringPattern:
      if isTextType(typeCode):
         var minlen, maxlen: int
         if isNil(matches[0]):
            minlen = length div 4
            maxlen = length
         else:
            minlen = parseInt(matches[0])
            maxlen = if isNil(matches[1]): minlen else: min(parseInt(matches[1]), length)
         result = newRandomStringExpression(length, minlen, maxlen)
      else:
         raise newException(ExpressionError, "Cannot apply random string expression '$#' to field '$#' with Vektis type '$#'." % [valueSpec, leId, typeCode])
   else:
      if isDateType(typeCode):
         if valueSpec =~ vektisDatePattern:
            result = newLiteralExpression(valueSpec, typeCode, length)
         else:
            raise newException(ExpressionError, "Invalid date expression '$#' for field '$#' with Vektis type '$#'." % [valueSpec, leId, typeCode])
      elif isNumericType(typeCode):
         if isDigit(valueSpec):
            result = newLiteralExpression(valueSpec, typeCode, length)
         else:
            raise newException(ExpressionError, "Invalid numeric expression '$#' for field '$#' with Vektis type '$#'." % [valueSpec, leId, typeCode])


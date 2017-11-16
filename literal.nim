import strutils, sequtils, pegs
import "common", "expressions", "formatting"

type
   LiteralValueExpression* = ref LiteralValueExpressionObj
   LiteralValueExpressionObj = object of ExpressionObj
      value: string

let
   literalValuePattern = peg"""
   Pattern <- .*
   """
   literalAlphaNumPattern = peg"""
   Pattern <- Spc {Word} Spc
   Word <- [0-9a-zA-Z]+
   Spc <- \s*
   """
   literalTextPattern = peg"""
   Pattern <- Spc ''\' {Word} ''\' Spc
   Word <- (![';] .)+
   Spc <- \s*
   """
   literalNumberPattern = peg"""
   Pattern <- Spc {Number} Spc
   Number <- \d+
   Spc <- \s*
   """

   literalDatePattern = peg"""
   Pattern <- Spc {Date} Spc
   Date <- \d \d \d \d \d \d \d \d
   Spc <- \s*
   """

proc evaluateLVE(expr: Expression): string =
   let lve = LiteralValueExpression(expr)
   lve.value

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

proc readLiteral(valueSpec: string, leId: string, typeCode: string, length: int): Expression =
   if isDateType(typeCode):
      if valueSpec =~ literalDatePattern:
         result = newLiteralExpression(matches[0], typeCode, length)
      else:
         raise newException(ExpressionError, 
            "Invalid date expression '$#' for field '$#' with Vektis type '$#'." % [valueSpec, leId, typeCode])
   elif isNumericType(typeCode):
      if valueSpec =~ literalNumberPattern:
         result = newLiteralExpression(matches[0], typeCode, length)
      else:
         raise newException(ExpressionError, 
            "Invalid numeric expression '$#' for field '$#' with Vektis type '$#'." % [valueSpec, leId, typeCode])
   else:
      if valueSpec =~ literalTextPattern:
         result = newLiteralExpression(matches[0], typeCode, length)
      else:
         result = newLiteralExpression(valueSpec, typeCode, length)

proc newLiteralExpressionReader*(): ExpressionReader = 
   ExpressionReader(pattern: literalValuePattern, readImpl: readLiteral)
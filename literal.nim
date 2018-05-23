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

   # Literal string must be enclosed in double quotes: "mystring"
   literalTextPattern = peg"""
   Pattern <- Spc '"' {Word} '"' Spc
   Word <- (!["] .)+
   Spc <- \s*
   """
   literalNumberPattern = peg"""
   Pattern <- Spc {Number} Spc
   Number <- \d+
   Spc <- \s*
   """

   literalDatePattern = peg"""
   Pattern <- Spc {Date} Spc
   Date <- ('19' / '20') \d \d \d \d \d \d
   Spc <- \s*
   """

proc serializeLVE(expr: Expression): string =
   let lve = LiteralValueExpression(expr)
   lve.value

proc asStringLVE(expression: Expression): string =
   let lve = LiteralValueExpression(expression)
   "LiteralValuexpression ('$#')" % [lve.value]

proc newLiteralExpression*(literal: string, typeCode: string, length: int): LiteralValueExpression =
   var value = literal
   if isNil(value):
      if isTextType(typeCode):
         value = spaces(length)
      else:
         value = intToStr(0, length)
   let safeLength = min(len(value), length)
   result = LiteralValueExpression(value: value[0 .. <safeLength]|L(length), isDerived: false)
   result.serializeImpl = serializeLVE
   result.asStringImpl = asStringLVE

proc readLiteralDate(valueSpec: string, leId: string, typeCode: string, length: int): Expression =
   if valueSpec =~ literalDatePattern:
      result = newLiteralExpression(matches[0], typeCode, length)
   else:
      raise newException(ExpressionError,
         "Invalid date expression '$#' for field '$#' with Vektis type '$#'." % [valueSpec, leId, typeCode])

proc readLiteralNumber(valueSpec: string, leId: string, typeCode: string, length: int): Expression =
   if valueSpec =~ literalNumberPattern:
      result = newLiteralExpression(matches[0], typeCode, length)
   else:
      raise newException(ExpressionError,
         "Invalid numeric expression '$#' for field '$#' with Vektis type '$#'." % [valueSpec, leId, typeCode])

proc readLiteralText(valueSpec: string, leId: string, typeCode: string, length: int): Expression =
   if valueSpec =~ literalTextPattern:
      result = newLiteralExpression(matches[0], typeCode, length)
   else:
      raise newException(ExpressionError,
         "Invalid literal text expression '$#' for field '$#' with Vektis type '$#'." % [valueSpec, leId, typeCode])

proc newLiteralDateReader*(): ExpressionReader = 
   ExpressionReader(pattern: literalDatePattern, readImpl: readLiteralDate)

proc newLiteralNumberReader*(): ExpressionReader = 
   ExpressionReader(pattern: literalNumberPattern, readImpl: readLiteralNumber)

proc newLiteralTextReader*(): ExpressionReader = 
   ExpressionReader(pattern: literalValuePattern, readImpl: readLiteralText)

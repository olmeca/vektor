import strutils, sequtils, parseutils, pegs, logging
import common, expressions, formatting, times

type
   LiteralValueExpression* = ref LiteralValueExpressionObj
   LiteralValueExpressionObj = object of ExpressionObj
      value: VektisValue
   LiteralStringExpression* = ref object of LiteralValueExpression
   LiteralNaturalExpression* = ref object of LiteralValueExpression
   LiteralAmountExpression* = ref object of LiteralValueExpression
   LiteralDateExpression* = ref object of LiteralValueExpression

let
   literalValuePattern = peg"""
   Pattern <- .*
   """

   # Literal string must be enclosed in double quotes: "mystring"
   literalTextPattern = peg"""
   Pattern <- ^ Spc '"' {Word} '"' Spc !.
   Word <- (!["] .)*
   Spc <- \s*
   """
   literalNaturalPattern = peg"""
   Pattern <- ^ Spc {Number} Spc !.
   Number <- \d+
   Spc <- \s*
   """

   literalAmountPattern = peg"""
   Pattern <- ^ Spc Number Spc !.
   Number <- {IntegerPart} '.' {DecimalPart}
   IntegerPart <- '-'? \d+
   DecimalPart <- \d \d
   Spc <- \s*
   """

   literalDatePattern = peg"""
   Pattern <- ^ Spc {Date} Spc !.
   Date <- EmptyDate / FilledDate
   FilledDate <- Year '-' Month '-' Day
   Year <- ('19' / '20') \d \d
   Month <- Positive / '1' [0-2]
   Day <- Positive / [1-2] \d / '3' [0-1]
   Positive <- '0' [1-9]
   EmptyDate <- 'null'
   Spc <- \s*
   """

proc evaluateLVE(expression: Expression, context: Context): VektisValue =
    let exp = LiteralValueExpression(expression)
    exp.value

proc asStringLVE(expression: Expression): string =
    LiteralValueExpression(expression).value.asString


proc newLiteralNaturalExpression(value: VektisValue): LiteralNaturalExpression =
    result = LiteralNaturalExpression(
        value: value,
        valueType: NaturalValueType,
        evaluateImpl: evaluateLVE,
        asStringImpl: asStringLVE
    )

proc newLiteralAmountExpression(value: VektisValue): LiteralAmountExpression =
    result = LiteralAmountExpression(
        value: value,
        valueType: AmountValueType,
        evaluateImpl: evaluateLVE,
        asStringImpl: asStringLVE
    )


proc newLiteralDateExpression(value: VektisValue): LiteralDateExpression =
    result = LiteralDateExpression(
        value: value,
        valueType: DateValueType,
        evaluateImpl: evaluateLVE,
        asStringImpl: asStringLVE
    )


proc newLiteralStringExpression(value: VektisValue): LiteralStringExpression =
    result = LiteralStringExpression(
        value: value,
        valueType: StringValueType,
        evaluateImpl: evaluateLVE,
        asStringImpl: asStringLVE
    )


proc readLiteralDate(valueSpec: string): Expression =
   debug("readLiteralDate: '$#'" % valueSpec)
   if valueSpec =~ literalDatePattern:
      var dateVektisValue: VektisValue
      # Interpret zeros as nil date
      if valueSpec == cEmptyVektisValueLiteral:
         dateVektisValue = VektisValue(kind: EmptyValueType)
      else:
         let date = parseLiteralDateExpression(matches[0])
         dateVektisValue = VektisValue(kind: DateValueType, dateValue: date)
      result = newLiteralDateExpression(dateVektisValue)
   else:
      result = nil


proc readLiteralNatural(valueSpec: string): Expression =
   if valueSpec =~ literalNaturalPattern:
      var natValue: uint
      if parseUInt(matches[0], natValue) == 0:
         raise newException(ValueError, "Cannot parse integer: '$#'" % valueSpec)
      let natVektisValue = VektisValue(kind: NaturalValueType, naturalValue: natValue)
      result = newLiteralNaturalExpression(natVektisValue)
   else:
      result = nil


proc readLiteralAmount(valueSpec: string): Expression =
   if valueSpec =~ literalAmountPattern:
      let integerValue = parseInt(if isNil(matches[1]): matches[0] else: matches[0] & matches[1])
      let amtVektisValue = VektisValue(kind: AmountValueType, amountValue: integerValue)
      result = newLiteralAmountExpression(amtVektisValue)
   else:
      result = nil

proc readLiteralText(valueSpec: string): Expression =
   if valueSpec =~ literalTextPattern:
      # Interpret empty string as nil
      let stringValue = if matches[0] == "": nil else: matches[0]
      let stringVektisValue = VektisValue(kind: StringValueType, stringValue: stringValue)
      result = newLiteralStringExpression(stringVektisValue)
   else:
      result = nil

proc newLiteralDateReader*(): ExpressionReader = 
   ExpressionReader(name: "literal date exp. reader", valueType: DateValueType, pattern: literalDatePattern, readImpl: readLiteralDate)

proc newLiteralNaturalReader*(): ExpressionReader =
   ExpressionReader(name: "literal natural exp. reader", valueType: NaturalValueType, pattern: literalNaturalPattern, readImpl: readLiteralNatural)

proc newLiteralAmountReader*(): ExpressionReader =
   ExpressionReader(name: "literal number exp. reader", valueType: AmountValueType, pattern: literalAmountPattern, readImpl: readLiteralAmount)

proc newLiteralTextReader*(): ExpressionReader =
   ExpressionReader(name: "literal text exp. reader", valueType: StringValueType, pattern: literalValuePattern, readImpl: readLiteralText)

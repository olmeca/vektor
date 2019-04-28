import strutils, sequtils, random, pegs, logging
import common, expressions, formatting


type
    RandomNaturalExpression* = ref RandomNaturalExpressionObj
    RandomNaturalExpressionObj = object of ExpressionObj
        maxNum: int

let
   # Expression defining a random number
   # variations: 'natural(3)''
   randomNaturalPattern* = peg"""#
   Pattern <- ^ Spc RandomIntSpec Spc !.
   RandomIntSpec <- Symbol Spc '(' Spc Digits Spc ')' Spc / Symbol
   Symbol <- 'natural'
   Digits <- {\d+}
   Spc <- \s*
   """

proc evaluateRNrE(exp: Expression, context: Context): VektisValue =
    let rne = RandomNaturalExpression(exp)
    let value = uint(rand(rne.maxNum))
    VektisValue(kind: NaturalValueType, naturalValue: value)

proc asStringRNrE(exp: Expression): string =
    let rne = RandomNaturalExpression(exp)
    "RandomNaturalExpression($#)" % [intToStr(rne.maxNum)]

proc newRandomNaturalExpression(num: int): RandomNaturalExpression =
    RandomNaturalExpression(
        valueType: NaturalValueType,
        maxNum: num,
        asStringImpl: asStringRNrE,
        evaluateImpl: evaluateRNrE,
        isDerived: true)

proc readRNrE(reader: ExpressionReader, valueSpec: string): Expression =
    if valueSpec =~ randomNaturalPattern:
        debug("NumberExpression.readRNrE: match: '$#'" % valueSpec)
        let maxNum = parseInt(matches[0])
        result = newRandomNaturalExpression(maxNum)
    else:
        result = nil


proc newRandomNaturalExpressionReader*(): ExpressionReader =
   ExpressionReader(name: "random number exp. reader", valueType: NaturalValueType, pattern: randomNaturalPattern, readImpl: readRNrE)

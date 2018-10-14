import strutils, sequtils, random, pegs
import common, expressions, formatting


type
    RandomPostcodeExpression* = ref RandomPostcodeExpressionObj
    RandomPostcodeExpressionObj = object of ExpressionObj
        maxNum: int
        length: int

let
   randomPostcodePattern* = peg"Pattern <-  ^ 'postcode()' !."


proc getRandomPostcode(): string =
    let pcNum = 1000 + rand(8999)
    result = pcNum|R(4)
    result.add(rand(cAlphaUpper))
    result.add(rand(cAlphaUpper))

proc evaluatePCE(exp: Expression, context: Context): VektisValue =
    VektisValue(kind: StringValueType, stringValue: getRandomPostcode())

proc asStringPCE(exp: Expression): string =
    "RandomPostcodeExpression()"

proc newRandomPostcodeExpression(): RandomPostcodeExpression =
    RandomPostcodeExpression(evaluateImpl: evaluatePCE, asStringImpl: asStringPCE)

proc readPCE(valueSpec: string): Expression =
    if valueSpec =~ randomPostcodePattern:
        result = newRandomPostcodeExpression()
    else:
        result = nil


proc newRandomPostcodeExpressionReader*(): ExpressionReader =
   ExpressionReader(name: "random postcode exp. reader", valueType: StringValueType, pattern: randomPostcodePattern, readImpl: readPCE)

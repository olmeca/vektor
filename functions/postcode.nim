import strutils, sequtils, random, pegs
import "common", "expressions", "formatting"


type
    RandomPostcodeExpression* = ref RandomPostcodeExpressionObj
    RandomPostcodeExpressionObj = object of ExpressionObj
        maxNum: int
        length: int

let
   randomPostcodePattern* = peg"Pattern <-  ^ 'randompostcode' !."


proc getRandomPostcode(): string =
    let pcNum = 1000 + rand(8999)
    result = pcNum|R(4)
    result.add(rand(cAlphaUpper))
    result.add(rand(cAlphaUpper))

proc serializePCE(exp: Expression): string =
    getRandomPostcode()

proc asStringPCE(exp: Expression): string =
    "RandomPostcodeExpression()"

proc newRandomPostcodeExpression(): RandomPostcodeExpression =
    result = RandomPostcodeExpression()
    result.serializeImpl = serializePCE
    result.asStringImpl = asStringPCE

proc readPCE(valueSpec: string, leId: string, vektisTypeCode: string, length: int): Expression =
    if valueSpec =~ randomPostcodePattern:
        result = newRandomPostcodeExpression()
    else:
        raise newException(ValueError, "Invalid postcode expression: '$#'" % valueSpec)


proc newRandomPostcodeExpressionReader*(): ExpressionReader =
   ExpressionReader(name: "random postcode exp. reader", pattern: randomPostcodePattern, readImpl: readPCE)

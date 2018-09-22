import strutils, sequtils, random, pegs, logging
import "common", "expressions", "formatting"


type
    RandomNumberExpression* = ref RandomNumberExpressionObj
    RandomNumberExpressionObj = object of ExpressionObj
        maxNum: int
        length: int

let
   # Expression defining a random number
   # variations: '{number(3)}' or '{number(3, 6)}'
   randomIntPattern* = peg"""#
   Pattern <- ^ RandomIntSpec Spc !.
   RandomIntSpec <- Symbol Spc '(' Spc Digits Spc ')' Spc / Symbol
   Symbol <- 'randomnumber'
   Digits <- {\d+}
   Spc <- \s*
   """


proc getRandomNumber(maxNum: int, length: int): string =
    rand(maxNum)|R(length)

proc serializeRNrE(exp: Expression): string =
    let rne = RandomNumberExpression(exp)
    getRandomNumber(rne.maxNum, rne.length)

proc asStringRNrE(exp: Expression): string =
    let rne = RandomNumberExpression(exp)
    "RandomNumberExpression($#, $#)" % [intToStr(rne.maxNum), intToStr(rne.length)]

proc newRandomNumberExpression(num: int, len: int): RandomNumberExpression =
    result = RandomNumberExpression(maxNum: num, length: len)
    result.serializeImpl = serializeRNrE
    result.asStringImpl = asStringRNrE

proc readRNrE(valueSpec: string, leId: string, vektisTypeCode: string, length: int): Expression =
    if valueSpec =~ randomIntPattern:
        debug("NumberExpression.readRNrE: match: '$#'" % valueSpec)
        let maxNum = parseInt(matches[0])
        if matches[0].len > length:
             raise newException(ValueError, "Maximum number greater than fits in given length: '$#'" % valueSpec)
        else:
            result = newRandomNumberExpression(maxNum, length)
    else:
        raise newException(ValueError, "Invalid random number expression: '$#'" % valueSpec)


proc newRandomNumberExpressionReader*(): ExpressionReader =
   ExpressionReader(name: "random number exp. reader", pattern: randomIntPattern, readImpl: readRNrE)

import strutils, sequtils, random, pegs, times
import common, expressions


type
   RandomDateExpression* = ref RandomDateExpressionObj
   RandomDateExpressionObj* = object of ExpressionObj
      fromInSeconds: int64
      toInSeconds: int64
      generateImpl: proc(min: int64, max: int64): int64


let
   randomDatePattern* = peg"""#
   Pattern <- ^ Spc RandomDateSpec Spc !.
   RandomDateSpec <- Symbol Spc '(' Spc Date Spc ',' Spc Date Spc ')'
   Symbol <- 'date'
   Date <- {Year '-' Month '-' Day}
   Year <- ('19' / '20') \d \d
   Month <- Positive / '1' [0-2]
   Day <- Positive / [1-2] \d / '3' [0-1]
   Positive <- '0' [1-9]
   Spc <- \s*
   """

proc asStringRDE(expression: Expression): string = 
   let rde = RandomDateExpression(expression)
   let fromDate = rde.fromInSeconds.fromUnix.getLocalTime.format(cReadableDateFormat)
   let toDate = rde.toInSeconds.fromUnix.getLocalTime.format(cReadableDateFormat)
   "RandomDateExpression(from: $#, to: $#)" % [fromDate, toDate]


proc generateRD(min: int64, max: int64): int64 =
    random(int(max - min)) + min


proc generateValue(expr: RandomDateExpression, min: int64, max: int64): DateTime =
    let randomSeconds = expr.generateImpl(min, max)
    fromUnix(randomSeconds).getLocalTime()


proc evaluateRDE(expr: Expression, context: Context): VektisValue =
   let rde = RandomDateExpression(expr)
   let generatedValue = rde.generateValue(rde.fromInSeconds, rde.toInSeconds)
   VektisValue(kind: DateValueType, dateValue: generatedValue)


proc newRandomDateExpression*(min: int64, max: int64, generator: proc (min: int64, max: int64): int64 = generateRD): RandomDateExpression =
   RandomDateExpression(
        valueType: DateValueType,
        fromInSeconds: min,
        toInSeconds: max,
        asStringImpl: asStringRDE,
        evaluateImpl: evaluateRDE,
        generateImpl: generator,
        isDerived: true
   )


proc newRandomDateExpression*(min: DateTime, max: DateTime): RandomDateExpression =
    newRandomDateExpression(min.toTime.toUnix, max.toTime.toUnix)


proc newRandomDateExpression*(min: string, max: string): RandomDateExpression =
    newRandomDateExpression(min.parseVektisDate, max.parseVektisDate)


proc readRDE(valueSpec: string): Expression =
    if valueSpec =~ randomDatePattern:
        let fromSeconds = parseLiteralDateExpression(matches[0]).toTime().toUnix()
        let toSeconds = parseLiteralDateExpression(matches[1]).toTime().toUnix()
        result = newRandomDateExpression(fromSeconds, toSeconds)
    else:
        result = nil


proc newRandomDateExpressionReader*(): ExpressionReader =
   ExpressionReader(name: "random date exp. reader", valueType: DateValueType, pattern: randomDatePattern, readImpl: readRDE)
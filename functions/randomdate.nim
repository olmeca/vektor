import strutils, sequtils, random, pegs, times
import common, expressions

type
   RandomDateExpression* = ref RandomDateExpressionObj
   RandomDateExpressionObj* = object of ExpressionObj
      fromSeconds: float
      toSeconds: float

let
   randomDatePattern* = peg"""#
   Pattern <- ^ Spc RandomDateSpec Spc !.
   RandomDateSpec <- Symbol Spc '(' Spc Date Spc ',' Spc Date Spc ')'
   Symbol <- 'randomdate'
   Date <- {\d \d \d \d \d \d \d \d}
   Spc <- \s*
   """

proc asStringRDE(expression: Expression): string = 
   let rde = RandomDateExpression(expression)
   "RandomDateExpression(from: $#, to: $#)" % [$(fromSeconds(rde.fromSeconds)), $(fromSeconds(rde.toSeconds))]

proc serializeRDE(expr: Expression): string =
   let rde = RandomDateExpression(expr)
   let randomSeconds = random(rde.toSeconds-rde.fromSeconds) + rde.fromSeconds
   let randomDate = fromSeconds(randomSeconds).getLocalTime()
   format(randomDate, cVektisDateFormat)

proc newRandomDateExpression*(min: float, max: float): RandomDateExpression =
   result = RandomDateExpression(fromSeconds: min, toSeconds: max, isDerived: true)
   result.serializeImpl = serializeRDE
   result.asStringImpl = asStringRDE

proc readRDE(valueSpec: string, leId: string, vektisTypeCode: string, length: int): Expression =
   if valueSpec =~ randomDatePattern:
      if isDateType(vektisTypeCode):
         let fromSeconds = parseVektisDate(matches[0]).toTime().toSeconds()
         let toSeconds = parseVektisDate(matches[1]).toTime().toSeconds()
         result = newRandomDateExpression(fromSeconds, toSeconds)
      else:
         raise newException(ExpressionError, 
            "Cannot apply random date expression '$#' to field '$#' with Vektis type '$#'." % [valueSpec, leId, vektisTypeCode])

proc newRandomDateExpressionReader*(): ExpressionReader =
   ExpressionReader(name: "random date exp. reader", pattern: randomDatePattern, readImpl: readRDE)
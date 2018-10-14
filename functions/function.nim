import strutils, sequtils, random, pegs, times
import common, expressions

type
   FunctionExpression* = ref FunctionExpressionObj
   FunctionExpressionObj* = object of ExpressionObj
      name: string
      parameters: seq[Expression]

let
   functionPattern* = peg"""#
   Pattern <- ^ Spc Expression Spc !.
   Expression <- Function / String / Natural / Amount
   Function <- {Symbol} '(' {Params} ')'
   Symbol <- \ident
   Params <- Expression ',' Params / Expression
   String <- '"' (!'"' .)* '"'
   Natural <- \d+
   Amount <- '-'? \d+ '.' \d \d
   Spc <- \s*
   """

   stringPattern* = peg"""#
   Pattern <- ^ Spc String Spc !.
   String <- '"' (!'"' .)* '"'
   Spc <- \s*
   """

   integerPattern* = peg"""#
   Pattern <- ^ Spc Digits Spc !.
   Digits <- \d+
   Spc <- \s*
   """

   decimalPattern* = peg"""#
   Pattern <- ^ Spc Decimal Spc !.
   Decimal <- Integer '.' Fraction
   Integer <- \d+
   Fraction <- \d \d
   Spc <- \s*
   """

proc newFunctionExpression(name: string, params: seq[Expression]): FunctionExpression =
    FunctionExpression(name: name, parameters: params)

proc readFE(valueSpec: string, leId: string, vektisTypeCode: string, length: int): Expression =
    if valueSpec =~ expressionPattern:
        let name = matches[0]
        let params = matches[1]
        newFunctionExpression(name, params)
    else:
        raise newException(ExpressionError, "Invalid function expression: $#" % valueSpec)
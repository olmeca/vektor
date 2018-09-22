import strutils, sequtils, random, pegs, os, ospaths
import "common", "expressions", "formatting", "nameslist.nim"

const
   cNamesListFile = "names.txt"

type 
   RandomNameExpression* = ref RandomNameExpressionObj
   RandomNameExpressionObj = object of ExpressionObj
      fieldLength: int

let
   randomNamePattern* = peg"""
   Pattern <-  ^ 'randomname' !.
   """


proc asStringRNE(exp: Expression): string =
   let rne = RandomNameExpression(exp)
   "RandomNameExpression(length: $#)" % [intToStr(rne.fieldLength)]

proc readNamesList(): seq[string] =
   result = @[]
   let fullPath = joinPath(getAppDir(), cDataDir, cNamesListFile)
   for line in lines fullPath:
      result.add(line)

proc getRandomName(): string =
   rand(allNames)

proc serializeRNE(expr: Expression): string =
   let rne = RandomNameExpression(expr)
   let name = getRandomName()
   result = if name.len > rne.fieldLength: name.substr(rne.fieldLength) else: name|L(rne.fieldLength)

proc newRandomNameExpression*(length: int): RandomNameExpression =
   result = RandomNameExpression(fieldLength: length, isDerived: true)
   result.serializeImpl = serializeRNE
   result.asStringImpl = asStringRNE

proc readRNE(valueSpec: string, leId: string, typeCode: string, length: int): Expression =
   if valueSpec =~ randomNamePattern:
      if isTextType(typeCode):
         result = newRandomNameExpression(length)
      else:
         raise newException(ExpressionError, 
            "Cannot apply random name expression '$#' to field '$#' with Vektis type '$#'." % [valueSpec, leId, typeCode])

proc newRandomNameExpressionReader*(): ExpressionReader =
   ExpressionReader(name: "random name exp. reader", pattern: randomNamePattern, readImpl: readRNE)

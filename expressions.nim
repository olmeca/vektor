import pegs, strutils, sequtils
import "common"

type
   ExpressionError* = object of Exception
   Expression* = ref ExpressionObj
   ExpressionObj* = object of RootObj
      evaluateImpl*: proc(expr: Expression): string
      isDerived*: bool

   ExpressionReader* = ref ExpressionReaderObj
   ExpressionReaderObj* = object of RootObj
      pattern*: TPeg
      readImpl*: proc(valueSpec: string, leId: string, typeCode: string, length: int): Expression

proc evaluate*(expr: Expression): string =
   expr.evaluateImpl(expr)

proc read*(exprReader: ExpressionReader, valueSpec: string, leId: string, typeCode: string, length: int): Expression =
   exprReader.readImpl(valueSpec, leId, typeCode, length)

let
   fieldSpecPattern* = peg"""
   Pattern <- ^ Spc {ElementId} Spc !.
   ElementId <- \d \d \d \d
   Spc <- \s*
   """

   fieldValueSpecPattern* = peg"""
   Pattern <- ^ ElementSpec !.
   ElementSpec <- Spc {ElementId} Spc '=' Spc {ElementValue} Spc
   ElementId <- \d \d \d \d
   Spc <- \s*
   ElementValue <- .*
   """

   # Semicolon separated list of element spec
   fieldSpecsPattern* = peg"""
   Pattern <- ^ ElementsSpec !.
   ElementsSpec <- ElementSpec Sep ElementsSpec / ElementSpec 
   ElementSpec <- {(!Sep .)+}
   Sep <- ';'
   """
   

import pegs, strutils, sequtils
import "common"

type
   ExpressionError* = object of Exception
   Expression* = ref ExpressionObj
   ExpressionObj* = object of RootObj
      serializeImpl*: proc(expr: Expression): string
      asStringImpl*: proc(expr: Expression): string
      isDerived*: bool

   ExpressionReader* = ref ExpressionReaderObj
   ExpressionReaderObj* = object of RootObj
      pattern*: Peg
      readImpl*: proc(valueSpec: string, leId: string, typeCode: string, length: int): Expression

proc serialize*(expr: Expression): string =
   expr.serializeImpl(expr)

proc asString*(expr: Expression): string =
   expr.asStringImpl(expr)

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
   ElementSpec <- Spc {ElementId} Spc '=' Spc {ElementValue} \n*
   ElementId <- \d \d \d \d
   Spc <- \s*
   ElementValue <- (!Sep .)+
   Sep <- [;\x13\x10]
   """

   # Semicolon or line separated list of element spec
   fieldSpecsPattern* = peg"""
   Pattern <- ^ ElementsSpec Sep* !.
   ElementsSpec <- ElementSpec Sep+ ElementsSpec / ElementSpec
   ElementSpec <- {(!Sep .)+}
   Sep <- [;\x13\x10]
   """
   

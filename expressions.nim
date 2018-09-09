import pegs, strutils, sequtils
import "common"

proc serialize*(expr: Expression): string =
   expr.serializeImpl(expr)

proc asString*(expr: Expression): string =
   expr.asStringImpl(expr)

proc read*(exprReader: ExpressionReader, valueSpec: string, leId: string, typeCode: string, length: int): Expression =
   exprReader.readImpl(valueSpec, leId, typeCode, length)

let
   fieldSpecPatternSpec = """
   Pattern <- ^ Spc ElementSpec Spc !.
   ElementSpec <- {ElementId} (':' {ElementTitle})?
   ElementId <- \d \d \d \d
   ElementTitle <- [A-Za-z-_0-9 .&/%]+
   Spc <- ' '*
   """
   
   fieldValueSpecPatternSpec = """
   Pattern <- ^ ElementSpec !.
   ElementSpec <- Spc {ElementId} Spc '=' Spc {ElementValue} Sep*
   ElementId <- \d \d \d \d
   ElementValue <- (!Sep .)+
   Sep <- (';' / Cr? Lf) Spc*
   Cr <- \13
   Lf <- \10
   Spc <- ' '*
   """

   # Semicolon or line separated list of element spec
   fieldSpecsPatternSpec = """
   Pattern <- ^ ElementsSpec Sep* !.
   ElementsSpec <- ElementSpec Sep+ ElementsSpec / ElementSpec
   ElementSpec <- {(!SepStart .)+}
   SepStart <- (';' / Cr / Lf)
   Sep <- (';' / LineSep) Spc* Comment*
   Comment <- '#' (!LineSep .)* LineSep
   LineSep <- Cr? Lf
   Spc <- ' '*
   Cr <- \13
   Lf <- \10
   """
   
   fieldSpecPattern* = peg(fieldSpecPatternSpec)
   fieldValueSpecPattern* = peg(fieldValueSpecPatternSpec)
   fieldSpecsPattern* = peg(fieldSpecsPatternSpec)

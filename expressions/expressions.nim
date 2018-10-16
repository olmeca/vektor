import pegs, strutils, sequtils, common, logging


proc asString*(expr: Expression): string =
   expr.asStringImpl(expr)


proc evaluate*(expr: Expression, context: Context): VektisValue =
    if isNil(expr): nil else: expr.evaluateImpl(expr, context)

proc read*(exprReader: ExpressionReader, valueSpec: string): Expression =
   exprReader.readImpl(valueSpec)

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


proc readExpression* (readers: seq[ExpressionReader], valueSpec: string): Expression =
    result = nil
    debug("readExpression: readers: $#" % intToStr(readers.len))
    for reader in readers:
        debug("readExpression checking '$#' with $#" % [valueSpec, reader.name])
        result = reader.read(valueSpec)
        # Stop as soon as one has matched
        if not isNil(result):
            break
   # If no matching expression type found
    if isNil(result):
        raise newException(ExpressionError, "Invalid value expression '$#'." % [valueSpec])


proc readExpression* (readers: seq[ExpressionReader], valueSpec: string, valueType: VektisValueType): Expression =
    let typeReaders = readers.filter(proc (r: ExpressionReader): bool = r.valueType == valueType)
    result = typeReaders.readExpression(valueSpec)
    debug("readExpression -> $#" % [if isNil(result): "nil" else: result.asString()])



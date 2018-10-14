import strutils, sequtils, random, pegs, os, ospaths, tables, logging, literal, common, expressions, formatting

const
   cNamesListFile = "names.txt"

type 
   RandomItemExpression* = ref RandomItemExpressionObj
   RandomItemExpressionObj = object of ExpressionObj
      source: string

let
   randomValueSetItemPattern* = peg"""#
   Pattern <- ^ RandomItemSpec Spc !.
   RandomItemSpec <- Spc Symbol Spc '(' Spc '"' {ValueSetName} '"' Spc ')'
   ValueSetName <- [a-z]+
   Symbol <- 'any'
   Spc <- \s*
   """

   gValueReaders: seq[ExpressionReader] = @[newLiteralTextReader(), newLiteralNaturalReader()]

var
    gValueSets* = newTable[string, seq[VektisValue]]()


proc asStringRIE(exp: Expression): string =
   let rie = RandomItemExpression(exp)
   "RandomItemExpression(value type: $#, source: '$#')" % [$(rie.valueType), rie.source]

proc readValuesList(fullPath: string, readers: seq[ExpressionReader]): seq[VektisValue] =
    result = @[]
    for line in lines fullPath:
        let expr = readers.readExpression(line)
        let value = expr.evaluate(nil)
        debug("readValuesList: $#" % asString(value))
        result.add(value)


proc getFilePath(valueSetName: string, context: Context): string =
    let fileName = valueSetName & ".txt"
    result = joinPath(getVektorDataDir(), context.docType.name, fileName)
    debug("getFilePath checking existence of $#" % result)
    if not existsFile(result):
        result = joinPath(getVektorDataDir(), fileName)
        debug("getFilePath checking existence of $#" % result)
        if not existsFile(result):
            raise newException(ValueError, "Unknown value set: '$#'" % valueSetName)
    else: discard


proc getValueSet(valueSetName: string, context: Context): seq[VektisValue] =
    if not gValueSets.contains(valueSetName):
        let filePath = getFilePath(valueSetName, context)
        debug("Reading value set from path '$#'" % filePath)
        gValueSets[valueSetName] = readValuesList(filePath, gValueReaders)
    gValueSets[valueSetName]



proc evaluateRIE(expr: Expression, context: Context): VektisValue =
    assert(not isNil(context))
    let rie = RandomItemExpression(expr)
    assert(not isNil(rie))
    let values = getValueSet(rie.source, context)
    rand(values)


proc newRandomItemExpression*(valueSetName: string): RandomItemExpression =
    RandomItemExpression(source: valueSetName, evaluateImpl: evaluateRIE, asStringImpl: asStringRIE, isDerived: true)


proc readRIE(valueSpec: string): Expression =
    debug("readRIE: '$#'" % valueSpec)
    if valueSpec =~ randomValueSetItemPattern:
        debug("readRIE: matched '$#'" % matches[0])
        result = newRandomItemExpression(matches[0])
    else:
        result = nil


proc newRandomNominalTextExpressionReader*(): ExpressionReader =
   ExpressionReader(name: "random nominal text exp. reader", valueType: StringValueType, pattern: randomValueSetItemPattern, readImpl: readRIE)


proc newRandomNominalNaturalExpressionReader*(): ExpressionReader =
   ExpressionReader(name: "random nominal number exp. reader", valueType: NaturalValueType, pattern: randomValueSetItemPattern, readImpl: readRIE)

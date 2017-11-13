import pegs, strutils, sequtils, random, times, logging, ospaths, os
import "common", "formatting"

const
   cAlphaLower = "abcdefghijklmnopqrstuvwxyz"
   cAlphaUpper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
   cNamesListFile = "names.txt"

type
   ExpressionError = object of Exception
   Expression* = ref ExpressionObj
   ExpressionObj = object of RootObj
      evaluateImpl: proc(expr: Expression): string
      isDerived*: bool

proc evaluate*(expr: Expression): string =
   expr.evaluateImpl(expr)

type 
   RandomStringExpression* = ref RandomStringExpressionObj
   RandomStringExpressionObj = object of ExpressionObj
      fieldLength: int
      minLength: int
      maxLength: int
      capitalize: bool

   RandomDateExpression* = ref RandomDateExpressionObj
   RandomDateExpressionObj = object of ExpressionObj
      fromSeconds: float
      toSeconds: float

   RandomNameExpression = ref RandomNameExpressionObj
   RandomNameExpressionObj = object of ExpressionObj
      fieldLength: int

   LiteralValueExpression* = ref LiteralValueExpressionObj
   LiteralValueExpressionObj = object of ExpressionObj
      value: string

let
   fieldSpecPattern* = peg"""#
   Pattern <- ^ {ElementId} !.
   ElementId <- \d \d \d \d
   """

   fieldValueSpecPattern* = peg"""#
   Pattern <- ^ ElementSpec !.
   ElementSpec <-  {ElementId} '=' {ElementValue} / {ElementId}
   ElementId <- \d \d \d \d
   ElementValue <- .*
   """

   # Comma separated list of element spec
   fieldSpecsPattern* = peg"""#
   Pattern <- ^ ElementsSpec !.
   ElementsSpec <- ElementSpec ElementSpecSeparator ElementsSpec / ElementSpec
   ElementSpec <- {(!ElementSpecSeparator .)+}
   ElementSpecSeparator <- ';'
   """
   
   randomDatePattern = peg"""#
   Pattern <- ^ '{' Spc RandomDateSpec Spc '}' !.
   RandomDateSpec <- Symbol Spc '(' Spc Date Spc ',' Spc Date Spc ')'
   Symbol <- 'date'
   Date <- {\d \d \d \d \d \d \d \d}
   Spc <- \s*
   """

   vektisDatePattern* = peg"""#
   Pattern <- ^ VektisDate !.
   VektisDate <- \d \d \d \d \d \d \d \d
   """

   randomStringPattern = peg"""#
   Pattern <- ^ '{' Spc RandomStringSpec Spc '}' !.
   RandomStringSpec <- Symbol Spc '(' Spc Params Spc ')' Spc / Symbol
   Params <- Digits Spc ',' Spc Digits / Digits
   Symbol <- 'text'
   Digits <- {\d+}
   Spc <- \s*
   """

   randomCapsPattern = peg"""#
   Pattern <- ^ '{' Spc RandomStringSpec Spc '}' !.
   RandomStringSpec <- Symbol Spc '(' Spc Params Spc ')' Spc / Symbol
   Params <- Digits Spc ',' Spc Digits / Digits
   Symbol <- 'TEXT'
   Digits <- {\d+}
   Spc <- \s*
   """

   randomNamePattern = peg"""
   Pattern <-  ^'{' RandomNameSpec '}' !.
   RandomNameSpec <- 'name'
   """

var namesList: seq[string] = nil

proc readNamesList(): seq[string] =
   result = @[]
   let fullPath = joinPath(getAppDir(), cDataDir, cNamesListFile)
   for line in lines fullPath:
      result.add(line)

proc getRandomName(): string =
   debug("names list size: " % [intToStr(namesList.len)])
   if isNil(namesList):
      namesList = readNamesList()
   else: discard
   namesList[random(namesList.len)]

proc getRandomString(minlen: int, maxlen: int, capitalize: bool): string =
   let length = minlen + random(maxlen+1 - minlen)
   let source = if capitalize: cAlphaUpper else: cAlphaLower
   result = ""
   for i in 0..length-1:
      result.add(source[random(26)])


proc evaluateRSE(expr: Expression): string =
   let rse = RandomStringExpression(expr)
   getRandomString(rse.minLength, rse.maxLength, rse.capitalize)|L(rse.fieldLength)

proc evaluateRDE(expr: Expression): string =
   let rde = RandomDateExpression(expr)
   let randomSeconds = random(rde.toSeconds-rde.fromSeconds) + rde.fromSeconds
   let randomDate = fromSeconds(randomSeconds).getLocalTime()
   format(randomDate, cVektisDateFormat)

proc evaluateRNE(expr: Expression): string =
   let rne = RandomNameExpression(expr)
   let name = getRandomName()
   result = if name.len > rne.fieldLength: name.substr(rne.fieldLength) else: name|L(rne.fieldLength)

proc evaluateLVE(expr: Expression): string =
   let lve = LiteralValueExpression(expr)
   lve.value

proc newRandomNameExpression(length: int): RandomNameExpression =
   result = RandomNameExpression(fieldLength: length, isDerived: true)
   result.evaluateImpl = evaluateRNE

proc newRandomStringExpression*(flen: int, minlen: int, maxlen: int, caps: bool): RandomStringExpression =
   result = RandomStringExpression(fieldLength: flen, minLength: minlen, maxLength: maxlen, capitalize: caps, isDerived: true)
   result.evaluateImpl = evaluateRSE

proc newLiteralExpression*(literal: string, typeCode: string, length: int): LiteralValueExpression =
   var value = literal
   if isNil(value):
      if isTextType(typeCode):
         value = spaces(length)
      else:
         value = intToStr(0, length)
   let safeLength = min(len(value), length)
   result = LiteralValueExpression(value: value[0 .. <safeLength]|L(length), isDerived: false)
   result.evaluateImpl = evaluateLVE

proc newRandomDateExpression*(min: float, max: float): RandomDateExpression =
   result = RandomDateExpression(fromSeconds: min, toSeconds: max, isDerived: true)
   result.evaluateImpl = evaluateRDE

proc readExpression*(valueSpec: string, leId: string, typeCode: string, length: int): Expression =
   if isNil(valueSpec) or len(valueSpec) == 0:
      result = newLiteralExpression(nil, typeCode, length)
   elif valueSpec =~ randomDatePattern:
      if isDateType(typeCode):
         let fromSeconds = parseVektisDate(matches[0]).toTime().toSeconds()
         let toSeconds = parseVektisDate(matches[1]).toTime().toSeconds()
         result = newRandomDateExpression(fromSeconds, toSeconds)
      else:
         raise newException(ExpressionError, 
            "Cannot apply random date expression '$#' to field '$#' with Vektis type '$#'." % [valueSpec, leId, typeCode])
   elif valueSpec =~ randomNamePattern:
      if isTextType(typeCode):
         result = newRandomNameExpression(length)
      else:
         raise newException(ExpressionError, 
            "Cannot apply random name expression '$#' to field '$#' with Vektis type '$#'." % [valueSpec, leId, typeCode])
   elif valueSpec =~ randomCapsPattern:
      if isTextType(typeCode):
         var minlen, maxlen: int
         if isNil(matches[0]):
            minlen = length div 4
            maxlen = length
         else:
            minlen = parseInt(matches[0])
            maxlen = if isNil(matches[1]): minlen else: min(parseInt(matches[1]), length)
         result = newRandomStringExpression(length, minlen, maxlen, true)
      else:
         raise newException(ExpressionError, 
            "Cannot apply random string expression '$#' to field '$#' with Vektis type '$#'." % [valueSpec, leId, typeCode])
   elif valueSpec =~ randomStringPattern:
      if isTextType(typeCode):
         var minlen, maxlen: int
         if isNil(matches[0]):
            minlen = length div 4
            maxlen = length
         else:
            minlen = parseInt(matches[0])
            maxlen = if isNil(matches[1]): minlen else: min(parseInt(matches[1]), length)
         result = newRandomStringExpression(length, minlen, maxlen, false)
      else:
         raise newException(ExpressionError, 
            "Cannot apply random string expression '$#' to field '$#' with Vektis type '$#'." % [valueSpec, leId, typeCode])
   else:
      if isDateType(typeCode):
         if valueSpec =~ vektisDatePattern:
            result = newLiteralExpression(valueSpec, typeCode, length)
         else:
            raise newException(ExpressionError, 
               "Invalid date expression '$#' for field '$#' with Vektis type '$#'." % [valueSpec, leId, typeCode])
      elif isNumericType(typeCode):
         if isDigit(valueSpec):
            result = newLiteralExpression(valueSpec, typeCode, length)
         else:
            raise newException(ExpressionError, 
               "Invalid numeric expression '$#' for field '$#' with Vektis type '$#'." % [valueSpec, leId, typeCode])
      else:
         result = newLiteralExpression(valueSpec, typeCode, length)


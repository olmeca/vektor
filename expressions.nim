import pegs, strutils, sequtils, random

let
   elementSpecPattern* = peg"""#
   Pattern <- ^ ElementSpec !.
   ElementSpec <-  {ElementId} '=' {ElementValue} / {ElementId}
   ElementId <- \d \d \d \d
   ElementValue <- .*
   """

   elementSpecsPattern* = peg"""#
   Pattern <- ^ ElementsSpec !.
   ElementsSpec <- ElementSpec ElementSpecSeparator ElementsSpec / ElementSpec
   ElementSpec <- {(!ElementSpecSeparator .)+}
   ElementSpecSeparator <- ','
   """
   
   randomDatePattern* = peg"""#
   Pattern <- ^ RandomDateSpec !.
   RandomDateSpec <- '@date:' {Date} '-' {Date}
   Date <- \d \d \d \d \d \d \d \d
   """

   randomStringPattern* = peg"""#
   Pattern <- ^ RandomStringSpec !.
   RandomStringSpec <- Symbol ':' Params / Symbol
   Params <- Digits '-' Digits / Digits
   Symbol <- '@alpha'
   Digits <- {\d+}
   """



import pegs, strutils, sequtils, lists, future, logging
import "common", "doctypes", "context"

type
   QualifierOperator* = enum
      OpEquals, OpUnequal, OpGreaterThan, OpGreaterThanOrEqual, OpLessThan, OpLessThanOrEqual
   CompositionOperator* = enum
      OpNone, OpAnd, OpOr
   
   LineQualifier* = ref LineQualifierObj
   LineQualifierObj* = object of RootObj
      qualifiesImpl: proc(q: LineQualifier, context: Context): bool 
      toStringImpl: proc(q: LineQualifier): string

proc qualifies*(q: LineQualifier, context: Context): bool =
   result = q.qualifiesImpl(q, context)

proc `$`*(q:LineQualifier): string =
   result = q.toStringImpl(q)

type
   ElementaryQualifier* = ref ElementaryQualifierObj
   ElementaryQualifierObj* = object of LineQualifierObj
      key*: string
      value*: string
      operator*: QualifierOperator
   
   CompositeQualifier* = ref CompositeQualifierObj
   CompositeQualifierObj* = object of LineQualifierObj
      operator*: CompositionOperator
      qualifiers*: seq[LineQualifier]
      
let cAndOperator = "&"
let cOrOperator = "|"

let elementaryQualifierPatternSpec = """
Qualifier <- ^ Sp {Key} Sp {Operator} Sp {Value} Sp !.
Key <- \d \d \d \d
Value <- (!Operator .)+
Operator <- '=' / '!=' / '<' / '>'
Sp <- ' '*
"""

let cCompositeQualifierPatternSpec = """
Pattern <- ^ Sp Qualifier Sp !.
Qualifier <- ElementaryQualifier / Open Composite Close 
Composite <- Sp {Qualifier} Sp {Op} Sp {Qualifier} Sp / ''
ElementaryQualifier <- Key Sp Comparator Sp Value
Key <- \d \d \d \d
Value <- Number / Text
Comparator <- '=' / '!=' / '<' / '>'
Number <- \d+
Text <- '"' (!'"' .)* '"'
Open <- '('
Close <- ')'
Op <- '&' / '|'
Sp <- ' '*
"""

let elementaryQualifierPattern = peg(elementaryQualifierPatternSpec)
let compositeQualifierPattern = peg(cCompositeQualifierPatternSpec)

proc printElementaryQualifier(lq: LineQualifier): string =
   if isNil(lq):
      result = "<nil>"
   else:
      let kvq = ElementaryQualifier(lq)
      result = "['$#' $# '$#']" % [kvq.key, $(kvq.operator), kvq.value]

proc printCompositeQualifier(lq: LineQualifier): string =
   if isNil(lq):
      result = "<nil>"
   else:
      let cq = CompositeQualifier(lq)
      result = "( $# $# $# )" % [$(cq.qualifiers[0]), $cq.operator, $(cq.qualifiers[1])]

proc kvqQualify(lq: LineQualifier, context: Context): bool =
   var kvq = ElementaryQualifier(lq)
   let leValue = context.getElementValueString(kvq.key)
   case kvq.operator
   of OpEquals:
      result = leValue == kvq.value
   of OpUnequal:
      result = leValue != kvq.value
   of OpGreaterThan:
      result = leValue > kvq.value
   of OpLessThan:
      result = leValue < kvq.value
   else:
      raise newException(ValueError, "Operator not supported")

proc andQualify(cq: CompositeQualifier, context: Context): bool =
   all(cq.qualifiers, proc(lq: LineQualifier): bool = lq.qualifies(context))

proc orQualify(cq: CompositeQualifier, context: Context): bool =
   any(cq.qualifiers, proc(lq: LineQualifier): bool = lq.qualifies(context))

proc compositeQualify(lq: LineQualifier, context: Context): bool =
   let cq = CompositeQualifier(lq)
   if cq.operator == OpAnd:
      result = andQualify(cq, context)
   else:
      result = orQualify(cq, context)

proc operatorFromString(source: string): QualifierOperator =
   case source
   of "=":
      result = OpEquals
   of "!=":
      result = OpUnequal
   of ">":
      result = OpGreaterThan
   of "<":
      result = OpLessThan
   else:
      raise newException(ValueError, "Unknown operator: '$#'" % [source])

proc compositionOperatorFromString(source: string): CompositionOperator =
   case source
   of "&":
      result = OpAnd
   of "|":
      result = OpOr
   else:
      raise newException(ValueError, "Unknown composition operator: '$#'" % [source])

proc newElementaryQualifier*(key: string, op: QualifierOperator, value: string): ElementaryQualifier =
   new(result)
   result.key = key
   result.operator = op
   result.value = value
   result.qualifiesImpl = kvqQualify
   result.toStringImpl = printElementaryQualifier
   debug("newElementaryQualifier -> $#" % [$result])

proc newCompositeQualifier*(): CompositeQualifier =
   new(result)
   result.qualifiesImpl = compositeQualify
   result.operator = OpNone
   result.qualifiers = @[]
   result.toStringImpl = printCompositeQualifier

proc newCompositeQualifier*(oper: CompositionOperator, qualifiers: seq[LineQualifier]): CompositeQualifier =
   new(result)
   result.qualifiesImpl = compositeQualify
   result.qualifiers = qualifiers
   result.operator = oper
   result.toStringImpl = printCompositeQualifier
   debug("newCompositeQualifier: $#" % [$result])

proc backtrack(cqStack: SinglyLinkedNode[CompositeQualifier]): SinglyLinkedNode[CompositeQualifier] =
      result = cqStack
      while result != nil and result.value.operator != OpNone and result.value.qualifiers.len() > 1:
         debug("backtracking from $#" % $result.value)
         result = result.next

proc `&`(cqStack: SinglyLinkedNode[CompositeQualifier], qualSpec: string): SinglyLinkedNode[CompositeQualifier] =
   debug ("Folding: '$#'" % qualSpec)
   if qualSpec == cAndOperator or qualSpec == cOrOperator:
      # If reading a composite operator and current cq already has an operator set then go up the tree
      # you hit a node that is not completely read yet
      result = cqStack
      result.value.operator = compositionOperatorFromString(qualSpec)
   elif qualSpec =~ elementaryQualifierPattern:
      let kvq = newElementaryQualifier(matches[0], operatorFromString(matches[1]), matches[2])
      assert (cqStack.value.qualifiers.len() < 2)
      cqStack.value.qualifiers.add(kvq)
      if cqStack.value.qualifiers.len() == 2:
         debug("Done reading qualifier: $#" % [$cqStack.value])
         result = backtrack(cqStack)
      else:
         result = cqStack
   elif qualSpec =~ compositeQualifierPattern:
      debug("Creating new composite for: $#" % qualSpec)
      let newComp = newCompositeQualifier()
      cqStack.value.qualifiers.add(newComp)
      result = newSinglyLinkedNode(newComp)
      result.next = cqStack
   else:
      raise newException(ValueError, "Unexpected value while parsing composite expression: '$#'" % qualSpec)


proc parseQualifier*(docType: DocumentType, qualString: string): LineQualifier =
   debug("parseQualifier: '$#'" % qualString)
   if qualString =~ elementaryQualifierPattern:
      debug("parseQualifier: ElementaryQualifier '$#' '$#' '$#'" % matches)
      result = newElementaryQualifier(matches[0], operatorFromString(matches[1]), matches[2])
   elif qualString =~ compositeQualifierPattern:
      debug("parseQualifier found composite: [$#]" % [join(lc[m | (m <- matches, not isNil(m)), string], ", ")])
      # cleanup matches to only contain kvq specs and composition operator specs
      let prunedMatches = matches.filter(proc(m: string): bool = not isNil(m))
      debug("parseQualifier prunedMatches: [$#]" % [join(lc[m | (m <- prunedMatches), string], ", ")])
      let compQual = newCompositeQualifier()
      let cqStack = newSinglyLinkedNode(compQual)
      discard foldl(prunedMatches, a & b, cqStack)
      debug("parseQualifier: composite: $#" % $compQual)
      result = LineQualifier(compQual)
   else:
      let error = "Could not parse qualifier '$#'" % [qualString]
      debug("parseQualifier: $#" % error)
      raise newException(ValueError, error)





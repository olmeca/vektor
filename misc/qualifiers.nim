import pegs, strutils, sequtils, lists, sugar, logging, times, vektisvalues, expressions, expressionsreader
import "common", doctype, "context"

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
      leType*: LineElementType
      operator*: QualifierOperator
      refValue*: Expression


   CompositeQualifier* = ref CompositeQualifierObj
   CompositeQualifierObj* = object of LineQualifierObj
      operator*: CompositionOperator
      qualifiers*: seq[LineQualifier]

let cAndOperator = "&"
let cOrOperator = "|"

let naturalLiteralValuePattern = r"\d+"
let textLiteralValuePattern = """#
Quote (!Quote .)* Quote
Quote <- '"'
"""
let dateLiteralValuePattern = r"DateValue <- \d \d \d \d '-' \d \d '-' \d \d"

let elementaryQualifierPatternSpec = """
ElementaryQualifier <- Sp {Key} Sp {Comparator} Sp {Value} Sp
Key <- \d \d \d \d
Value <- '"' {TextValue} '"' / {DateValue} / {SignedAmountValue} / {UnsignedAmountValue} / {NaturalValue}
TextValue <- (!'"' .)*
DateValue <- ('19' / '20') \d \d '-' \d \d '-' \d \d
SignedAmountValue <- '-'? UnsignedAmountValue
UnsignedAmountValue <- \d+ '.' \d \d
NaturalValue <- \d+
Comparator <- '=' / '!=' / '<' / '>'
Sp <- \s*
"""

let cCompositeQualifierPatternSpec = """
Chain <- Sp {Item} Link {Item}
Item <- Container / Elem
Container <- Open Sp Chain Sp Close
Elem <- (!NonElemChar .)+ Sp
NonElemChar <- AndChar / OrChar / OpenChar / CloseChar
Open <- OpenChar Sp
Close <- CloseChar Sp
Link <- {LinkChar} Sp
LinkChar <- AndChar / OrChar
AndChar <- '&'
OrChar <- '|'
OpenChar <- '('
CloseChar <- ')'
Sp <- ' '*"""


let cFullStringMatcherTemplate = """^ Pattern !."""

proc fullStringMatcher(patternSpec: string, mainRuleName: string): Peg =
    peg("Peg <- ^ $# !.$#" % [mainRuleName, patternSpec])

let elementaryQualifierPattern = fullStringMatcher(elementaryQualifierPatternSpec, "ElementaryQualifier")
let compositeQualifierPattern = fullStringMatcher(cCompositeQualifierPatternSpec, "Chain")


proc printElementaryQualifier(lq: LineQualifier): string =
   if isNil(lq):
      result = "<nil>"
   else:
      let kvq = ElementaryQualifier(lq)
      result = "['$#' $# '$#']" % [kvq.leType.lineElementId, $(kvq.operator), kvq.refValue.asString()]


proc printCompositeQualifier(lq: LineQualifier): string =
   if isNil(lq):
      result = "<nil>"
   else:
      let cq = CompositeQualifier(lq)
      result = "( $# $# $# )" % [$(cq.qualifiers[0]), $cq.operator, $(cq.qualifiers[1])]


proc applyOperator(operator: QualifierOperator, value, refValue: VektisValue): bool =
    case operator
    of OpEquals:
        value == refValue
    of OpUnequal:
        value != refValue
    of OpLessThan:
        value < refValue
    of OpGreaterThan:
        value > refValue
    of OpLessThanOrEqual:
        value <= refValue
    of OpGreaterThanOrEqual:
        value >= refValue


proc qualifyKeyValue(lq: LineQualifier, context: Context): bool =
    let kvq = ElementaryQualifier(lq)
    let refValue = kvq.refValue.evaluate(context)
    let value = getElementValue(kvq.leType, context)
    applyOperator(kvq.operator, value, refValue)


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


proc newElementaryQualifier*(leType: LineElementType, op: QualifierOperator, value: Expression): ElementaryQualifier =
   new(result)
   result.leType = leType
   result.operator = op
   result.refValue = value
   result.qualifiesImpl = qualifyKeyValue
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


proc newAndQualifier(qualifiers: seq[LineQualifier]): CompositeQualifier =
    new(result)
    result.operator = OpAnd
    result.qualifiers = qualifiers


process(tokens: OpenArray[string], index: int, var qual: CompositeQualifier) =
    if tokens[i] =~ elementaryQualifierPattern:


proc parseQualifier*(docType: DocumentType, qualString: string, expressionReader: GeneralExpressionReader): LineQualifier =
   debug("qualifiers.parseQualifier: '$#'" % qualString)
   if qualString =~ elementaryQualifierPattern:
      debug("qualifiers.parseQualifier: ElementaryQualifier '$#' '$#' '$#'" % matches)
      let leType = docType.getLineElementType(matches[0])
      let operator = operatorFromString(matches[1])
      let refValueExpression = expressionReader.readExpression(matches[2], leType.valueType)
      result = newElementaryQualifier(leType, operator, refValueExpression)
   elif qualString =~ compositeQualifierPattern:
      debug("qualifiers.parseQualifier found composite: [$#]" % [join(lc[m | (m <- matches, m != NIL), string], ", ")])
      let qualifiers = lc[LineQualifier(parseQualifier(docType, item, expressionReader)) | (item <- matches, item != NIL), LineQualifier]
      result = LineQualifier(newAndQualifier(qualifiers))
   else:
      let error = "Could not match qualifier '$#'" % [qualString]
      debug("qualifiers.parseQualifier: $#" % error)
      raise newException(ValueError, error)


proc conditionIsMet*(context: Context, qualifier: LineQualifier): bool =
   if isNil(qualifier):
      result = true
   else:
      try:
         result = qualifier.qualifies(context)
      except ContextWithLineIdNotFoundError:
         debug("qualifiers.parseQualifier: condition Is Met: '$#'" % getCurrentExceptionMsg())
         result = false





import pegs, strutils, sequtils, lists, sugar, logging, times
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
   StringQualifier* = ref object of ElementaryQualifier
      refValue*: string
   NumberQualifier* = ref object of ElementaryQualifier
      refValue*: int
   DateQualifier* = ref object of ElementaryQualifier
      refValue*: DateTime


   CompositeQualifier* = ref CompositeQualifierObj
   CompositeQualifierObj* = object of LineQualifierObj
      operator*: CompositionOperator
      qualifiers*: seq[LineQualifier]

let cAndOperator = "&"
let cOrOperator = "|"

let elementaryQualifierPatternSpec = """
Qualifier <- ^ Sp {Key} Sp {Operator} Sp Value Sp !.
Key <- \d \d \d \d
Value <- '"' {TextValue} '"' / {DateValue} / {NumericalValue}
TextValue <- (!'"' .)*
DateValue <- ('19' / '20') \d \d \d \d \d \d
NumericalValue <- \d+
Operator <- '=' / '!=' / '<' / '>'
Sp <- \s*
"""

let cCompositeQualifierPatternSpec = """
Pattern <- ^ Sp Qualifier Sp !.
Qualifier <- Open ChainedQualifier Close
ChainedQualifier <- Sp {ElementaryQualifier} Sp Link Sp ChainedQualifier Sp / {ElementaryQualifier}
ElementaryQualifier <- Key Sp Comparator Sp Value
Key <- \d \d \d \d
Value <- Number / Text
Comparator <- '=' / '!=' / '<' / '>'
Number <- \d+
Text <- '"' (!'"' .)* '"'
Open <- '('
Close <- ')'
Link <- '&'
Sp <- \s*
"""

let elementaryQualifierPattern = peg(elementaryQualifierPatternSpec)
let compositeQualifierPattern = peg(cCompositeQualifierPatternSpec)

proc printStringQualifier(lq: LineQualifier): string =
   if isNil(lq):
      result = "<nil>"
   else:
      let kvq = StringQualifier(lq)
      result = "['$#' $# '$#']" % [kvq.leType.lineElementId, $(kvq.operator), kvq.refValue]

proc printNumberQualifier(lq: LineQualifier): string =
   let kvq = NumberQualifier(lq)
   "['$#' $# '$#']" % [kvq.leType.lineElementId, $(kvq.operator), intToStr(kvq.refValue)]

proc printDateQualifier(lq: LineQualifier): string =
   let kvq = DateQualifier(lq)
   "['$#' $# '$#']" % [kvq.leType.lineElementId, $(kvq.operator), kvq.refValue.format(cVektisDateFormat)]


proc printCompositeQualifier(lq: LineQualifier): string =
   if isNil(lq):
      result = "<nil>"
   else:
      let cq = CompositeQualifier(lq)
      result = "( $# $# $# )" % [$(cq.qualifiers[0]), $cq.operator, $(cq.qualifiers[1])]

proc kvqQualifyString(lq: LineQualifier, context: Context): bool =
    let kvq = StringQualifier(lq)
    let value = context.getElementValueString(kvq.leType)
    debug("kvq: comparing '$#' to ref '$#'" % [value, kvq.refValue])
    case kvq.operator
    of OpEquals:
        result = value == kvq.refValue
    of OpUnequal:
        result = value != kvq.refValue
    of OpLessThan:
        result = value < kvq.refValue
    of OpGreaterThan:
        result = value > kvq.refValue
    else:
        raise newException(ValueError, "Operator not supported in $#" % [$(kvq)] )

proc kvqQualifyNumber(lq: LineQualifier, context: Context): bool =
    let kvq = NumberQualifier(lq)
    let valueString = context.getElementValueString(kvq.leType)
    let value = parseInt(valueString)
    case kvq.operator
    of OpEquals:
        result = value == kvq.refValue
    of OpUnequal:
        result = value != kvq.refValue
    of OpLessThan:
        result = value < kvq.refValue
    of OpGreaterThan:
        result = value > kvq.refValue
    else:
        raise newException(ValueError, "Operator not supported in $#" % [$(kvq)] )

proc kvqQualifyDate(lq: LineQualifier, context: Context): bool =
    let kvq = DateQualifier(lq)
    let valueString = context.getElementValueString(kvq.leType)
    let valueTime = parseVektisDate(valueString).toTime()
    let refTime = kvq.refValue.toTime()
    case kvq.operator
    of OpEquals:
        result = valueTime == refTime
    of OpUnequal:
        result = valueTime != refTime
    of OpLessThan:
        result = valueTime < refTime
    of OpGreaterThan:
        result = valueTime > refTime
    else:
        raise newException(ValueError, "Operator not supported in $#" % [$(kvq)] )


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

proc newStringQualifier*(leType: LineElementType, op: QualifierOperator, value: string): StringQualifier =
   new(result)
   result.leType = leType
   result.operator = op
   result.refValue = value
   result.qualifiesImpl = kvqQualifyString
   result.toStringImpl = printStringQualifier
   debug("new String Qualifier -> $#" % [$result])

proc newNumberQualifier*(leType: LineElementType, op: QualifierOperator, value: int): NumberQualifier =
   new(result)
   result.leType = leType
   result.operator = op
   result.refValue = value
   result.qualifiesImpl = kvqQualifyNumber
   result.toStringImpl = printNumberQualifier
   debug("new Number Qualifier -> $#" % [$result])

proc newDateQualifier*(leType: LineElementType, op: QualifierOperator, value: DateTime): DateQualifier =
   new(result)
   result.leType = leType
   result.operator = op
   result.refValue = value
   result.qualifiesImpl = kvqQualifyDate
   result.toStringImpl = printDateQualifier
   debug("new Date Qualifier -> $#" % [$result])

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

proc newElementaryQualifier(leType: LineElementType, operator: QualifierOperator, refValueString: string): LineQualifier =
    if leType.isDate():
        let refValue = parse(refValueString, cVektisDateFormat)
        result = newDateQualifier(leType, operator, refValue)
    elif leType.isNumeric():
        let refValue = parseInt(refValueString)
        result = newNumberQualifier(leType, operator, refValue)
    else:
        result = newStringQualifier(leType, operator, refValueString)


proc parseQualifier*(docType: DocumentType, qualString: string): LineQualifier =
   debug("parseQualifier: '$#'" % qualString)
   if qualString =~ elementaryQualifierPattern:
      debug("parseQualifier: ElementaryQualifier '$#' '$#' '$#'" % matches)
      let leType = docType.getLineElementType(matches[0])
      let operator = operatorFromString(matches[1])
      let refValueString = matches[2]
      result = newElementaryQualifier(leType, operator, refValueString)
   elif qualString =~ compositeQualifierPattern:
      debug("parseQualifier found composite: [$#]" % [foldMatches(matches)])
      let qualifiers = matches.filter(notEmpty).map(item => LineQualifier(parseQualifier(docType, item)))
      result = LineQualifier(newAndQualifier(qualifiers))
   else:
      let error = "Could not parse qualifier '$#'" % [qualString]
      debug("parseQualifier: $#" % error)
      raise newException(ValueError, error)

proc conditionIsMet*(context: Context, qualifier: LineQualifier): bool =
   if isNil(qualifier):
      result = true
   else:
      try:
         result = qualifier.qualifies(context)
      except ContextWithLineIdNotFoundError:
         debug("condition Is Met: '$#'" % getCurrentExceptionMsg())
         result = false





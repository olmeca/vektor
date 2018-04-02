import pegs, strutils, future, logging
import "common", "doctypes", "context"

type
   QualifierOperator = enum
      OpEquals, OpUnequal, OpGreaterThan, OpGreaterThanOrEqual, OpLessThan, OpLessThanOrEqual
   
   LineQualifier* = ref LineQualifierObj
   LineQualifierObj* = object of RootObj
      qualifiesImpl: proc(q: LineQualifier, context: Context): bool 

proc qualifies*(q: LineQualifier, context: Context): bool =
   result = q.qualifiesImpl(q, context)

type
   KeyValueQualifier* = ref KeyValueQualifierObj
   KeyValueQualifierObj* = object of LineQualifierObj
      key*: string
      value*: string
      operator*: QualifierOperator
   
   AndQualifier* = ref AndQualifierObj
   AndQualifierObj* = object of LineQualifierObj
      qualifiers: seq[LineQualifier]

   OrQualifier* = ref OrQualifierObj
   OrQualifierObj* = object of LineQualifierObj
      qualifiers: seq[LineQualifier]

let cAndOperator = "&"
let cOrOperator = "|"

let keyValueQualifierPatternSpec = """
Qualifier <- ^ {Key} {Operator} {Value} !.
Key <- \d \d \d \d
Value <- (!Operator .)+
Operator <- '=' / '!=' / '<' / '>'
"""

let cCompositeQualifierPatternSpec = """
Pattern <- ^ Composite !.
Composite <- Parenthesized {Op} Parenthesized / ''
Parenthesized <- Open {Sub} Close
Sub <- (!Paren .)+ &Close / Composite
Paren <- Open / Close
Open <- '('
Close <- ')'
Op <- '&' / '|'
"""

let keyValueQualifierPattern = peg(keyValueQualifierPatternSpec)
let compositeQualifierPattern = peg(cCompositeQualifierPatternSpec)


proc kvqQualify(lq: LineQualifier, context: Context): bool =
   var kvq = KeyValueQualifier(lq)
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

proc andQualify(lq: LineQualifier, context: Context): bool =
   var andQual = AndQualifier(lq)
   for qualifier in andQual.qualifiers:
      if not qualifier.qualifies(context):
         return false
   result = true

proc orQualify(lq: LineQualifier, context: Context): bool =
   var orQual = OrQualifier(lq)
   for qualifier in orQual.qualifiers:
      if qualifier.qualifies(context):
         return true
   result = false


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

proc newKeyValueQualifier*(key: string, op: QualifierOperator, value: string): KeyValueQualifier =
   new(result)
   result.key = key
   result.operator = op
   result.value = value
   result.qualifiesImpl = kvqQualify

proc newAndQualifier*(qualifiers: seq[LineQualifier]): AndQualifier =
   new(result)
   result.qualifiesImpl = andQualify
   result.qualifiers = qualifiers

proc newOrQualifier*(qualifiers: seq[LineQualifier]): OrQualifier =
   new(result)
   result.qualifiesImpl = orQualify
   result.qualifiers = qualifiers

proc newCompositeQualifier(operator: string, leftQual: LineQualifier, rightQual: LineQualifier): LineQualifier =
   let qualifiers = @[leftQual, rightQual]
   result = LineQualifier(if operator == cAndOperator: newAndQualifier(qualifiers) else: newOrQualifier(qualifiers))

proc parseQualifier*(docType: DocumentType, qualString: string): LineQualifier =
   if qualString =~ compositeQualifierPattern:
      debug("parseQualifier found composite: [$#]" % [join(lc[m | (m <- matches, not isNil(m)), string], ", ")])
      if matches.len > 2:
         # For now we only support parsing a binary And/Or expression, with a left and a right operand.
         # Both operands can themselves be And/Or expressions
         #let qualifiers = lc[parseQualifier(docType, item) | (item <- matches, not isNil(item)), LineQualifier]
         let leftQual = parseQualifier(docType, matches[0])
         let rightQual = parseQualifier(docType, matches[2])
         let operation = matches[1]
         result = newCompositeQualifier(operation, leftQual, rightQual)
   elif qualString =~ keyValueQualifierPattern:
      debug("parseQualifier: '$#' '$#' '$#'" % matches)
      let oper = operatorFromString(matches[1])
      let key = matches[0]
      let value = matches[2]
      result = LineQualifier(newKeyVAlueQualifier(key, oper, value))
   else:
      raise newException(ValueError, "Could not parse qualifier '$#'" % [qualString])





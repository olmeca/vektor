import pegs, strutils
import "doctypes"

type
   QualifierOperator = enum
      OpEquals, OpUnequal, OpGreaterThan, OpGreaterThanOrEqual, OpLessThan, OpLessThanOrEqual
   
   LineQualifier* = ref LineQualifierObj
   LineQualifierObj* = object of RootObj
      qualifiesImpl: proc(q: LineQualifier, line: string): bool 
      lineId*: string

proc qualifies*(q: LineQualifier, line: string): bool =
   result = q.qualifiesImpl(q, line)

type
   KeyValueQualifier* = ref KeyValueQualifierObj
   KeyValueQualifierObj* = object of LineQualifierObj
      docType*: DocumentType
      key*: string
      value*: string
      operator*: QualifierOperator

let keyValueQualifierPattern = peg"""#
Qualifier <- ^ {Key} {Operator} {Value} !.
Key <- \d \d \d \d
Value <- (!Operator .)+
Operator <- '=' / '!=' / '<' / '>'
"""

let andQualifierPattern = peg"""#
Pattern <- ^ AndQualifier !.
AndQualifier <- Qualifier '&' AndQualifier / Qualifier
Qualifier <- {(!'&' .)+}
"""

proc kvqQualify(lq: LineQualifier, line: string): bool =
   var kvq = KeyValueQualifier(lq)
   let leValue = getElementValueString(kvq.docType, line, kvq.key)
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

proc newKeyValueQualifier*(docType: DocumentType, key: string, op: QualifierOperator, value: string,): KeyValueQualifier =
   new(result)
   result.docType = docType
   result.lineId = key[0..1]
   result.key = key
   result.operator = op
   result.value = value
   result.qualifiesImpl = kvqQualify

proc parseQualifier*(docType: DocumentType, qualString: string): LineQualifier =
   if qualString =~ keyValueQualifierPattern:
      let oper = operatorFromString(matches[1])
      let key = matches[0]
      let value = matches[2]
      # echo "parseQualifier: '$#' '$#' '$#'" % matches
      result = LineQualifier(newKeyVAlueQualifier(docType, key, oper, value))
   else:
      raise newException(ValueError, "Could not parse qualifier '$#'" % [qualString])





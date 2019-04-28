import tables, strutils, sequtils, sugar, logging
import "common", doctype, "formatting"

type
   Total* = ref object
      leType*: LineElementType
      value*: int

   Accumulator* = ref object
      docType: DocumentType
      totals*: seq[Total]
      empty*: bool

let
   cAnyId = "00"

proc toString*(str: seq[char]): string =
  result = newStringOfCap(len(str))
  for ch in str:
    add(result, ch)

proc parseValue*(total: Total): VektisValue =
    case total.leType.valueType
    of NaturalValueType:
        VektisValue(kind: NaturalValueType, naturalValue: total.value)
    of UnsignedAmountValueType:
        VektisValue(kind: UnsignedAmountValueType, amountValue: total.value)
    of SignedAmountValueType:
        VektisValue(kind: SignedAmountValueType, signedAmountValue: total.value)
    else:
        raise newException(ValueError, "Invalid value type for Total value.")

proc asString(total: Total): string =
   if total.leType.isAmountType():
        let valString = formatEng(float32(total.value) / 100.0, 2, trim=false)|R(10)
        "$#: $#" % [total.leType.lineElementId, valString]
   else:
        "$#: $#" % [total.leType.lineElementId, total.value|R(5)]

proc newAccumulator*(dType:DocumentType): Accumulator =
   let bottomLineType = dType.getLineTypeForLineId(cBottomLineId)
   let totals = lc[Total(leType: t, value: 0) | (t <- bottomLineType.lineElementTypes, t.countable != ""), Total]
   result = Accumulator(docType: dType, totals: totals, empty: true)

proc increment(total: var Total, extra: int) =
   total.value = total.value + extra

proc getSourceLineElementType*(acc: Accumulator, total: Total): LineElementType =
    acc.docType.getLineElementType(total.leType.countable)

proc getIntegerValue*(docType: DocumentType, leType: LineElementType, line: string): int =
    if leType.isAmountType():
        getElementValueSigned(docType, leType, line)
    else:
        line.getElementValueInt(leType)

proc accumulate*(acc: Accumulator, line: string) =
   debug("accumulator.accumulate: " & line[0..13])
   for total in acc.totals.mitems():
      let sourceLeId = total.leType.countable
      let sourceLineId = getLineId(sourceLeId)
      debug("accumulator.accumulate: sourceLeId: $#" % sourceLeId)
      # source id is not specific then just count the line (if it is a content line)
      if sourceLineId == cAnyId and line.isContentLine():
         debug("accumulator.accumulate: counting content line")
         total.increment(1)
         acc.empty = false
      # if source id is specific and matches this line
      elif sourceLineId == getLineId(line):
         # if line elt not specific then count line
         if getLineElementSubId(sourceLeId) == cAnyId:
            debug("accumulator.accumulate: counting line of type $#" % sourceLineId)
            total.increment(1)
            acc.empty = false
         else:
            let leType = acc.docType.getLineElementType(sourceLeId)
            let elemValue = getIntegerValue(acc.docType, leType, line)
            total.increment(elemValue)
            debug("accumulator.accumulate: inc $# -> $#" % [intToStr(elemValue), intToStr(total.value)])
            acc.empty = false
   debug("accumulator:accumulate done.")


proc isEmpty*(acc: Accumulator): bool =
   acc.empty

#proc addLine*(acc: Accumulator, buf: seq[char]) =
#   addLine(acc, buf.toString())

proc writeNumber(value: int, buf: var openArray[char], start: int, length: int) =
   assert(len(buf) >= start + length)
   let newValue = intToStr(value, length)
   let newValueSeq = toSeq(newValue.items)
   # Nim range is inclusive
   for i in 0..(length-1):
      # Nim arrays are zero-based, Vektis is one-based
      buf[start+i] = newValueSeq[i]
   

proc writeTotal(total: Total, buf: var openArray[char]) =
   var newValue: string
   let leType = total.leType

   case leType.valueType
   of SignedAmountValueType:
        let signum = if total.value < 0: cSignumCredit else: cSignumDebit
        newValue = intToStr(abs(total.value), leType.length-1) & signum
   else:
        newValue = intToStr(total.value, leType.length)
   debug("accumulator.writeTotal: new value: '$#'" % newValue)

   let newValueSeq = toSeq(newValue.items)
   for i in 0..len(newValueSeq) - 1:
        buf[leType.startPosition - 1 + i] = newValueSeq[i]


proc write*(acc: Accumulator, buf: var seq[char]) =
   for total in acc.totals:
      writeTotal(total, buf)

proc asString*(acc: Accumulator): string =
   let items = lc[t.asString() | (t <- acc.totals), string]
   result = items.join("| ")


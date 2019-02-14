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

proc asString(total: Total): string =
   let width = if total.leType.isAmountType(): 8 else: 5
   "$#: $#" % [total.leType.lineElementId, total.value|R(width)]

proc newAccumulator*(dType:DocumentType): Accumulator =
   let bottomline = dType.getLineTypeForLineId(cBottomLineId)
   let totals = lc[Total(leType: t, value: 0) | (t <- bottomLine.lineElementTypes, t.countable != ""), Total]
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
      let leId = total.leType.countable
      # match any line type, except bottom line
      if getLineId(leId) == cAnyId and line.isContentLine():
         total.increment(1)
         acc.empty = false
      # match line ID
      elif getLineId(leId) == getLineId(line):
         # match the whole line
         if getLineElementSubId(leId) == cAnyId:
            total.increment(1)
            acc.empty = false
         else:
            let leType = acc.docType.getLineElementType(leId)
            let elemValue = getIntegerValue(acc.docType, leType, line)
            total.increment(elemValue)
            #debug("inc $# -> $#" % [intToStr(elemValue), intToStr(total.value)])
            acc.empty = false

proc isEmpty*(acc: Accumulator): bool =
   acc.empty

#proc addLine*(acc: Accumulator, buf: seq[char]) =
#   addLine(acc, buf.toString())

proc writeNumber(value: int, buf: var openArray[char], start: int, length: int) =
   assert(len(buf) >= start +  length)
   let newValue = intToStr(value, length)
   let newValueSeq = toSeq(newValue.items)
   # Nim range is inclusive
   for i in 0..(length-1):
      # Nim arrays are zero-based, Vektis is one-based
      buf[start+i] = newValueSeq[i]
   

proc write*(acc: Accumulator, buf: var seq[char]) =
   for total in acc.totals:
      writeNumber(total.value, buf, total.leType.startPosition-1, total.leType.length)

proc asString*(acc: Accumulator): string =
   let items = lc[t.asString() | (t <- acc.totals), string]
   result = items.join("| ")


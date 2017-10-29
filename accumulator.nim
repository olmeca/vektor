import tables, strutils, sequtils, future, logging
import "common", "doctypes"

type
   Total* = ref object
      leType: LineElementType
      value: int
   Accumulator* = ref object
      docType: DocumentType
      totals: seq[Total]

let
   gAnyId = "00"

proc toString(str: seq[char]): string =
  result = newStringOfCap(len(str))
  for ch in str:
    add(result, ch)

proc asString(total: Total): string =
   "$# = $#" % [total.leType.lineElementId, intToStr(total.value)]

proc newAccumulator*(dType:DocumentType): Accumulator =
   let bottomline = dType.getLineTypeForLineId(cBottomLineId)
   let totals = lc[Total(leType: t, value: 0) | (t <- bottomLine.lineElementTypes, not isNil(t.countable)), Total]
   result = Accumulator(docType: dType, totals: totals)

proc increment(total: var Total, extra: int) =
   total.value = total.value + extra

proc addLine*(acc: Accumulator, line: string) =
   # debug("addLine: " & line[0..13])
   for total in acc.totals.mitems():
      let leId = total.leType.countable
      # match any line type, except bottom line
      if leId.startsWith(gAnyId) and not line.startsWith(cBottomLineId):
         total.increment(1)
      # match line ID
      elif leId[0..1] == line[0..1]:
         # match the whole line
         if leId[2..3] == gAnyId:
            total.increment(1)
         else:
            let leType = acc.docType.getLineElementType(leId)
            let elemValue = line.getElementValueInt(leType)
            total.increment(elemValue)

proc addLine*(acc: Accumulator, buf: seq[char]) =
   addLine(acc, buf.toString())

proc writeNumber(value: int, buf: var openArray[char], start: int, length: int) =
   assert(len(buf) >= start +  length)
   let newValue = intToStr(value, length)
   let newValueSeq = toSeq(newValue.items)
   # Nim range is inclusive
   for i in 0..(length-1):
      # Nim arrays are zero-based, Vektis is one-based
      buf[start+i-1] = newValueSeq[i]
   

proc write*(acc: Accumulator, buf: var seq[char]) =
   for total in acc.totals:
      writeNumber(total.value, buf, total.leType.startPosition, total.leType.length)

proc asString*(acc: Accumulator): string =
   let items = lc["$# = $#" % [t.leType.lineElementId, intToStr(t.value)] | (t <- acc.totals), string]
   result = items.join(", ")
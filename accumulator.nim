import tables, strutils, future, logging
import "common", "doctypes"

type
   Accumulator* = ref object
      docType: DocumentType
      counters: TableRef[string, int]

let
   gAnyId = "00"

proc newAccumulator*(dType:DocumentType): Accumulator =
   let cnt = newTable[string, int]()
   let bottomline = dType.getLineTypeForLineId(cBottomLineId)
   for leType in bottomline.lineElementTypes:
      if not isNil(leType.countable):
         cnt.add(leType.countable, 0)
      else: discard
   debug("newAccumulator: created with $# field accumulators." % [intToStr(cnt.len)])
   result = Accumulator(docType: dType, counters: cnt)

proc addLine*(acc: Accumulator, line: string) =
   for leId, total in acc.counters.mpairs():
      # match any line type, except bottom line
      if leId.startsWith(gAnyId) and not line.startsWith(cBottomLineId):
         total = total + 1
      # match line ID
      elif leId[0..1] == line[0..1]:
         # match the whole line
         if leId[2..3] == gAnyId:
            total = total + 1
         else:
            let leType = acc.docType.getLineElementType(leId)
            let elemValue = line.getElementValueInt(leType)
            total = total + elemValue

proc asString*(acc: Accumulator): string =
   let items = lc["$# = $#" % [item[0], intToStr(item[1])] | (item <- acc.counters.pairs()), string]
   result = items.join(", ")
import tables, json, os, ospaths, logging, strutils, sequtils, sugar, times, pegs, streams
import formatting, common


proc serializeSignedAmount(amount: int, length: int): string =
    let signum = if amount < 0: "C" else: "D"
    result = intToStr(abs(amount), length - 1) & signum


proc serialize*(value: VektisValue, length: int): string =
   case value.kind:
   of StringValueType:
       let normalized = value.stringValue
       if normalized.len < int(length):
        result = normalized|L(length)
       else:
        result = normalized[0..length-1]
   of NaturalValueType:
        result = intToStr(int(value.naturalValue - 0), length)
   of UnsignedAmountValueType:
        result = intToStr(abs(value.amountValue), length)
   of SignedAmountValueType:
        result = serializeSignedAmount(value.signedAmountValue, length)
   of DateValueType:
        if isNil(value.dateValue):
            result = cVektisEmptyDate
        else:
            result = format(value.dateValue[], cVektisDateFormat)
   of EmptyValueType:
        result = ""


proc serialize(element: LineElement): string =
    serialize(element.value, element.leType.length)

proc serialize*(line: Line, stream: Stream) =
    # Rumor has it OrderedTable is not ordered
    for leType in line.lineType.lineElementTypes:
        stream.write(serialize(line.elements[leType.lineElementId]))

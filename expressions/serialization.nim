import tables, json, os, ospaths, logging, strutils, sequtils, future, times, pegs, streams
import formatting, common


proc serializeSignedAmount(amount: int, length: int): string =
    let signum = if amount < 0: "C" else: "D"
    result = intToStr(abs(amount), length - 1) & signum


proc serialize*(value: VektisValue, length: int): string =
   case value.kind:
   of StringValueType:
       let normalized = if isNil(value.stringValue): "" else: value.stringValue
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
        result = nil


proc serialize*(line: Line, stream: Stream) =
    for leType in line.lineType.lineElementTypes:
        stream.write(serialize(line.values[leType.lineElementId], leType.length))


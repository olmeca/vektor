import tables, json, os, ospaths, logging, strutils, sequtils, sugar, times, pegs, streams
import formatting, common


proc serializeSignedAmount(value: int, length: int, format: OutputFormat): string =
    case format
    of ReadableFormat:
        formatEng(float32(value) / 100.0, 2, trim=false)|R(length)
    of VektisFormat:
        let signum = if value < 0: cSignumCredit else: cSignumDebit
        intToStr(abs(value), length - 1) & signum


proc serializeUnsignedAmount(value: int, length: int, format: OutputFormat): string =
    case format
    of ReadableFormat:
        formatEng(float32(value) / 100.0, 2, trim=false)|R(length)
    of VektisFormat:
        intToStr(value, length)


proc serializeNaturalValue(value: uint, length: int, format: OutputFormat): string =
    case format
    of ReadableFormat:
        intToStr(int(value - 0))|R(length)
    of VektisFormat:
        intToStr(int(value - 0), length)

proc serializeDateValue(value: DateTimeRef, length: int, format: OutputFormat): string =
    case format
    of ReadableFormat:
        format(value[], cReadableDateFormat)
    of VektisFormat:
        if isNil(value):
            cVektisEmptyDate
        else:
            format(value[], cVektisDateFormat)

proc serialize*(value: VektisValue, length: int, format: OutputFormat): string =
   debug("serialization.serialize: serializing $#" % value.asString())
   case value.kind:
   of StringValueType:
       let normalized = value.stringValue
       if normalized.len < int(length):
        result = normalized|L(length)
       else:
        result = normalized[0..length-1]
   of NaturalValueType:
        result = serializeNaturalValue(value.naturalValue, length, format)
   of UnsignedAmountValueType:
        result = serializeUnsignedAmount(value.amountValue, length, format)
   of SignedAmountValueType:
        result = serializeSignedAmount(value.signedAmountValue, length, format)
   of DateValueType:
        result = serializeDateValue(value.dateValue, length, format)
   debug("serialization.serialize -> '$#'" % result)


proc serialize*(value: VektisValue, length: int): string =
    serialize(value, length, VektisFormat)

proc serialize*(element: LineElement): string =
    serialize(element.value, element.leType.length)

proc serialize*(element: LineElement, format: OutputFormat): string =
    serialize(element.value, element.leType.length, format)

proc serialize*(line: Line, stream: Stream) =
    # Rumor has it OrderedTable is not ordered
    for leType in line.lineType.lineElementTypes:
        stream.write(serialize(line.elements[leType.lineElementId]))


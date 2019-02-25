import common, logging, strutils, sequtils, sugar, times, formatting

type
    FieldFormatter* = object of Formatter
        format*: proc (value: VektisValue, length: Natural): string

    VektisFieldFormatter* = object of FieldFormatter
    ReadableFieldFormatter* = object of FieldFormatter


proc formatToVektisOutput(value: VektisValue, length: Natural): string =
    case value.kind
    of StringValueType:
        value.stringValue|L(length)
    of NaturalValueType:
        intToStr(int(value.naturalValue - 0), length)
    of DateValueType:
        if isNil(value.dateValue):
            cVektisEmptyDate
        else:
            format(value.dateValue[], cVektisDateFormat)
    of UnsignedAmountValueType:
        intToStr(value.amountValue, length)
    of SignedAmountValueType:
        let signum = if value.signedAmountValue < 0: cSignumCredit else: cSignumDebit
        intToStr(abs(value.signedAmountValue), length - 1) & signum


proc newVektisFieldFormatter*(): VektisFieldFormatter =
    VektisFieldFormatter(format: formatToVektisOutput)


proc formatToReadableOutput(value: VektisValue, length: Natural): string =
    case value.kind
    of StringValueType:
        value.stringValue|L(length)
    of NaturalValueType:
        intToStr(int(value.naturalValue - 0))|R(length)
    of DateValueType:
        if isNil(value.dateValue):
            repeat(' ',length)
        else:
            format(value.dateValue[], cReadableDateFormat)
    of UnsignedAmountValueType:
        formatEng(float32(value.amountValue) / 100.0, 2, trim=false)|R(length)
    of SignedAmountValueType:
        formatEng(float32(value.signedAmountValue) / 100.0, 2, trim=false)|R(length)


proc newReadableFieldFormatter*(): ReadableFieldFormatter =
    ReadableFieldFormatter(format: formatToReadableOutput)
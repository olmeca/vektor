import os, ospaths, sugar, sequtils, strutils, logging, tables, times
import common, formatting, utils


proc getVektisValueType*(code: string, fieldType: string): VektisValueType =
    let prefix = code[0..2]
    if fieldType == cFieldTypeNumeric:
        if prefix == cDateCodePrefix:
            DateValueType
        elif prefix == cAmountCodePrefix:
            UnsignedAmountValueType
        else:
            NaturalValueType
    else:
        StringValueType


proc newDateTimeRef*(source: DateTime): DateTimeRef =
    DateTimeRef(
        year: source.year,
        month: source.month,
        monthday: source.monthday,
        hour: source.hour,
        minute: source.minute,
        second: source.second,
        weekday: source.weekday,
        yearday: source.yearday,
        isDst: source.isDst,
        timezone: source.timezone,
        utcOffset: source.utcOffset
      )


proc newLeType*(leId: string, code: string, ftype: string, start: int, len: int, cntblref: string, srcId: string, slvId: string, req: bool, valueType: VektisValueType, desc: string): LineElementType =
   result = LineElementType(
      lineElementId: leId,
      valueType: valueType,
      code: code,
      fieldType: ftype,
      startPosition: start,
      length: len,
      description: desc,
      countable: cntblref,
      sourceId: srcId,
      slaveId: slvId,
      required: req
   )


proc newLeType*(leId: string, code: string, ftype: string, start: int, len: int, cntblref: string, srcId: string, slvId: string, req: bool, desc: string): LineElementType =
    newLeType(leId, code, ftype, start, len, cntblref, srcId, slvId, req, getVektisValueType(code[0..2], ftype), desc)


proc createLink*(subLineId: string, multiple: bool, required: bool): LineTypeLink =
    let cardinality = if multiple: ToMany else: ToOne
    LineTypeLink(subLineId: subLineId, cardinality: cardinality, required: required)



proc newSublineLink(cardinality: Cardinality): SublineLink =
    if cardinality == ToMany:
        SublineLink(kind: ToMany, sublines: @[])
    else:
        SublineLink(kind: ToOne, subline: nil)

proc createLine*(lType: LineType, elements: OrderedTable[string, LineElement]): Line =
    result = Line(lineType: lType, elements: elements, sublines: newOrderedTable[string, SublineLink]())
    for typeLink in lType.childLinks:
        result.sublines[typeLink.subLineId] = newSublineLink(typeLink.cardinality)



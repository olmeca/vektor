import strutils, times, sugar, tables, logging, sequtils
import common, factory, doctype, expressions, expressionsreader


proc parseAmountValue*(source: string): VektisValue =
    let digits = source[0..^2]
    let signum = source[^1..^1]
    let intValue = parseInt(digits)
    case signum
    # according to ap304v80 spec: default is debit
    of cSignumCredit:
        VektisValue(kind: SignedAmountValueType, signedAmountValue: -1 * intValue)
    else:
        VektisValue(kind: SignedAmountValueType, signedAmountValue: intValue)


proc parseDateValue*(source: string): VektisValue =
    var date: DateTimeRef = if source == cVektisEmptyDate: nil else: newDateTimeRef(parse(source, cVektisDateFormat))
    VektisValue(kind: DateValueType, dateValue: date)


proc parse*(leType: LineElementType, valueType: VektisValueType, source: string): LineElement =
    debug("lineparsing.parse: '$#' leType: $#, valueType: $#" % [source, leType.asString(), $(valueType)])
    var value: VektisValue
    case valueType
    of StringValueType:
        value = VektisValue(kind: StringValueType, stringValue: source)
    of NaturalValueType:
        value = VektisValue(kind: NaturalValueType, naturalValue: uint(parseInt(source)))
    of SignedAmountValueType:
        value = parseAmountValue(source)
    of UnsignedAmountValueType:
        value = VektisValue(kind: UnsignedAmountValueType, amountValue: parseInt(source))
    of DateValueType:
        value = parseDateValue(source)
    LineElement(leType: leType, value: value)


proc parse*(leType: LineElementType, line: string): LineElement =
    debug("lineparsing.parse: leType: $#, line: $#" % [leType.lineElementId, line[0..13]])
    parse(leType, leType.valueType, getElementValueString(line, leType))




proc parse*(lType: LineType, line: string): Line =
    let elements = lType.lineElementTypes.map(leType => (leType.lineElementId, parse(leType, line)))
    createLine(lType, elements.toOrderedTable)


proc parse*(docType: DocumentType, line: string): Line =
    parse(docType.getLineTypeForLine(line), line)


proc canTakeSubline(line: Line, subline: Line): bool =
    line.sublines.hasKey(subline.lineType.lineId)


proc takeSubline(line: var Line, subline: var Line) =
    let link = line.sublines[subline.lineType.lineId]
    case link.kind
    of ToOne:
        link.subline = subline
    of ToMany:
        link.sublines.add(subline)

    subline.parent = line


proc linkSublines*(line: var Line, lines: var openArray[Line], index: var int) =
    while index < lines.len and line.canTakeSubline(lines[index]):
        var subline = lines[index]
        line.takeSubline(subline)
        index = index + 1
        subline.linkSublines(lines, index)


proc parse*(docType: DocumentType, lineSpecs: seq[string]): Document =
    var theLines = lineSpecs.map(lineSpec => parse(docType, lineSpec))
    var topLine = theLines[0]
    var firstSublineIndex = 1
    topLine.linkSublines(theLines, firstSublineIndex)
    Document(docType: docType, lines: theLines)



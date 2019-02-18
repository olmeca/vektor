import strutils, times, sugar, tables
import common, factory, doctype, expressions, expressionsreader


proc parseAmountValue*(source: string): VektisValue =
    let digits = source[0..^2]
    let signum = source[^1..^1]
    let intValue = parseInt(digits)
    case signum
    of cSignumDebit:
        VektisValue(kind: SignedAmountValueType, signedAmountValue: intValue)
    of cSignumCredit:
        VektisValue(kind: SignedAmountValueType, signedAmountValue: -1 * intValue)
    else:
        raise newException(ValueError, "Invalid value for signum: '$#' in '$#'" % [signum, source])


proc parseDateValue*(source: string): VektisValue =
    var date: DateTimeRef = if source == cVektisEmptyDate: nil else: newDateTimeRef(parse(source, cVektisDateFormat))
    VektisValue(kind: DateValueType, dateValue: date)


proc parse*(leType: LineElementType, valueType: VektisValueType, source: string): LineElement =
    var value: VektisValue
    case valueType
    of StringValueType:
        value = VektisValue(kind: StringValueType, stringValue: source)
    of NaturalValueType:
        value = VektisValue(kind: NaturalValueType, naturalValue: uint(parseInt(source)))
    of SignedAmountValueType:
        value = parseAmountValue(source)
    of DateValueType:
        value = parseDateValue(source)
    else:
        value = VektisValue(kind: EmptyValueType)
    LineElement(leType: leType, value: value)


proc parse*(leType: LineElementType, line: string): LineElement =
    parse(leType, leType.valueType, getElementValueString(line, leType))

proc parse*(lType: LineType, line: string): Line =
    let elements = lc[ (leType.lineElementId, parse(leType, line)) | (leType <- lType.lineElementTypes), (string, LineElement)]
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


proc parse*(docType: DocumentType, lines: seq[string]): Document =
    var lines = lc[ parse(docType, line) | (line <- lines), Line ]
    var topLine = lines[0]
    var firstSublineIndex = 1
    topLine.linkSublines(lines, firstSublineIndex)
    Document(docType: docType, lines: lines)



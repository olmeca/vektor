import strutils, times, future, tables
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


proc parse*(valueType: VektisValueType, source: string): VektisValue =
    case valueType
    of StringValueType:
        VektisValue(kind: StringValueType, stringValue: source)
    of NaturalValueType:
        VektisValue(kind: NaturalValueType, naturalValue: uint(parseInt(source)))
    of SignedAmountValueType:
        parseAmountValue(source)
    of DateValueType:
        parseDateValue(source)
    else:
        VektisValue(kind: EmptyValueType)


proc parse*(leType: LineElementType, line: string): VektisValue =
    parse(leType.valueType, getElementValueString(line, leType))

proc parse*(lType: LineType, line: string): Line =
    let values = lc[ (leType.lineElementId, parse(leType, line)) | (leType <- lType.lineElementTypes), (string, VektisValue)]
    createLine(lType, values.toOrderedTable)


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
    let topLine = lines[0]
    var firstSublineIndex = 1
    topLine.linkSublines(lines, firstSublineIndex)
    Document(docType: docType, lines: lines)
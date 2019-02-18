import streams, strutils, unittest, logging, tables, times
import utils, testutil, common, factory, doctype, context, lineparsing

const
    cLineLength: int = 14


proc asLines(lines: seq[string]): string =
    lines.join("\n")

suite "Line parsing tests":

    setup:
        var docLines: seq[string] = @[
            "01000119781231 ",
            "020001Piet     ",
            "0400010100DC1  ",
            "0400010010CC2  ",
            "0400010010DC2  ",
            "0400020001DC3  ",
            "9900010121D0004"
        ]

        let emptyChildLinks: seq[LineTypeLink] = @[]

        # Create a operation record type (verrichtingenrecord) definition
        let leTypeOperRecordId = newLeType(4, 1, "NUM123", "03 ID", cFieldTypeNumeric, 1, 2)
        let leTypeOperRecordNr = newLeType(4, 2, "NUM123", "03 NR", cFieldTypeNumeric, 3, 4)
        let leTypeOperRecordAmount = newLeTypeOfValueType(4, 3, "BED123", "03 BEDRAG", cFieldTypeNumeric, 7, 5, UnsignedAmountValueType)
        let leTypeOperRecordCode = newLeType(4, 5, "COD123", "04 PAD", cFieldTypeAlphaNum, 12, 4)
        let leTypeOperElements = @[leTypeOperRecordId, leTypeOperRecordNr, leTypeOperRecordAmount, leTypeOperRecordCode]
        let lTypeOper = newLineType(4, cLineLength, "Verrichting", emptyChildLinks, leTypeOperElements, false)

        # Create a patient record (verzekerderecord) type definition
        let leTypePatientRecordId = newLeType(2, 1, "NUM123", "02 ID", cFieldTypeNumeric, 1, 2)
        let leTypePatientRecordNr = newLeType(2, 2, "NUM123", "02 NR", cFieldTypeNumeric, 3, 4)
        let leTypePatientRecordName = newLeType(2, 3, "COD123", "02 NAME", cFieldTypeAlphaNum, 7, 9)
        let operChildLink = createLink("04", true, true)
        let leTypePatientElements = @[leTypePatientRecordId, leTypePatientRecordNr, leTypePatientRecordName]
        let lTypePatient = newLineType(2, cLineLength, "Patient", @[operChildLink], leTypePatientElements, false)

        # Create a cumulatives record (sluitrecord) type definition
        let leTypeTotalsRecordId = newLeType(99, 1, "NUM123", "99 ID", cFieldTypeNumeric, 1, 2)
        let leTypeTotalsRecordNr = newLeType(99, 2, "NUM123", "99 NR", cFieldTypeNumeric, 3, 4)
        let leTypeTotalsAmount = newLeType(99, 3, "BED123", "99 TOTAL", cFieldTypeNumeric, 7, 5)
        let leTypeTotalsOperCount = newLeType(99, 5, "NUM456", "99 REC CNT", cFieldTypeNumeric, 12, 4)
        let leTypeTotalsElements = @[leTypeTotalsRecordId, leTypeTotalsRecordNr, leTypeTotalsAmount, leTypeTotalsOperCount]
        let lTypeTotals = newLineType(99, cLineLength, "Totalen", emptyChildLinks, leTypeTotalsElements, false)
        # setup cumulative dependency on 0403 line element
        leTypeTotalsAmount.countable = "0403"
        lTypeTotals.hasDependentElements = true
        # setup cumulative dependency on 0400
        leTypeTotalsOperCount.countable = "0400"

        # Create a declaration level record (Voorlooprecord) type definition
        let leTypeVoorloopRecordId = newLeType(1, 1, "NUM123", "01 ID", cFieldTypeNumeric, 1, 2)
        let leTypeVoorloopRecordNr = newLeType(1, 2, "NUM123", "01 NR", cFieldTypeNumeric, 3, 4)
        let leTypeVoorloopRecordDat = newLeType(1, 3, "DAT123", "01 PAD", cFieldTypeNumeric, 7, 8)
        let leTypeVoorloopRecordPad = newLeType(1, 4, "COD123", "04 PAD", cFieldTypeAlphaNum, 15, 1)
        let patientChildLink = createLink("02", true, true)
        let totalsChildLink = createLink("99", false, true)
        let leTypeVoorloopRecordElements = @[leTypeVoorloopRecordId, leTypeVoorloopRecordNr, leTypeVoorloopRecordDat, leTypeVoorloopRecordPad]
        let lTypeVoorloopRecord = newLineType(1, cLineLength, "Voorloop", @[patientChildLink, totalsChildLink], leTypeVoorloopRecordElements, false)

        # Create the document type
        let lineTypes = @[lTypeVoorloopRecord, lTypePatient, lTypeOper, lTypeTotals]
        let docType = newDocType(1, 1, 0, cLineLength, lineTypes)

        # Create the document
        let document = docType.parse(docLines)


    test "Document structure is correct.":
        check:
            document.lines.len == 7
        let topline = document.lines[0]
        check:
            topline.sublines.len == 2
            topline.sublines.haskey("02")
            topline.sublines.haskey("99")
        let patientLineLink = topline.sublines["02"]
        check:
            patientLineLink.kind == ToMany
        let patientLine = patientLineLink.sublines[0]
        check:
            patientLine.lineType.lineId == "02"


    test "Values read correctly":
        var line: Line
        line = document.lines[0]
        check:
            line.lineType.lineId == cTopLineId
            line.elements["0101"].value.kind == NaturalValueType
            line.elements["0101"].value.naturalValue == uint(1)
            line.elements["0102"].value.kind == NaturalValueType
            line.elements["0102"].value.naturalValue == uint(1)
            line.elements["0103"].value.kind == DateValueType
        let dateRef = line.elements["0103"].value.dateValue
        check:
            not isNil(dateRef)
            dateRef[].format("dd-MM-yyyy") == "31-12-1978"

        line = document.lines[1]
        check:
            line.lineType.lineId == cPatientLineId
            line.elements["0201"].value.kind == NaturalValueType
            line.elements["0201"].value.naturalValue == uint(2)
            line.elements["0202"].value.kind == NaturalValueType
            line.elements["0202"].value.naturalValue == uint(1)
            line.elements["0203"].value.kind == StringValueType
            line.elements["0203"].value.stringValue == "Piet"


    test "Positive signed value is read correctly.":
        activateLogging()
        let leType = newLeTypeOfValueType(4, 3, "BED123", NIL, cFieldTypeNumeric, 1, 6, SignedAmountValueType)
        debug("leType: $#" % leType.asString())
        let element = leType.parse("00101D")

        check:
            element.value.kind == SignedAmountValueType
            element.value.signedAmountValue == 101


    test "Negative signed value is read correctly.":
        activateLogging()
        let leType = newLeTypeOfValueType(4, 3, "BED123", NIL, cFieldTypeNumeric, 1, 6, SignedAmountValueType)
        debug("leType: $#" % leType.asString())
        let element = leType.parse("00101C")

        check:
            element.value.kind == SignedAmountValueType
            element.value.signedAmountValue == -101


    test "Invalid sign indicator is signaled.":
        activateLogging()
        let leType = newLeTypeOfValueType(4, 3, "BED123", NIL, cFieldTypeNumeric, 1, 6, SignedAmountValueType)
        debug("leType: $#" % leType.asString())
        var msg: string
        try:
            let value = leType.parse("001015")
        except (ValueError):
            msg = getCurrentExceptionMsg()

        check:
            msg.startsWith("Invalid value for signum: '5'")



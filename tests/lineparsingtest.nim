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
        let leTypeOperRecordAmount = newLeType(4, 3, "BED123", "03 BEDRAG", cFieldTypeNumeric, 7, 5)
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
            line.values["0101"].kind == NaturalValueType
            line.values["0101"].naturalValue == uint(1)
            line.values["0102"].kind == NaturalValueType
            line.values["0102"].naturalValue == uint(1)
            line.values["0103"].kind == DateValueType
        let dateRef = line.values["0103"].dateValue
        check:
            not isNil(dateRef)
            dateRef[].format("dd-MM-yyyy") == "31-12-1978"

        line = document.lines[1]
        check:
            line.lineType.lineId == cPatientLineId
            line.values["0201"].kind == NaturalValueType
            line.values["0201"].naturalValue == uint(2)
            line.values["0202"].kind == NaturalValueType
            line.values["0202"].naturalValue == uint(1)
            line.values["0203"].kind == StringValueType
            line.values["0203"].stringValue == "Piet"

        line = document.lines[2]
        check:
            line.lineType.lineId == cOperationLineId
            line.values["0403"].kind == SignedAmountValueType
            line.values["0403"].amountValue == 100

        line = document.lines[3]
        check:
            line.lineType.lineId == cOperationLineId
            line.values["0403"].kind == SignedAmountValueType
            line.values["0403"].amountValue == -10


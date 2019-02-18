import logging, unittest, times, tables, streams
import common, factory, testutil, serialization


const
    cLineLength: int = 14


suite "Serialization tests":

    test "Serialize text":
        let value = VektisValue(kind: StringValueType, stringValue: "test")
        check:
            value.serialize(7) == "test   "


    test "Serialize natural":
        let value = VektisValue(kind: NaturalValueType, naturalValue: uint(19))
        check:
            value.serialize(7) == "0000019"


    test "Serialize unsigned amount":
        let value = VektisValue(kind: UnsignedAmountValueType, amountValue: 19)
        check:
            value.serialize(7) == "0000019"


    test "Serialize signed positive amount":
        let value = VektisValue(kind: SignedAmountValueType, signedAmountValue: 19)
        check:
            value.serialize(7) == "000019D"


    test "Serialize signed negative amount":
        let value = VektisValue(kind: SignedAmountValueType, signedAmountValue: -19)
        check:
            value.serialize(7) == "000019C"


    test "Serialize date":
        let datetimeRef = newDateTimeRef(parse("1989-12-30", cReadableDateFormat))
        let value = VektisValue(kind: DateValueType, dateValue: datetimeRef)
        check:
            value.serialize(8) == "19891230"


    test "Serialize line":
        let emptyChildLinks: seq[LineTypeLink] = @[]
        let outStream = newStringStream()
        # Create a operation record type (verrichtingenrecord) definition
        let leTypeOperRecordId = newLeType(4, 1, "NUM123", "03 ID", cFieldTypeNumeric, 1, 2)
        let leTypeOperRecordNr = newLeType(4, 2, "NUM123", "03 NR", cFieldTypeNumeric, 3, 4)
        let leTypeOperRecordAmount = newLeType(4, 3, "BED123", "03 BEDRAG", cFieldTypeNumeric, 7, 5)
        let leTypeOperRecordCode = newLeType(4, 5, "COD123", "04 PAD", cFieldTypeAlphaNum, 12, 4)
        let leTypeOperElements = @[leTypeOperRecordId, leTypeOperRecordNr, leTypeOperRecordAmount, leTypeOperRecordCode]
        let lTypeOper = newLineType(4, cLineLength, "Verrichting", emptyChildLinks, leTypeOperElements, false)
        # Create a line, first create the values
        var elements = newOrderedTable[string, LineElement]()
        elements["0401"] = LineElement(leType: leTypeOperRecordId, value: VektisValue(kind: NaturalValueType, naturalValue: 1))
        elements["0402"] = LineElement(leType: leTypeOperRecordNr, value: VektisValue(kind: NaturalValueType, naturalValue: 130))
        elements["0403"] = LineElement(leType: leTypeOperRecordAmount, value: VektisValue(kind: SignedAmountValueType, signedAmountValue: -1234))
        elements["0405"] = LineElement(leType: leTypeOperRecordCode, value: VektisValue(kind: StringValueType, stringValue: "OK"))
        let line = createLine(lTypeOper, elements[])
        line.serialize(outStream)
        check:
            outStream.data == "0101301234COK  "


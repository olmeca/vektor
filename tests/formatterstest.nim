import common, logging, strutils, sequtils, times, factory, unittest, formatting, formatters


suite "Vektis output formatter tests":

    setup:
        let vektisFormatter = newVektisOutputFormatter()


    test "Formatting unsigned amount left-pads with zeros":
        let value = VektisValue(kind: UnsignedAmountValueType, amountValue: 100)
        let stringValue = vektisFormatter.format(value, 5)
        check:
            stringValue == "00100"


    test "Formatting positive signed amount left-pads with zeros, appends D":
        let value = VektisValue(kind: SignedAmountValueType, signedAmountValue: 100)
        let stringValue = vektisFormatter.format(value, 5)
        check:
            stringValue == "0100D"


    test "Formatting negative signed amount left-pads with zeros, appends C":
        let value = VektisValue(kind: SignedAmountValueType, signedAmountValue: -100)
        let stringValue = vektisFormatter.format(value, 5)
        check:
            stringValue == "0100C"


    test "Formatting date":
        let dateTimeRef = newDateTimeRef(parse("2013-03-30", cReadableDateFormat))
        let value = VektisValue(kind: DateValueType, dateValue: dateTimeRef)
        let stringValue = vektisFormatter.format(value, 8)
        check:
            stringValue == "20130330"


    test "Formatting empty date returns zeros string":
        let value = VektisValue(kind: DateValueType, dateValue: nil)
        let stringValue = vektisFormatter.format(value, 8)
        check:
            stringValue == "00000000"


    test "Formatting string right-pads with spaces":
        let value = VektisValue(kind: StringValueType, stringValue: "bla")
        let stringValue = vektisFormatter.format(value, 5)
        check:
            stringValue == "bla  "



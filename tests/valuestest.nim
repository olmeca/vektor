import unittest, common, context, expressions, serialization, literal, number, times, factory

suite "Vektis value tests":

    test "String value serialized is padded to length":
        let value = VektisValue(kind: StringValueType, stringValue: "test")
        check:
            value.serialize(6) == "test  "


    test "String value serialized is trimmed to length":
        let value = VektisValue(kind: StringValueType, stringValue: "test")
        check:
            value.serialize(2) == "te"

    test "Natural value serialized is padded to length":
        let value = VektisValue(kind: NaturalValueType, naturalValue: uint(23))
        check:
            value.serialize(6) == "000023"


    test "Positive amount value serialized is padded to length":
        let value = VektisValue(kind: SignedAmountValueType, signedAmountValue: 12345)
        check:
            value.serialize(9) == "00012345D"


    test "Negative amount value serialized is padded to length":
        let value = VektisValue(kind: SignedAmountValueType, signedAmountValue: -12345)
        check:
            value.serialize(9) == "00012345C"


    test "Date value serialized":
        let value = VektisValue(kind: DateValueType, dateValue: newDateTimeRef(parse("2012-11-30", cReadableDateFormat)))
        check:
            value.serialize(9) == "20121130"


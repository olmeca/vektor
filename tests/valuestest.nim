import unittest, common, context, expressions, literal, number, times

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


    test "Amount value serialized is padded to length":
        let value = VektisValue(kind: SignedAmountValueType, signedAmountValue: 12345)
        check:
            value.serialize(9) == "000012345"


    test "Date value serialized":
        let value = VektisValue(kind: DateValueType, dateValue: parse("2012-11-30", cReadableDateFormat))
        check:
            value.serialize(9) == "20121130"


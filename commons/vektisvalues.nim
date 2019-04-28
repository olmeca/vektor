import tables, logging, strutils, sequtils, sugar, times
import common, formatting


type
    Comparable = concept a
        (a < a) is bool
        (a == a) is bool



proc eq*(value: VektisValue, refValue: VektisValue): bool =
    if value.kind == refValue.kind:
        case value.kind
        of StringValueType:
            value.stringValue == refValue.stringValue
        of NaturalValueType:
            value.naturalValue == refValue.naturalValue
        of UnsignedAmountValueType:
            value.amountValue == refValue.amountValue
        of SignedAmountValueType:
            value.signedAmountValue == refValue.signedAmountValue
        of DateValueType:
            isNil(value.dateValue) and isNil(refValue.dateValue) or
                value.dateValue == refValue.dateValue
    else:
        raise newException(ValueError, "Cannot compare different Vektis value types: $# == $#" % [value.asString(), refValue.asString()])


proc gt*(value: VektisValue, refValue: VektisValue): bool =
    if value.kind == refValue.kind:
        case value.kind
        of StringValueType:
            value.stringValue > refValue.stringValue
        of NaturalValueType:
            value.naturalValue > refValue.naturalValue
        of UnsignedAmountValueType:
            value.amountValue > refValue.amountValue
        of SignedAmountValueType:
            value.signedAmountValue > refValue.signedAmountValue
        of DateValueType:
            # nil date considered less than existing date
            not isNil(value.dateValue) and
                (isNil(refValue.dateValue) or value.dateValue > refValue.dateValue)
    else:
        raise newException(ValueError, "Cannot compare different Vektis value types: $# > $#" % [value.asString(), refValue.asString()])


template uneq*(value, refValue: typed): bool =
    not (value eq refValue)


template lte*(value, refValue: untyped): bool =
    not (value gt refValue)


template gte*(value, refValue: untyped): bool =
    value eq refValue or value gt refValue


template lt*(value, refValue: untyped): bool =
    not (value gte refValue)



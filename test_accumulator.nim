import unittest, utils, testutil, common, doctypes, context, jobs



suite "Accumulator tests":

    test "First test":
        let leType1 = newLeType(1, 1, "doctype", cFieldTypeNumeric, 1, 2)
        let lType = newLineType(1, 2, @[], @[leType1], false)
        let docType = newDocType(1, 1, 0, 2, @[lType])

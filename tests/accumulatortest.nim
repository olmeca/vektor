import streams, strutils, unittest, logging
import utils, testutil, common, doctype, context, job, accumulator, showjob, copyjob, validatejob

const
    cLineLength: int = 14



proc asLines(lines: seq[string]): string =
    lines.join("\n")

#proc activateLogging() =
#   let filePath = "/Users/rudi/Scratch/vektor.log"
#   var fileLogger = newFileLogger(filePath, fmtStr = verboseFmtStr)
#   addHandler(fileLogger)
#   setLogFilter(lvlDebug)

proc createShowJob(docType: DocumentType, fields: string, qualifier: string): ShowJob =
    let job = newShowJob()
    job.docType = docType
    job.debRecVersion = drvDefault
    job.fieldsString = fields
    job.selectionQualifierString = qualifier
    job.initializeFieldSpecs()
    job.initializeSelectionQualifier()
    job.accumulator = newAccumulator(job.docType)
    job

proc createCopyJob(docType: DocumentType, fieldSpecs: string, selectionQualifier: string, replacementQualifier: string): CopyJob =
    let job = newCopyJob()
    job.docType = docType
    job.debRecVersion = drvDefault
    job.fieldValuesString = fieldSpecs
    job.selectionQualifierString = selectionQualifier
    job.replacementQualifierString = replacementQualifier
    job.initializeFieldValueSpecs()
    job.initializeSelectionQualifier()
    job.initializeReplacementQualifier()
    job.accumulator = newAccumulator(job.docType)
    job

proc createValidateJob(docType: DocumentType): ValidateJob =
    let job = newValidateJob()
    job.docType = docType
    job.debRecVersion = drvDefault
    job.accumulator = newAccumulator(job.docType)
    job

suite "ShowJob Accumulator tests":

    setup:
        var declaration1: seq[string] = @[
            "010001         ",
            "020001Piet     ",
            "0400010100DC1  ",
            "0400010010DC2  ",
            "0400010010DC2  ",
            "0400020001DC3  ",
            "9900010121D0004"
        ]

        let emptyChildLinks: seq[LineTypeLink] = @[]
        var output: StringStream = newStringStream()

        # Create a operation record (verrichtingenrecord) type definition
        let leTypeOperRecordId = newLeType(4, 1, "NUM123", "03 ID", cFieldTypeNumeric, 1, 2)
        let leTypeOperRecordNr = newLeType(4, 2, "NUM123", "03 NR", cFieldTypeNumeric, 3, 4)
        let leTypeOperRecordAmount = newLeType(4, 3, "BED123", "03 BEDRAG", cFieldTypeNumeric, 7, 4)
        let leTypeOperRecordDC = newLeType(4, 4, "COD456", "03 DEBCRED", cFieldTypeAlphaNum, 11, 1)
        let leTypeOperRecordCode = newLeType(4, 5, "COD123", "04 PAD", cFieldTypeAlphaNum, 12, 4)
        let leTypeOperElements = @[leTypeOperRecordId, leTypeOperRecordNr, leTypeOperRecordAmount, leTypeOperRecordDC, leTypeOperRecordCode]
        let lTypeOper = newLineType(4, cLineLength, "Verrichting", emptyChildLinks, leTypeOperElements, false)

        # Create a patient record (verzekerderecord) type definition
        let leTypePatientRecordId = newLeType(2, 1, "NUM123", "02 ID", cFieldTypeNumeric, 1, 2)
        let leTypePatientRecordNr = newLeType(2, 2, "NUM123", "02 NR", cFieldTypeNumeric, 3, 4)
        let leTypePatientRecordName = newLeType(2, 3, "COD123", "02 NAME", cFieldTypeAlphaNum, 7, 9)
        let operChildLink = LineTypeLink(subLineId: "04", multiple: true, required: true)
        let leTypePatientElements = @[leTypePatientRecordId, leTypePatientRecordNr, leTypePatientRecordName]
        let lTypePatient = newLineType(2, cLineLength, "Patient", @[operChildLink], leTypePatientElements, false)

        # Create a cumulatives record (sluitrecord) type definition
        let leTypeTotalsRecordId = newLeType(99, 1, "NUM123", "99 ID", cFieldTypeNumeric, 1, 2)
        let leTypeTotalsRecordNr = newLeType(99, 2, "NUM123", "99 NR", cFieldTypeNumeric, 3, 4)
        let leTypeTotalsAmount = newLeType(99, 3, "BED123", "99 TOTAL", cFieldTypeNumeric, 7, 4)
        let leTypeTotalsAmountDC = newLeType(99, 4, "COD456", "99 DEBCRED", cFieldTypeAlphaNum, 11, 1)
        let leTypeTotalsOperCount = newLeType(99, 5, "NUM456", "99 REC CNT", cFieldTypeNumeric, 12, 4)
        let leTypeTotalsElements = @[leTypeTotalsRecordId, leTypeTotalsRecordNr, leTypeTotalsAmount, leTypeTotalsAmountDC, leTypeTotalsOperCount]
        let lTypeTotals = newLineType(99, cLineLength, "Totalen", emptyChildLinks, leTypeTotalsElements, false)
        # setup cumulative dependency on 0403 line element
        leTypeTotalsAmount.countable = "0403"
        lTypeTotals.hasDependentElements = true
        # setup cumulative dependency on 0400
        leTypeTotalsOperCount.countable = "0400"

        # Create a declaration level record (Voorlooprecord) type definition
        let leTypeVoorloopRecordId = newLeType(1, 1, "NUM123", "01 ID", cFieldTypeNumeric, 1, 2)
        let leTypeVoorloopRecordNr = newLeType(1, 2, "NUM123", "01 NR", cFieldTypeNumeric, 3, 4)
        let leTypeVoorloopRecordPad = newLeType(1, 3, "COD123", "01 PAD", cFieldTypeAlphaNum, 7, 8)
        let patientChildLink = LineTypeLink(subLineId: "02", multiple: true, required: true)
        let totalsChildLink = LineTypeLink(subLineId: "99", multiple: false, required: true)
        let leTypeVoorloopRecordElements = @[leTypeVoorloopRecordId, leTypeVoorloopRecordNr, leTypeVoorloopRecordPad]
        let lTypeVoorloopRecord = newLineType(1, cLineLength, "Voorloop", @[patientChildLink, totalsChildLink], leTypeVoorloopRecordElements, false)

        # Create the document type
        let lineTypes = @[lTypeVoorloopRecord, lTypePatient, lTypeOper, lTypeTotals]
        let docType = newDocType(1, 1, 0, cLineLength, lineTypes)
        initializeExpressionReaders()


    test "ShowJob: accumulator counts positive totals":
        var input: StringStream = newStringStream(declaration1.asLines)
        let job = createShowJob(docType, "0403;0404", nil)
        job.process(input, output)
        # echo output.data
        check:
            # total amount check
            job.accumulator.totals[0].value == 121
            # nr of 04 lines check
            job.accumulator.totals[1].value == 4

    test "ShowJob: accumulator counts positive and negative totals":
        declaration1.insert("0400010010CC2  ", 3)
        var input: StringStream = newStringStream(declaration1.asLines)
        let job = createShowJob(docType, "0403;0404", nil)
        job.process(input, output)
        # echo output.data
        check:
            job.accumulator.totals[0].value == 111
            job.accumulator.totals[1].value == 5

    test "ShowJob: accumulator counts only selected lines":
        var input: StringStream = newStringStream(declaration1.asLines)
        let job = createShowJob(docType, "0403;0405:Op", "0405=\"C2\"")
        job.process(input, output)
        # echo output.data
        check:
            # total amount check
            job.accumulator.totals[0].value == 20
            # nr of 04 lines check
            job.accumulator.totals[1].value == 2

    test "CopyJob: accumulator counts positive totals":
        var input: StringStream = newStringStream(declaration1.asLines)
        var job = createCopyJob(docType, nil, nil, nil)
        job.process(input, output)
        # echo output.data
        check:
            # total amount check
            job.accumulator.totals[0].value == 121
            # nr of 04 lines check
            job.accumulator.totals[1].value == 4

    test "CopyJob: accumulator counts only selected lines":
        var input: StringStream = newStringStream(declaration1.asLines)
        var job = createCopyJob(docType, nil, "0405=\"C2\"", nil)
        job.process(input, output)
        # echo output.data
        check:
            # total amount check
            job.accumulator.totals[0].value == 20
            # nr of 04 lines check
            job.accumulator.totals[1].value == 2

    test "CopyJob: accumulator counts modified lines":
        var input: StringStream = newStringStream(declaration1.asLines)
        var job = createCopyJob(docType, "0403=1000", nil, "0405=\"C2\"")
        job.process(input, output)
        # echo output.data
        check:
            # total amount check
            job.accumulator.totals[0].value == 2101
            # nr of 04 lines check
            job.accumulator.totals[1].value == 4

    test "CopyJob: accumulator counts modified selected lines":
        var input: StringStream = newStringStream(declaration1.asLines)
        var job = createCopyJob(docType, "0403=1000", "0405=\"C2\"", "0405=\"C2\"")
        job.process(input, output)
        # echo output.data
        check:
            # total amount check
            job.accumulator.totals[0].value == 2000
            # nr of 04 lines check
            job.accumulator.totals[1].value == 2

    test "ValidateJob 1":
        var input: StringStream = newStringStream(declaration1.asLines)
        var errors: seq[ValidationResult] = @[]
        var job = createValidateJob(docType)
        job.process(input, errors)
        check:
            len(errors) == 0

import unittest, logging, parseopt2
import common, qualifiers, doctype, job

suite "info command":
    setup:
        let job = newInfoJob()

    test "info command: own named parameter":
        let param1 = newNamedJobParam(cParamNameLineId, "test")
        param1.apply(job)
        check:
            job.lineId == "test"

    test "info command: own indexed parameters":
        let param = newJobParam("MZ301")
        param.apply(job)
        let param2 = newJobParam("1.3")
        param2.apply(job)
        check:
             job.docTypeName == "MZ301"
             job.docTypeVersion == 1
             job.docTypeSubversion == 3

    test "info command: inherited named parameter":
        let param1 = newNamedJobParam(cParamNameDebugLevel, "debug")
        param1.apply(job)
        check:
            job.logLevel == lvlDebug

suite "show command":
    setup:
        let job = newShowJob()

    test "show command: inherited named parameter":
        let param1 = newNamedJobParam(cParamNameDebugLevel, "debug")
        param1.apply(job)
        check:
            job.logLevel == lvlDebug

    test "show command: inherited indexed parameters":
        let param = newJobParam("test.asc")
        param.apply(job)
        check:
             job.documentPath == "test.asc"

    test "show command: all named parameters":
        newNamedJobParam(cParamNameFieldsString, "fieldsstring").apply(job)
        newNamedJobParam(cParamNameFieldSet, "fieldsfile").apply(job)
        check:
            job.fieldsString == "fieldsstring"
            job.fieldsConfigKey == "fieldsfile"

suite "copy command":
    setup:
        let job = newCopyJob()

    test "copy command: inherited named parameter":
        let param1 = newNamedJobParam(cParamNameDebugLevel, "debug")
        param1.apply(job)
        check:
            job.logLevel == lvlDebug

    test "copy command: inherited indexed parameters":
        let param = newJobParam("test.asc")
        param.apply(job)
        check:
             job.documentPath == "test.asc"

    test "copy command: all named parameters":
        newNamedJobParam(cParamNameFieldValuesString, "fieldvaluesstring").apply(job)
        newNamedJobParam(cParamNameFieldValuesFile, "fieldvaluesfile").apply(job)
        newNamedJobParam(cParamNameCondition, "replacementQualString").apply(job)
        newNamedJobParam(cParamNameOutputPath, "outputPath").apply(job)
        check:
            job.fieldValuesString == "fieldvaluesstring"
            job.fieldValuesFile == "fieldvaluesfile"
            job.replacementQualifierString == "replacementQualString"
            job.outputPath == "outputPath"

suite "reading job":

    test "info job with doctype":
        var options = initOptParser("info MZ301")
        let job = InfoJob(readJob(options))
        check:
             job.docTypeName == "MZ301"
             job.docTypeVersion == cParamIntValueNone

    test "info job with doctype and debug level":
        var options = initOptParser("info MZ301 -D:debug")
        let job = InfoJob(readJob(options))
        check:
             job.docTypeName == "MZ301"
             job.logLevel == lvlDebug
             job.docTypeVersion == cParamIntValueNone

    test "info job with doctype and version and line id":
        var options = initOptParser("info MZ301 1.3 -l:04")
        let job = InfoJob(readJob(options))
        check:
             job.docTypeName == "MZ301"
             job.docTypeVersion == 1
             job.docTypeSubversion == 3
             job.lineId == "04"


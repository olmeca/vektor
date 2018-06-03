import unittest, logging
import "common", "qualifiers", "doctypes", "jobs"

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
             job.docTypeVersion == "1.3"

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
        newNamedJobParam(cParamNameFieldsFile, "fieldsfile").apply(job)
        check:
            job.fieldsString == "fieldsstring"
            job.fieldsFile == "fieldsfile"

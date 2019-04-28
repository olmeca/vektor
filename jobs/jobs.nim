import os, streams, logging, sets, strutils, sequtils, parseopt, tables
import job, infojob, copyjob, showjob, validatejob


proc createJobForCommand(cmdString: string): VektorJob =
    case cmdString
    of cCommandInfo:
        result = newInfoJob()
    of cCommandHelp:
        result = newHelpJob()
    of cCommandShow:
        result = newShowJob()
    of cCommandCopy, cCommandEdit:
        result = newCopyJob()
    of cCommandRevert:
        result = newRevertJob()
    of cCommandValidate:
        result = newValidateJob()
    else:
        raise newException(ValueError, "Invalid command: $#" % cmdString)

proc createNamedParam(key: string, value: string): NamedJobParam =
    if len(key) > 1:
        raise newException(ValueError, "Invalid command option: $#" % key)
    else:
        result = newNamedJobParam(toSeq(key.items)[0], value)


proc readJob*(parser: var OptParser): VektorJob =
    for kind, key, value in getopt(parser):
        debug("Parsing option '$#'" % [key])
        case kind
        of cmdArgument:
            if isNil(result):
                result = createJobForCommand(key)
            else:
                let param = newJobParam(key)
                apply(param, result)
        of cmdShortOption:
            if isNil(result):
                raise newException(ValueError, "Missing vektor command.")
            else:
                debug("Option value: $#" % value)
                let param = createNamedParam(key, value)
                apply(param, result)
        else:
            raise newException(ValueError, "Invalid command option: $#" % key)



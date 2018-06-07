import os, parseopt2, strutils, sequtils, json, future, streams, random, pegs, times, tables, logging

import "doctypes", "context", "qualifiers", "common", "accumulator", "jobs", "utils"

proc matchesDoctypeName(job: InfoJob, docType: DocumentType): bool =
    isNil(job.docTypeName) or docType.name.startsWith(job.docTypeName)

proc matchesVersion(job: InfoJob, docType: DocumentType): bool =
    job.docTypeVersion == -1 or job.docTypeVersion == docType.formatVersion

proc matchesSubversion(job: InfoJob, docType: DocumentType): bool =
    job.docTypeSubversion == -1 or job.docTypeSubversion == docType.formatSubVersion

proc matchesDocType(job: InfoJob, dt: DocumentType): bool =
    job.matchesDocTypeName(dt) and job.matchesVersion(dt) and job.matchesSubversion(dt)

proc matchingDocTypes(job: InfoJob, docTypes: seq[DocumentType]): seq[DocumentType] =
   result = filter(docTypes, proc (dt: DocumentType): bool = job.matchesDocType(dt) )

proc writeDocumentTypes(docTypes: seq[DocumentType], outStream: Stream) =
   for doctype in docTypes:
      outStream.write("$#\n" % [summary(doctype)])

proc writeLineTypeInfo(job: InfoJob, outStream: Stream) =
   let lt = job.docType.getLineTypeForLineId(job.lineId)
   outStream.write("$#: $#\n" % [summary(job.docType), lt.name])
   outStream.write("ID     V-code    Pos    Len   Type   Description\n")
   for et in lt.lineElementTypes:
      outStream.write("$#   $#   $#   $#   $#   $#\n" %
         [et.lineElementId,
         et.code,
         intToStr(et.startPosition, 4),
         intToStr(et.length, 4),
         padright(et.fieldType, 4),
         et.description])

proc writeDocumentTypeInfo(job: InfoJob, outStream: Stream) =
   outStream.write("$#\n" % [summary(job.docType)])
   outStream.write("ID   Len   Description\n")
   for lineType in job.docType.lineTypes:
      outStream.write("$#   $#   $#\n" % [
         lineType.lineId,
         intToStr(lineType.length,3),
         lineType.name])


proc writeInfo*(job: InfoJob, outStream: Stream) =
    let matchingDocTypes = job.matchingDocTypes(allDocumentTypes())
    case len(matchingDocTypes)
    of 0:
        quit("Specified document format or version not supported.")
    of 1:
        if isNil(job.lineId):
            writeDocumentTypeInfo(job, outStream)
        else:
            writeLineTypeInfo(job, outStream)
    else:
        writeDocumentTypes(matchingDocTypes, outStream)

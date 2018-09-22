import future, sequtils, strutils, logging, tables, times, streams, os, ospaths
import common, vektorjson, formatting, utils, jsondoctypes

proc quoteStr(value: string): string =
    if isNil(value): "nil" else: "\"$#\"" % value

proc boolToStr(value: bool): string =
    if value: "true" else: "false"

proc ext(docType: DocumentType): string =
    "$#$#$#" % [docType.name, intToStr(docType.formatVersion), intToStr(docType.formatSubVersion)]

proc ext(docType: DocumentType, lType: LineType): string =
    "$#$#$#$#" % [docType.name, intToStr(docType.formatVersion), intToStr(docType.formatSubVersion), lType.lineId]

let lineSeparated = """
$#

$#
"""


proc genCreateLineElementType( leType: LineElementType): string =
    "        newLeType($#, $#, $#, $#, $#, $#, $#, $#, $#, $#)" % [
        quoteStr(leType.lineElementId),
        quoteStr(leType.code),
        quoteStr(leType.fieldType),
        intToStr(leType.startPosition),
        intToStr(leType.length),
        quoteStr(leType.countable),
        quoteStr(leType.sourceId),
        quoteStr(leType.slaveId),
        boolToStr(leType.required),
        quoteStr(leType.description)
    ]

proc genCreateLineElementTypes(lType: LineType): string =
    join(lc[genCreateLineElementType(item) | (item <- lType.lineElementTypes), string], ",\n")

proc genCreateLink(link: LineTypeLink): string =
    "createLink($#, $#, $#)" % [quoteStr(link.subLineId), boolToStr(link.multiple), boolToStr(link.required)]

proc genCreateLinks(links: seq[LineTypeLink]): string =
    "@[$#]" % join(lc[genCreateLink(item) | (item <- links), string], ", ")

let createLineTypeFunctionTemplate = """
proc createLineType$#(): LineType =
    let leTypes = @[
$#
    ]
    result = LineType(
       name: $#,
       length: $#,
       lineId: $#,
       index: $#,
       childLinks: $#,
       lineElementTypes: leTypes,
       hasDependentElements: $#
    )
"""

proc genCreateLineTypeFunction(docType: DocumentType, lType: LineType): string =
    createLineTypeFunctionTemplate % [
        docType.ext(lType),
        genCreateLineElementTypes(lType),
        quoteStr(lType.name),
        intToStr(lType.length),
        quoteStr(lType.lineId),
        intToStr(lType.index),
        genCreateLinks(lType.childLinks),
        boolToStr(lType.hasDependentElements)
    ]

let createLineTypesFunctionTemplate = """
proc createLineTypes$#(): seq[LineType] =
    @[
$#
    ]


"""

proc genCreateLineTypesFunction(docType: DocumentType): string =
    let createLineTypeFunction = join(lc[genCreateLineTypeFunction(docType, item) | (item <- docType.lineTypes), string] , "\n")
    let createLineTypesFunction = createLineTypesFunctionTemplate % [docType.ext, join(lc["        createLineType$#()" % docType.ext(item) | (item <- docType.lineTypes), string], ",\n")]
    result = lineSeparated % [createLineTypeFunction, createLineTypesFunction]



proc genCreateDocTypeFunction(docType: DocumentType): string =
    """
proc createDocType$#*(): DocumentType =
    let lineTypes = createLineTypes$#()
    DocumentType(
        name: $#,
        description: $#,
        formatVersion: $#,
        formatSubVersion: $#,
        vektisEICode: $#,
        lineLength: $#,
        lineTypes: lineTypes
    )

    """ % [
        docType.ext,
        docType.ext,
        quoteStr(docType.name),
        quoteStr(docType.description),
        intToStr(docType.formatVersion),
        intToStr(docType.formatSubVersion),
        intToStr(docType.vektisEICode),
        intToStr(docType.lineLength)
    ]

let fullDocTypeCodeTemplate = """
import strutils, sequtils, common

$#
$#
"""

proc genCreateDocTypeCode*(docType: DocumentType): string =
    fullDocTypeCodeTemplate % [genCreateLineTypesFunction(docType), genCreateDocTypeFunction(docType)]


proc createDocTypeSource*(docType: DocumentType) =
    echo "Create source: $#" % (if isNil(docType): "nil" else: docType.name)
    if not isNil(docType):
        let outputPath = "$#.nim" % docType.ext
        echo "Creating source file '$#'" % outputPath
        var outStream: Stream = newFileStream(outputPath, fmWrite)
        outStream.write(genCreateDocTypeCode(docType))
        close(outStream)
    else: discard

proc genDocTypesSources*() =
    readConfigurationFile()
    for docType in getAllDocumentTypes():
        createDocTypeSource(docType)

# genDocTypesSources()
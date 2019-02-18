import sugar, sequtils, strutils, logging, tables, times, streams, os, ospaths,
    common, vektorjson, formatting, utils, jsondoctypes

const
    cGeneratedSourcesDir = "generated"

proc quoteStr(value: string): string =
    "\"$#\"" % value

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
    "        newLeType($#, $#, $#, $#, $#, $#, $#, $#, $#, $#, $#)" % [
        quoteStr(leType.lineElementId),
        quoteStr(leType.code),
        quoteStr(leType.fieldType)|L(4),
        intToStr(leType.startPosition)|R(3),
        intToStr(leType.length)|R(3),
        quoteStr(leType.countable)|L(6),
        quoteStr(leType.sourceId)|L(6),
        quoteStr(leType.slaveId)|L(6),
        boolToStr(leType.required)|L(6),
        $(leType.valueType)|L(24),
        quoteStr(leType.description)
    ]

proc genCreateLineElementTypes(lType: LineType): string =
    join(lc[genCreateLineElementType(item) | (item <- lType.lineElementTypes), string], ",\n")

proc genCreateLink(link: LineTypeLink): string =
    let multiple: bool = (link.cardinality == ToMany)
    "createLink($#, $#, $#)" % [quoteStr(link.subLineId), boolToStr(multiple), boolToStr(link.required)]

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
   let hasDependentEls = ltype.lineElementTypes.anyIt(it.sourceId != "")
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
import strutils, sequtils, common, factory

# $#.nim
# Generated: $#

$#
$#
"""

proc genCreateDocTypeCode*(docType: DocumentType): string =
    let date = format(now(), "d MMMM yyyy HH:mm:ss")
    fullDocTypeCodeTemplate % [docType.ext, date, genCreateLineTypesFunction(docType), genCreateDocTypeFunction(docType)]


proc createDocTypeSource*(docType: DocumentType) =
    echo "Create source: $#" % (if isNil(docType): "nil" else: docType.name)
    if not isNil(docType):
        let fileName = "$#.nim" % docType.ext
        let parent = parentDir(getAppDir())
        let outDir = joinPath(parent, cGeneratedSourcesDir)
        discard existsOrCreateDir(outDir)
        let outputPath = joinPath(outDir, fileName)
        echo "Creating source file '$#'" % outputPath
        var outStream: Stream = newFileStream(outputPath, fmWrite)
        outStream.write(genCreateDocTypeCode(docType))
        close(outStream)
    else: discard

proc genDocTypesSources*() =
    readConfigurationFile()
    for docType in getAllDocumentTypes():
        createDocTypeSource(docType)

when isMainModule:
    genDocTypesSources()
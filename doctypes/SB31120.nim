import strutils, sequtils, common, factory

# SB31120.nim
# Generated: 7 November 2018 18:26:10

proc createLineTypeSB3112003(): LineType =
    let leTypes = @[
        newLeType("0301", "COD001", "N" ,   1,   2, nil   , nil   , nil   , false , NaturalValueType        , "KENMERK RECORD"),
        newLeType("0302", "NUM040", "N" ,   3,  12, nil   , nil   , nil   , false , NaturalValueType        , "IDENTIFICATIE DETAILRECORD"),
        newLeType("0303", "COD316", "AN",  15,  11, nil   , nil   , nil   , false , StringValueType         , "DEBITEURNUMMER"),
        newLeType("0304", "DAT264", "N" ,  26,   8, nil   , nil   , nil   , false , DateValueType           , "DATUM GEBOORTE DEBITEUR"),
        newLeType("0305", "COD446", "N" ,  34,   1, nil   , nil   , nil   , false , NaturalValueType        , "CODE GESLACHT DEBITEUR"),
        newLeType("0306", "COD700", "N" ,  35,   1, nil   , nil   , nil   , false , NaturalValueType        , "NAAMCODE/NAAMGEBRUIK (01)"),
        newLeType("0307", "NAM214", "AN",  36,  25, nil   , nil   , nil   , false , StringValueType         , "NAAM DEBITEUR (01)"),
        newLeType("0308", "NAM216", "AN",  61,  10, nil   , nil   , nil   , false , StringValueType         , "VOORVOEGSEL DEBITEUR (01)"),
        newLeType("0309", "COD701", "N" ,  71,   1, nil   , nil   , nil   , false , NaturalValueType        , "NAAMCODE/NAAMGEBRUIK (02)"),
        newLeType("0310", "NAM215", "AN",  72,  25, nil   , nil   , nil   , false , StringValueType         , "NAAM DEBITEUR (02)"),
        newLeType("0311", "NAM217", "AN",  97,  10, nil   , nil   , nil   , false , StringValueType         , "VOORVOEGSEL DEBITEUR (02)"),
        newLeType("0312", "NAM089", "AN", 107,   6, nil   , nil   , nil   , false , StringValueType         , "VOORLETTERS DEBITEUR"),
        newLeType("0313", "COD829", "N" , 113,   1, nil   , nil   , nil   , false , NaturalValueType        , "NAAMCODE/NAAMGEBRUIK (03)"),
        newLeType("0314", "COD843", "N" , 114,   2, nil   , nil   , nil   , false , NaturalValueType        , "TITULATUUR"),
        newLeType("0315", "NAM141", "AN", 116,  24, nil   , nil   , nil   , false , StringValueType         , "STRAATNAAM DEBITEUR"),
        newLeType("0316", "NUM098", "N" , 140,   5, nil   , nil   , nil   , false , NaturalValueType        , "HUISNUMMER (HUISADRES) DEBITEUR"),
        newLeType("0317", "NUM099", "AN", 145,   6, nil   , nil   , nil   , false , StringValueType         , "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR"),
        newLeType("0318", "COD312", "AN", 151,   6, nil   , nil   , nil   , false , StringValueType         , "POSTCODE (HUISADRES) DEBITEUR"),
        newLeType("0319", "COD434", "AN", 157,   9, nil   , nil   , nil   , false , StringValueType         , "POSTCODE BUITENLAND"),
        newLeType("0320", "NAM142", "AN", 166,  24, nil   , nil   , nil   , false , StringValueType         , "WOONPLAATSNAAM DEBITEUR"),
        newLeType("0321", "COD313", "AN", 190,   2, nil   , nil   , nil   , false , StringValueType         , "CODE LAND DEBITEUR"),
        newLeType("0322", "NUM364", "AN", 192,  15, nil   , nil   , nil   , false , StringValueType         , "TELEFOONNUMMER DEBITEUR"),
        newLeType("0323", "NUM092", "N" , 207,   3, nil   , nil   , nil   , false , NaturalValueType        , "LANDNUMMER TELEFOON (CODE LAND)"),
        newLeType("0324", "NAM221", "AN", 210,  50, nil   , nil   , nil   , false , StringValueType         , "E-MAILADRES DEBITEUR"),
        newLeType("0325", "NUM406", "AN", 260,  34, nil   , nil   , nil   , false , StringValueType         , "IBAN"),
        newLeType("0326", "COD819", "N" , 294,   2, nil   , nil   , nil   , false , NaturalValueType        , "SOORT RELATIE DEBITEUR"),
        newLeType("0327", "COD908", "AN", 296,   2, nil   , nil   , nil   , false , StringValueType         , "CODE INCASSO"),
        newLeType("0328", "NUM413", "N" , 298,   2, nil   , nil   , nil   , false , NaturalValueType        , "VERSIENUMMER DEBITEURRECORD"),
        newLeType("0329", "DAT320", "N" , 300,   8, nil   , nil   , nil   , false , DateValueType           , "MACHTIGINGSDATUM AUTOMATISCHE INCASSO"),
        newLeType("0330", "COD655", "AN", 308,   1, nil   , nil   , nil   , false , StringValueType         , "FACTURATIEVORM"),
        newLeType("0380", "TEC007", "AN", 309,   1, nil   , nil   , nil   , false , StringValueType         , "RESERVE")
    ]
    result = LineType(
       name: "DebiteurRecord",
       length: 310,
       lineId: "03",
       index: 3,
       childLinks: @[createLink("98", true, false)],
       lineElementTypes: leTypes,
       hasDependentElements: false
    )


proc createLineTypesSB31120(): seq[LineType] =
    @[
        createLineTypeSB3112003()
    ]




proc createDocTypeSB31120*(): DocumentType =
    let lineTypes = createLineTypesSB31120()
    DocumentType(
        name: "SB311",
        description: "DEBITEURRECORD bij DECLARATIEBERICHTEN",
        formatVersion: 2,
        formatSubVersion: 0,
        vektisEICode: 902,
        lineLength: 310,
        lineTypes: lineTypes
    )

    

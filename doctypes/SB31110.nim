import strutils, sequtils, common

proc createLineTypeSB3111003(): LineType =
    let leTypes = @[
        newLeType("0301", "COD001", "N", 1, 2, nil, nil, nil, false, "KENMERK RECORD"),
        newLeType("0302", "NUM040", "N", 3, 12, nil, nil, nil, false, "IDENTIFICATIE DETAILRECORD"),
        newLeType("0303", "COD316", "AN", 15, 11, nil, nil, nil, false, "DEBITEURNUMMER"),
        newLeType("0304", "DAT264", "N", 26, 8, nil, nil, nil, false, "DATUM GEBOORTE DEBITEUR"),
        newLeType("0305", "COD446", "N", 34, 1, nil, nil, nil, false, "CODE GESLACHT DEBITEUR"),
        newLeType("0306", "COD700", "N", 35, 1, nil, nil, nil, false, "NAAMCODE/NAAMGEBRUIK (01)"),
        newLeType("0307", "NAM214", "AN", 36, 25, nil, nil, nil, false, "NAAM DEBITEUR (01)"),
        newLeType("0308", "NAM216", "AN", 61, 10, nil, nil, nil, false, "VOORVOEGSEL DEBITEUR (01)"),
        newLeType("0309", "COD701", "N", 71, 1, nil, nil, nil, false, "NAAMCODE/NAAMGEBRUIK (02)"),
        newLeType("0310", "NAM215", "AN", 72, 25, nil, nil, nil, false, "NAAM DEBITEUR (02)"),
        newLeType("0311", "NAM217", "AN", 97, 10, nil, nil, nil, false, "VOORVOEGSEL DEBITEUR (02)"),
        newLeType("0312", "NAM089", "AN", 107, 6, nil, nil, nil, false, "VOORLETTERS DEBITEUR"),
        newLeType("0313", "COD829", "N", 113, 1, nil, nil, nil, false, "NAAMCODE/NAAMGEBRUIK (03)"),
        newLeType("0314", "COD843", "N", 114, 2, nil, nil, nil, false, "TITULATUUR"),
        newLeType("0315", "NAM141", "AN", 116, 24, nil, nil, nil, false, "STRAATNAAM DEBITEUR"),
        newLeType("0316", "NUM098", "N", 140, 5, nil, nil, nil, false, "HUISNUMMER (HUISADRES) DEBITEUR"),
        newLeType("0317", "NUM099", "AN", 145, 6, nil, nil, nil, false, "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR"),
        newLeType("0318", "COD312", "AN", 151, 6, nil, nil, nil, false, "POSTCODE (HUISADRES) DEBITEUR"),
        newLeType("0319", "COD434", "AN", 157, 9, nil, nil, nil, false, "POSTCODE BUITENLAND"),
        newLeType("0320", "NAM142", "AN", 166, 24, nil, nil, nil, false, "WOONPLAATSNAAM DEBITEUR"),
        newLeType("0321", "COD313", "AN", 190, 2, nil, nil, nil, false, "CODE LAND DEBITEUR"),
        newLeType("0322", "NUM364", "AN", 192, 15, nil, nil, nil, false, "TELEFOONNUMMER DEBITEUR"),
        newLeType("0323", "NUM092", "N", 207, 3, nil, nil, nil, false, "LANDNUMMER TELEFOON (CODE LAND)"),
        newLeType("0324", "NAM221", "AN", 210, 50, nil, nil, nil, false, "E-MAILADRES DEBITEUR"),
        newLeType("0325", "NUM406", "AN", 260, 34, nil, nil, nil, false, "IBAN"),
        newLeType("0326", "COD819", "N", 294, 2, nil, nil, nil, false, "SOORT RELATIE DEBITEUR"),
        newLeType("0327", "COD908", "AN", 296, 2, nil, nil, nil, false, "CODE INCASSO"),
        newLeType("0328", "NUM413", "N", 298, 2, nil, nil, nil, false, "VERSIENUMMER DEBITEURRECORD"),
        newLeType("0380", "TEC007", "AN", 300, 10, nil, nil, nil, false, "RESERVE")
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


proc createLineTypesSB31110(): seq[LineType] =
    @[
        createLineTypeSB3111003()
    ]




proc createDocTypeSB31110*(): DocumentType =
    let lineTypes = createLineTypesSB31110()
    DocumentType(
        name: "SB311",
        description: "DEBITEURRECORD bij DECLARATIEBERICHTEN",
        formatVersion: 1,
        formatSubVersion: 0,
        vektisEICode: 901,
        lineLength: 310,
        lineTypes: lineTypes
    )

    

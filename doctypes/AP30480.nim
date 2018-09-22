import strutils, sequtils, common

proc createLineTypeAP3048001(): LineType =
    let leTypes = @[
        newLeType("0101", "COD001", "N", 1, 2, nil, nil, nil, true, "KENMERK RECORD"),
        newLeType("0102", "COD002", "N", 3, 3, nil, nil, nil, true, "CODE EXTERNE-INTEGRATIEBERICHT"),
        newLeType("0103", "NUM001", "N", 6, 2, nil, nil, nil, true, "VERSIENUMMER BERICHTSTANDAARD"),
        newLeType("0104", "NUM309", "N", 8, 2, nil, nil, nil, false, "SUBVERSIENUMMER BERICHTSTANDAARD"),
        newLeType("0105", "COD856", "AN", 10, 1, nil, nil, nil, true, "SOORT BERICHT"),
        newLeType("0106", "COD805", "N", 11, 6, nil, nil, nil, false, "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER"),
        newLeType("0107", "NUM284", "AN", 17, 10, nil, nil, nil, false, "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER"),
        newLeType("0108", "COD061", "N", 27, 4, nil, nil, nil, false, "UZOVI-NUMMER"),
        newLeType("0109", "COD377", "N", 31, 8, nil, nil, nil, false, "CODE SERVICEBUREAU"),
        newLeType("0110", "COD009", "N", 39, 8, nil, nil, nil, false, "ZORGVERLENERSCODE"),
        newLeType("0111", "COD181", "N", 47, 8, nil, nil, nil, false, "PRAKTIJKCODE"),
        newLeType("0112", "COD031", "N", 55, 8, nil, nil, nil, false, "INSTELLINGSCODE"),
        newLeType("0113", "COD833", "N", 63, 2, nil, nil, nil, true, "IDENTIFICATIECODE BETALING AAN"),
        newLeType("0114", "DAT043", "N", 65, 8, nil, nil, nil, true, "BEGINDATUM DECLARATIEPERIODE"),
        newLeType("0115", "DAT044", "N", 73, 8, nil, nil, nil, true, "EINDDATUM DECLARATIEPERIODE"),
        newLeType("0116", "NUM029", "AN", 81, 12, nil, nil, nil, true, "FACTUURNUMMER DECLARANT"),
        newLeType("0117", "DAT031", "N", 93, 8, nil, nil, nil, true, "DAGTEKENING FACTUUR"),
        newLeType("0118", "NUM351", "AN", 101, 14, nil, nil, nil, false, "BTW-IDENTIFICATIENUMMER"),
        newLeType("0119", "COD363", "AN", 115, 3, nil, nil, nil, true, "VALUTACODE"),
        newLeType("0180", "TEC007", "AN", 118, 243, nil, nil, nil, false, "RESERVE")
    ]
    result = LineType(
       name: "VoorloopRecord",
       length: 360,
       lineId: "01",
       index: 1,
       childLinks: @[createLink("02", false, true), createLink("99", false, true)],
       lineElementTypes: leTypes,
       hasDependentElements: false
    )

proc createLineTypeAP3048002(): LineType =
    let leTypes = @[
        newLeType("0201", "COD001", "N", 1, 2, nil, nil, nil, true, "KENMERK RECORD"),
        newLeType("0202", "NUM040", "N", 3, 12, nil, nil, nil, true, "IDENTIFICATIE DETAILRECORD"),
        newLeType("0203", "NUM313", "N", 15, 9, nil, nil, "0403", true, "BURGERSERVICENUMMER (BSN) VERZEKERDE"),
        newLeType("0204", "COD061", "N", 24, 4, nil, nil, "0404", true, "UZOVI-NUMMER"),
        newLeType("0205", "NUM003", "AN", 28, 15, nil, nil, "0405", false, "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)"),
        newLeType("0206", "NUM366", "AN", 43, 11, nil, nil, nil, false, "PATIENT(IDENTIFICATIE)NUMMER"),
        newLeType("0207", "DAT006", "N", 54, 8, nil, nil, nil, true, "DATUM GEBOORTE VERZEKERDE"),
        newLeType("0208", "COD134", "N", 62, 1, nil, nil, nil, true, "CODE GESLACHT VERZEKERDE"),
        newLeType("0209", "COD700", "N", 63, 1, nil, nil, nil, true, "NAAMCODE/NAAMGEBRUIK (01)"),
        newLeType("0210", "NAM193", "AN", 64, 25, nil, nil, nil, true, "NAAM VERZEKERDE (01)"),
        newLeType("0211", "NAM194", "AN", 89, 10, nil, nil, nil, false, "VOORVOEGSEL VERZEKERDE (01)"),
        newLeType("0212", "COD701", "N", 99, 1, nil, nil, nil, false, "NAAMCODE/NAAMGEBRUIK (02)"),
        newLeType("0213", "NAM191", "AN", 100, 25, nil, nil, nil, false, "NAAM VERZEKERDE (02)"),
        newLeType("0214", "NAM192", "AN", 125, 10, nil, nil, nil, false, "VOORVOEGSEL VERZEKERDE (02)"),
        newLeType("0215", "NAM025", "AN", 135, 6, nil, nil, nil, true, "VOORLETTERS VERZEKERDE"),
        newLeType("0216", "COD829", "N", 141, 1, nil, nil, nil, false, "NAAMCODE/NAAMGEBRUIK (03)"),
        newLeType("0217", "COD083", "AN", 142, 6, nil, nil, nil, false, "POSTCODE (HUISADRES) VERZEKERDE"),
        newLeType("0218", "COD434", "AN", 148, 9, nil, nil, nil, false, "POSTCODE BUITENLAND"),
        newLeType("0219", "NUM030", "N", 157, 5, nil, nil, nil, false, "HUISNUMMER (HUISADRES) VERZEKERDE"),
        newLeType("0220", "NUM079", "AN", 162, 6, nil, nil, nil, false, "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE"),
        newLeType("0221", "COD090", "AN", 168, 2, nil, nil, nil, false, "CODE LAND VERZEKERDE"),
        newLeType("0222", "COD112", "AN", 170, 1, nil, nil, nil, true, "VERZEKERDENREGISTRATIE BIJ ZORGVERLENER"),
        newLeType("0223", "COD316", "AN", 171, 11, nil, nil, nil, false, "DEBITEURNUMMER"),
        newLeType("0224", "COD841", "N", 182, 1, nil, nil, nil, true, "INDICATIE CLIENT OVERLEDEN"),
        newLeType("0280", "TEC007", "AN", 183, 178, nil, nil, nil, false, "RESERVE")
    ]
    result = LineType(
       name: "VerzekerdenRecord",
       length: 360,
       lineId: "02",
       index: 2,
       childLinks: @[createLink("03", false, false), createLink("04", true, false), createLink("98", true, false)],
       lineElementTypes: leTypes,
       hasDependentElements: false
    )

proc createLineTypeAP3048003(): LineType =
    let leTypes = @[
        newLeType("0301", "COD001", "N", 1, 2, nil, nil, nil, true, "KENMERK RECORD"),
        newLeType("0302", "NUM040", "N", 3, 12, nil, nil, nil, true, "IDENTIFICATIE DETAILRECORD"),
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
        newLeType("0329", "FAM001", "N", 300, 8, nil, nil, nil, false, "MACHTIGINGSDATUM"),
        newLeType("0330", "FAM002", "AN", 308, 1, nil, nil, nil, false, "FACTURATIEVORM"),
        newLeType("0331", "FAM003", "AN", 309, 35, nil, nil, nil, false, "EXTRA ADRESREGEL"),
        newLeType("0380", "TEC007", "AN", 344, 16, nil, nil, nil, false, "RESERVE")
    ]
    result = LineType(
       name: "DebiteurRecord",
       length: 360,
       lineId: "03",
       index: 3,
       childLinks: @[createLink("98", true, false)],
       lineElementTypes: leTypes,
       hasDependentElements: false
    )

proc createLineTypeAP3048004(): LineType =
    let leTypes = @[
        newLeType("0401", "COD001", "N", 1, 2, nil, nil, nil, true, "KENMERK RECORD"),
        newLeType("0402", "NUM040", "N", 3, 12, nil, nil, nil, true, "IDENTIFICATIE DETAILRECORD"),
        newLeType("0403", "NUM313", "N", 15, 9, nil, "0203", nil, true, "BURGERSERVICENUMMER (BSN) VERZEKERDE"),
        newLeType("0404", "COD061", "N", 24, 4, nil, "0204", nil, true, "UZOVI-NUMMER"),
        newLeType("0405", "NUM003", "AN", 28, 15, nil, "0205", nil, false, "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)"),
        newLeType("0406", "NUM013", "AN", 43, 15, nil, nil, nil, false, "MACHTIGINGSNUMMER"),
        newLeType("0407", "COD150", "N", 58, 1, nil, nil, nil, true, "DOORSTUREN TOEGESTAAN"),
        newLeType("0408", "DAT006", "N", 59, 8, nil, nil, nil, true, "DATUM GEBOORTE VERZEKERDE"),
        newLeType("0409", "COD609", "AN", 67, 1, nil, nil, nil, true, "INDICATIE INFORMATIERECORD"),
        newLeType("0410", "DAT272", "N", 68, 8, nil, nil, nil, true, "DATUM PRESTATIE"),
        newLeType("0411", "DAT314", "N", 76, 4, nil, nil, nil, false, "TIJDSTIP PRESTATIE"),
        newLeType("0412", "NUM083", "AN", 80, 12, nil, nil, nil, false, "ZORGCONTRACTNUMMER"),
        newLeType("0413", "COD692", "N", 92, 3, nil, nil, nil, true, "AANDUIDING PRESTATIECODELIJST (01)"),
        newLeType("0414", "COD626", "N", 95, 14, nil, nil, nil, true, "PRESTATIECODE (01)"),
        newLeType("0415", "COD072", "AN", 109, 2, nil, nil, nil, false, "AFLEVERINGSEENHEID"),
        newLeType("0416", "ANT024", "N", 111, 9, nil, nil, nil, false, "GEMIDDELDE DAGDOSERING"),
        newLeType("0417", "ANT054", "N", 120, 9, nil, nil, nil, false, "AANTAL UITGEVOERDE PRESTATIES"),
        newLeType("0418", "COD089", "N", 129, 8, nil, nil, nil, true, "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER"),
        newLeType("0419", "COD952", "N", 137, 4, nil, nil, nil, false, "SPECIALISME BEHANDELAAR/UITVOERDER"),
        newLeType("0420", "COD512", "N", 141, 8, nil, nil, nil, false, "PRAKTIJKCODE BEHANDELAAR/UITVOERDER"),
        newLeType("0421", "COD836", "N", 149, 8, nil, nil, nil, false, "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER"),
        newLeType("0422", "COD953", "N", 157, 4, nil, nil, nil, false, "SPECIALISME VOORSCHRIJVER/VERWIJZER"),
        newLeType("0423", "COD339", "N", 161, 8, nil, nil, nil, false, "INSTELLINGSCODE VOORSCHRIJVER/VERWIJZER"),
        newLeType("0424", "NUM038", "N", 169, 12, nil, nil, nil, false, "RECEPTNUMMER"),
        newLeType("0425", "NUM039", "N", 181, 2, nil, nil, nil, false, "RECEPTVOORSCHRIFT, VOLGNUMMER"),
        newLeType("0426", "NUM409", "AN", 183, 20, nil, nil, nil, true, "PRESTATIEKOPPELNUMMER"),
        newLeType("0427", "COD677", "N", 203, 3, nil, nil, nil, false, "AANDUIDING PRESTATIECODELIJST (02)"),
        newLeType("0428", "COD678", "N", 206, 12, nil, nil, nil, false, "PRESTATIECODE (02)"),
        newLeType("0429", "COD114", "N", 218, 1, nil, nil, nil, true, "INDICATIE SOORT RECEPTUUR"),
        newLeType("0430", "COD526", "N", 219, 1, nil, nil, nil, true, "WMG-SYSTEMATIEK PRIJS MIDDELEN"),
        newLeType("0431", "COD116", "N", 220, 1, nil, nil, nil, false, "VOORGESCHREVEN DOSERING (BEKEND)"),
        newLeType("0432", "COD450", "N", 221, 2, nil, nil, nil, false, "TOELICHTING DECLARATIEPOST MIDDEL"),
        newLeType("0433", "NUM368", "AN", 223, 15, nil, nil, nil, false, "ZORGTRAJECTNUMMER"),
        newLeType("0434", "COD646", "AN", 238, 15, nil, nil, nil, false, "INDICATIE DUUR GENEESMIDDEL"),
        newLeType("0435", "BED214", "N", 253, 8, nil, nil, nil, false, "BEDRAG BEREKENDE GVS-BIJDRAGE"),
        newLeType("0436", "COD980", "N", 261, 1, nil, nil, nil, true, "INDICATIE GVS-BIJDRAGE OPGENOMEN IN DECLARATIEBEDRAG"),
        newLeType("0437", "BED213", "N", 262, 8, nil, nil, nil, false, "DECLARATIEBEDRAG EXCL GVS-BIJDRAGE EN EXCL.BTW"),
        newLeType("0438", "BED160", "N", 270, 8, nil, nil, nil, false, "TARIEF PRESTATIE (INCL. BTW)"),
        newLeType("0439", "BED153", "N", 278, 8, nil, nil, nil, false, "BEREKEND BEDRAG (INCL. BTW)"),
        newLeType("0440", "COD668", "AN", 286, 1, nil, nil, nil, true, "INDICATIE DEBET/CREDIT (01)"),
        newLeType("0441", "NUM352", "N", 287, 4, nil, nil, nil, false, "BTW-PERCENTAGE DECLARATIEBEDRAG"),
        newLeType("0442", "BED079", "N", 291, 8, nil, nil, nil, false, "BTW BEDRAG OP DETAILNIVEAU"),
        newLeType("0443", "BED161", "N", 299, 8, nil, nil, nil, false, "DECLARATIEBEDRAG (INCL. BTW)"),
        newLeType("0444", "COD665", "AN", 307, 1, nil, nil, nil, true, "INDICATIE DEBET/CREDIT (02)"),
        newLeType("0445", "NUM362", "AN", 308, 20, nil, nil, nil, true, "REFERENTIENUMMER DIT PRESTATIERECORD"),
        newLeType("0446", "NUM363", "AN", 328, 20, nil, nil, nil, false, "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD"),
        newLeType("0480", "TEC007", "AN", 348, 13, nil, nil, nil, false, "RESERVE")
    ]
    result = LineType(
       name: "PrestatieRecord",
       length: 360,
       lineId: "04",
       index: 4,
       childLinks: @[createLink("98", true, false)],
       lineElementTypes: leTypes,
       hasDependentElements: true
    )

proc createLineTypeAP3048098(): LineType =
    let leTypes = @[
        newLeType("9801", "COD001", "N", 1, 2, nil, nil, nil, true, "KENMERK RECORD"),
        newLeType("9802", "NUM040", "N", 3, 12, nil, nil, nil, true, "IDENTIFICATIE DETAILRECORD"),
        newLeType("9803", "NUM109", "N", 15, 4, nil, nil, nil, true, "REGELNUMMER VRIJE TEKST"),
        newLeType("9804", "OMS016", "AN", 19, 140, nil, nil, nil, true, "VRIJE TEKST"),
        newLeType("9880", "TEC007", "AN", 159, 202, nil, nil, nil, false, "RESERVE")
    ]
    result = LineType(
       name: "CommentaarRecord",
       length: 360,
       lineId: "98",
       index: 98,
       childLinks: @[],
       lineElementTypes: leTypes,
       hasDependentElements: false
    )

proc createLineTypeAP3048099(): LineType =
    let leTypes = @[
        newLeType("9901", "COD001", "N", 1, 2, nil, nil, nil, true, "KENMERK RECORD"),
        newLeType("9902", "ANT085", "N", 3, 6, nil, nil, nil, true, "AANTAL VERZEKERDENRECORDS"),
        newLeType("9903", "ANT086", "N", 9, 6, nil, nil, nil, false, "AANTAL DEBITEURRECORDS"),
        newLeType("9904", "ANT087", "N", 15, 6, nil, nil, nil, true, "AANTAL PRESTATIERECORDS"),
        newLeType("9905", "ANT089", "N", 21, 6, nil, nil, nil, false, "AANTAL COMMENTAARRECORDS"),
        newLeType("9906", "ANT265", "N", 27, 7, nil, nil, nil, true, "TOTAAL AANTAL DETAILRECORDS"),
        newLeType("9907", "BED025", "N", 34, 11, nil, nil, nil, false, "TOTAAL DECLARATIEBEDRAG"),
        newLeType("9908", "COD043", "AN", 45, 1, nil, nil, nil, true, "INDICATIE DEBET/CREDIT"),
        newLeType("9980", "TEC007", "AN", 46, 315, nil, nil, nil, false, "RESERVE")
    ]
    result = LineType(
       name: "SluitRecord",
       length: 360,
       lineId: "99",
       index: 99,
       childLinks: @[],
       lineElementTypes: leTypes,
       hasDependentElements: false
    )


proc createLineTypesAP30480(): seq[LineType] =
    @[
        createLineTypeAP3048001(),
        createLineTypeAP3048002(),
        createLineTypeAP3048003(),
        createLineTypeAP3048004(),
        createLineTypeAP3048098(),
        createLineTypeAP3048099()
    ]




proc createDocTypeAP30480*(): DocumentType =
    let lineTypes = createLineTypesAP30480()
    DocumentType(
        name: "AP304",
        description: "DECLARATIE FARMACEUTISCHE HULP",
        formatVersion: 8,
        formatSubVersion: 0,
        vektisEICode: 193,
        lineLength: 360,
        lineTypes: lineTypes
    )

    

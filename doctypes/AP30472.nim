import strutils, sequtils, common, factory

# AP30472.nim
# Generated: 7 November 2018 18:26:10

proc createLineTypeAP3047201(): LineType =
    let leTypes = @[
        newLeType("0101", "COD001", "N" ,   1,   2, nil   , nil   , nil   , true  , NaturalValueType        , "KENMERK RECORD"),
        newLeType("0102", "COD002", "N" ,   3,   3, nil   , nil   , nil   , true  , NaturalValueType        , "CODE EXTERNE-INTEGRATIEBERICHT"),
        newLeType("0103", "NUM001", "N" ,   6,   2, nil   , nil   , nil   , true  , NaturalValueType        , "VERSIENUMMER BERICHTSTANDAARD"),
        newLeType("0104", "NUM309", "N" ,   8,   2, nil   , nil   , nil   , false , NaturalValueType        , "SUBVERSIENUMMER BERICHTSTANDAARD"),
        newLeType("0105", "COD856", "AN",  10,   1, nil   , nil   , nil   , true  , StringValueType         , "SOORT BERICHT"),
        newLeType("0106", "COD805", "N" ,  11,   6, nil   , nil   , nil   , false , NaturalValueType        , "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER"),
        newLeType("0107", "NUM284", "AN",  17,  10, nil   , nil   , nil   , false , StringValueType         , "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER"),
        newLeType("0108", "COD061", "N" ,  27,   4, nil   , nil   , nil   , false , NaturalValueType        , "UZOVI-NUMMER"),
        newLeType("0109", "COD377", "N" ,  31,   8, nil   , nil   , nil   , false , NaturalValueType        , "CODE SERVICEBUREAU"),
        newLeType("0110", "COD009", "N" ,  39,   8, nil   , nil   , nil   , false , NaturalValueType        , "ZORGVERLENERSCODE"),
        newLeType("0111", "COD181", "N" ,  47,   8, nil   , nil   , nil   , false , NaturalValueType        , "PRAKTIJKCODE"),
        newLeType("0112", "COD031", "N" ,  55,   8, nil   , nil   , nil   , false , NaturalValueType        , "INSTELLINGSCODE"),
        newLeType("0113", "COD833", "N" ,  63,   2, nil   , nil   , nil   , true  , NaturalValueType        , "IDENTIFICATIECODE BETALING AAN"),
        newLeType("0114", "DAT043", "N" ,  65,   8, nil   , nil   , nil   , true  , DateValueType           , "BEGINDATUM DECLARATIEPERIODE"),
        newLeType("0115", "DAT044", "N" ,  73,   8, nil   , nil   , nil   , true  , DateValueType           , "EINDDATUM DECLARATIEPERIODE"),
        newLeType("0116", "NUM029", "AN",  81,  12, nil   , nil   , nil   , true  , StringValueType         , "FACTUURNUMMER DECLARANT"),
        newLeType("0117", "DAT031", "N" ,  93,   8, nil   , nil   , nil   , true  , DateValueType           , "DAGTEKENING FACTUUR"),
        newLeType("0118", "NUM351", "AN", 101,  14, nil   , nil   , nil   , false , StringValueType         , "BTW-IDENTIFICATIENUMMER"),
        newLeType("0119", "COD363", "AN", 115,   3, nil   , nil   , nil   , true  , StringValueType         , "VALUTACODE"),
        newLeType("0180", "TEC007", "AN", 118, 193, nil   , nil   , nil   , false , StringValueType         , "RESERVE")
    ]
    result = LineType(
       name: "VoorloopRecord",
       length: 310,
       lineId: "01",
       index: 1,
       childLinks: @[createLink("02", true, true), createLink("99", false, true)],
       lineElementTypes: leTypes,
       hasDependentElements: false
    )

proc createLineTypeAP3047202(): LineType =
    let leTypes = @[
        newLeType("0201", "COD001", "N" ,   1,   2, nil   , nil   , nil   , true  , NaturalValueType        , "KENMERK RECORD"),
        newLeType("0202", "NUM040", "N" ,   3,  12, nil   , nil   , nil   , true  , NaturalValueType        , "IDENTIFICATIE DETAILRECORD"),
        newLeType("0203", "NUM313", "N" ,  15,   9, nil   , nil   , "0403", true  , NaturalValueType        , "BURGERSERVICENUMMER (BSN) VERZEKERDE"),
        newLeType("0204", "COD061", "N" ,  24,   4, nil   , nil   , "0404", true  , NaturalValueType        , "UZOVI-NUMMER"),
        newLeType("0205", "NUM003", "AN",  28,  15, nil   , nil   , "0405", false , StringValueType         , "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)"),
        newLeType("0206", "NUM366", "AN",  43,  11, nil   , nil   , nil   , false , StringValueType         , "PATIENT(IDENTIFICATIE)NUMMER"),
        newLeType("0207", "DAT006", "N" ,  54,   8, nil   , nil   , nil   , false , DateValueType           , "DATUM GEBOORTE VERZEKERDE"),
        newLeType("0208", "COD134", "N" ,  62,   1, nil   , nil   , nil   , false , NaturalValueType        , "CODE GESLACHT VERZEKERDE"),
        newLeType("0209", "COD700", "N" ,  63,   1, nil   , nil   , nil   , false , NaturalValueType        , "NAAMCODE/NAAMGEBRUIK (01)"),
        newLeType("0210", "NAM193", "AN",  64,  25, nil   , nil   , nil   , false , StringValueType         , "NAAM VERZEKERDE (01)"),
        newLeType("0211", "NAM194", "AN",  89,  10, nil   , nil   , nil   , false , StringValueType         , "VOORVOEGSEL VERZEKERDE (01)"),
        newLeType("0212", "COD701", "N" ,  99,   1, nil   , nil   , nil   , false , NaturalValueType        , "NAAMCODE/NAAMGEBRUIK (02)"),
        newLeType("0213", "NAM191", "AN", 100,  25, nil   , nil   , nil   , false , StringValueType         , "NAAM VERZEKERDE (02)"),
        newLeType("0214", "NAM192", "AN", 125,  10, nil   , nil   , nil   , false , StringValueType         , "VOORVOEGSEL VERZEKERDE (02)"),
        newLeType("0215", "NAM025", "AN", 135,   6, nil   , nil   , nil   , true  , StringValueType         , "VOORLETTERS VERZEKERDE"),
        newLeType("0216", "COD829", "N" , 141,   1, nil   , nil   , nil   , false , NaturalValueType        , "NAAMCODE/NAAMGEBRUIK (03)"),
        newLeType("0217", "COD083", "AN", 142,   6, nil   , nil   , nil   , false , StringValueType         , "POSTCODE (HUISADRES) VERZEKERDE"),
        newLeType("0218", "COD434", "AN", 148,   9, nil   , nil   , nil   , false , StringValueType         , "POSTCODE BUITENLAND"),
        newLeType("0219", "NUM030", "N" , 157,   5, nil   , nil   , nil   , true  , NaturalValueType        , "HUISNUMMER (HUISADRES) VERZEKERDE"),
        newLeType("0220", "NUM079", "AN", 162,   6, nil   , nil   , nil   , false , StringValueType         , "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE"),
        newLeType("0221", "COD090", "AN", 168,   2, nil   , nil   , nil   , false , StringValueType         , "CODE LAND VERZEKERDE"),
        newLeType("0222", "COD112", "AN", 170,   1, nil   , nil   , nil   , true  , StringValueType         , "VERZEKERDENREGISTRATIE BIJ ZORGVERLENER"),
        newLeType("0223", "COD316", "AN", 171,  11, nil   , nil   , nil   , false , StringValueType         , "DEBITEURNUMMER"),
        newLeType("0224", "COD841", "N" , 182,   1, nil   , nil   , nil   , true  , NaturalValueType        , "INDICATIE CLIENT OVERLEDEN"),
        newLeType("0280", "TEC007", "AN", 183, 128, nil   , nil   , nil   , false , StringValueType         , "RESERVE")
    ]
    result = LineType(
       name: "VerzekerdenRecord",
       length: 310,
       lineId: "02",
       index: 2,
       childLinks: @[createLink("03", false, false), createLink("04", true, true), createLink("98", true, false)],
       lineElementTypes: leTypes,
       hasDependentElements: false
    )

proc createLineTypeAP3047203(): LineType =
    let leTypes = @[
        newLeType("0301", "COD001", "N" ,   1,   2, nil   , nil   , nil   , true  , NaturalValueType        , "KENMERK RECORD"),
        newLeType("0302", "NUM040", "N" ,   3,  12, nil   , nil   , nil   , true  , NaturalValueType        , "IDENTIFICATIE DETAILRECORD"),
        newLeType("0303", "COD316", "AN",  15,  11, nil   , nil   , nil   , false , StringValueType         , "DEBITEURNUMMER"),
        newLeType("0304", "DAT264", "N" ,  26,   8, nil   , nil   , nil   , false , DateValueType           , "DATUM GEBOORTE DEBITEUR"),
        newLeType("0305", "COD446", "N" ,  34,   1, nil   , nil   , nil   , false , NaturalValueType        , "CODE GESLACHT DEBITEUR"),
        newLeType("0306", "COD700", "N" ,  35,   1, nil   , nil   , nil   , false , NaturalValueType        , "NAAMCODE/NAAMGEBRUIK (01)"),
        newLeType("0307", "NAM214", "AN",  36,  25, nil   , nil   , nil   , true  , StringValueType         , "NAAM DEBITEUR (01)"),
        newLeType("0308", "NAM216", "AN",  61,  10, nil   , nil   , nil   , false , StringValueType         , "VOORVOEGSEL DEBITEUR (01)"),
        newLeType("0309", "COD701", "N" ,  71,   1, nil   , nil   , nil   , false , NaturalValueType        , "NAAMCODE/NAAMGEBRUIK (02)"),
        newLeType("0310", "NAM215", "AN",  72,  25, nil   , nil   , nil   , false , StringValueType         , "NAAM DEBITEUR (02)"),
        newLeType("0311", "NAM217", "AN",  97,  10, nil   , nil   , nil   , false , StringValueType         , "VOORVOEGSEL DEBITEUR (02)"),
        newLeType("0312", "NAM089", "AN", 107,   6, nil   , nil   , nil   , true  , StringValueType         , "VOORLETTERS DEBITEUR"),
        newLeType("0313", "COD829", "N" , 113,   1, nil   , nil   , nil   , false , NaturalValueType        , "NAAMCODE/NAAMGEBRUIK (03)"),
        newLeType("0314", "COD843", "N" , 114,   2, nil   , nil   , nil   , false , NaturalValueType        , "TITULATUUR"),
        newLeType("0315", "NAM141", "AN", 116,  24, nil   , nil   , nil   , false , StringValueType         , "STRAATNAAM DEBITEUR"),
        newLeType("0316", "NUM098", "N" , 140,   5, nil   , nil   , nil   , true  , NaturalValueType        , "HUISNUMMER (HUISADRES) DEBITEUR"),
        newLeType("0317", "NUM099", "AN", 145,   6, nil   , nil   , nil   , false , StringValueType         , "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR"),
        newLeType("0318", "COD312", "AN", 151,   6, nil   , nil   , nil   , false , StringValueType         , "POSTCODE (HUISADRES) DEBITEUR"),
        newLeType("0319", "COD434", "AN", 157,   9, nil   , nil   , nil   , false , StringValueType         , "POSTCODE BUITENLAND"),
        newLeType("0320", "NAM142", "AN", 166,  24, nil   , nil   , nil   , false , StringValueType         , "WOONPLAATSNAAM DEBITEUR"),
        newLeType("0321", "COD313", "AN", 190,   2, nil   , nil   , nil   , false , StringValueType         , "CODE LAND DEBITEUR"),
        newLeType("0322", "NUM364", "AN", 192,  15, nil   , nil   , nil   , false , StringValueType         , "TELEFOONNUMMER DEBITEUR"),
        newLeType("0323", "NUM092", "N" , 207,   3, nil   , nil   , nil   , false , NaturalValueType        , "LANDNUMMER TELEFOON (CODE LAND)"),
        newLeType("0324", "NAM221", "AN", 210,  70, nil   , nil   , nil   , false , StringValueType         , "E-MAILADRES DEBITEUR"),
        newLeType("0325", "NUM008", "N" , 280,  16, nil   , nil   , nil   , false , NaturalValueType        , "BANKREKENINGNUMMER"),
        newLeType("0326", "COD819", "N" , 296,   2, nil   , nil   , nil   , false , NaturalValueType        , "SOORT RELATIE DEBITEUR"),
        newLeType("0380", "TEC007", "AN", 298,  12, nil   , nil   , nil   , false , StringValueType         , "RESERVE")
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

proc createLineTypeAP3047204(): LineType =
    let leTypes = @[
        newLeType("0401", "COD001", "N" ,   1,   2, nil   , nil   , nil   , true  , NaturalValueType        , "KENMERK RECORD"),
        newLeType("0402", "NUM040", "N" ,   3,  12, nil   , nil   , nil   , true  , NaturalValueType        , "IDENTIFICATIE DETAILRECORD"),
        newLeType("0403", "NUM313", "N" ,  15,   9, nil   , "0203", nil   , true  , NaturalValueType        , "BURGERSERVICENUMMER (BSN) VERZEKERDE"),
        newLeType("0404", "COD061", "N" ,  24,   4, nil   , "0204", nil   , true  , NaturalValueType        , "UZOVI-NUMMER"),
        newLeType("0405", "NUM003", "AN",  28,  15, nil   , "0205", nil   , false , StringValueType         , "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)"),
        newLeType("0406", "NUM013", "AN",  43,  15, nil   , nil   , nil   , false , StringValueType         , "MACHTIGINGSNUMMER"),
        newLeType("0407", "COD820", "N" ,  58,   1, nil   , nil   , nil   , true  , NaturalValueType        , "DOORSTUREN TOEGESTAAN"),
        newLeType("0408", "COD181", "N" ,  59,   8, nil   , nil   , nil   , false , NaturalValueType        , "PRAKTIJKCODE"),
        newLeType("0409", "DAT272", "N" ,  67,   8, nil   , nil   , nil   , true  , DateValueType           , "DATUM PRESTATIE"),
        newLeType("0410", "COD367", "N" ,  75,   3, nil   , nil   , nil   , true  , NaturalValueType        , "AANDUIDING PRESTATIECODELIJST"),
        newLeType("0411", "COD388", "N" ,  78,  12, nil   , nil   , nil   , true  , NaturalValueType        , "PRESTATIECODE"),
        newLeType("0412", "COD072", "AN",  90,   2, nil   , nil   , nil   , true  , StringValueType         , "AFLEVERINGSEENHEID"),
        newLeType("0413", "ANT024", "N" ,  92,   9, nil   , nil   , nil   , false , NaturalValueType        , "GEMIDDELDE DAGDOSERING"),
        newLeType("0414", "ANT025", "N" , 101,   9, nil   , nil   , nil   , true  , NaturalValueType        , "HOEVEELHEID AFGELEVERD MIDDEL"),
        newLeType("0415", "COD978", "N" , 110,   8, nil   , nil   , nil   , false , NaturalValueType        , "WMG-TARIEFCODE MODULAIRE TARIEFSTRUCTUUR FARMACEUTISCHE HULP"),
        newLeType("0416", "COD089", "N" , 118,   8, nil   , nil   , nil   , true  , NaturalValueType        , "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER"),
        newLeType("0417", "COD952", "N" , 126,   4, nil   , nil   , nil   , false , NaturalValueType        , "SPECIALISME BEHANDELAAR/UITVOERDER"),
        newLeType("0418", "COD836", "N" , 130,   8, nil   , nil   , nil   , true  , NaturalValueType        , "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER"),
        newLeType("0419", "COD953", "N" , 138,   4, nil   , nil   , nil   , false , NaturalValueType        , "SPECIALISME VOORSCHRIJVER/VERWIJZER"),
        newLeType("0420", "NUM038", "N" , 142,   8, nil   , nil   , nil   , true  , NaturalValueType        , "RECEPTNUMMER"),
        newLeType("0421", "NUM039", "N" , 150,   2, nil   , nil   , nil   , true  , NaturalValueType        , "RECEPTVOORSCHRIFT, VOLGNUMMER"),
        newLeType("0422", "COD412", "N" , 152,   2, nil   , nil   , nil   , false , NaturalValueType        , "AANDUIDING SPECIFICATIE HULPMIDDEL"),
        newLeType("0423", "COD413", "N" , 154,  12, nil   , nil   , nil   , false , NaturalValueType        , "SPECIFICATIE HULPMIDDEL"),
        newLeType("0424", "COD114", "N" , 166,   1, nil   , nil   , nil   , true  , NaturalValueType        , "INDICATIE SOORT RECEPTUUR"),
        newLeType("0425", "COD979", "N" , 167,   1, nil   , nil   , nil   , true  , NaturalValueType        , "INDICATIE WMG"),
        newLeType("0426", "COD116", "N" , 168,   1, nil   , nil   , nil   , false , NaturalValueType        , "VOORGESCHREVEN DOSERING (BEKEND)"),
        newLeType("0427", "COD450", "N" , 169,   2, nil   , nil   , nil   , false , NaturalValueType        , "TOELICHTING DECLARATIEPOST MIDDEL"),
        newLeType("0428", "BED172", "N" , 171,   8, nil   , nil   , nil   , false , UnsignedAmountValueType , "WMG-TARIEFCODEBEDRAG (EXCL. BTW)"),
        newLeType("0429", "BED174", "N" , 179,   8, nil   , nil   , nil   , false , UnsignedAmountValueType , "BEDRAG BEREKENDE EIGEN BIJDRAGE"),
        newLeType("0430", "COD980", "N" , 187,   1, nil   , nil   , nil   , true  , NaturalValueType        , "INDICATIE GVS-BIJDRAGE OPGENOMEN IN DECLARATIEBEDRAG"),
        newLeType("0431", "BED173", "N" , 188,   8, nil   , nil   , nil   , false , UnsignedAmountValueType , "VERGOEDINGSBEDRAG MIDDELEN (EXCL. WMG, GVS, BTW; INCL AFTREK CLAWBACK)"),
        newLeType("0432", "BED176", "N" , 196,   8, nil   , nil   , nil   , false , UnsignedAmountValueType , "TARIEF PRESTATIE (EXCL. BTW)"),
        newLeType("0433", "BED153", "N" , 204,   9, nil   , nil   , nil   , false , SignedAmountValueType   , "BEREKEND BEDRAG (INCL. BTW)"),
        newLeType("0435", "NUM352", "N" , 213,   4, nil   , nil   , nil   , false , NaturalValueType        , "BTW-PERCENTAGE DECLARATIEBEDRAG"),
        newLeType("0436", "BED079", "N" , 217,   8, nil   , nil   , nil   , false , UnsignedAmountValueType , "BTW BEDRAG OP DETAILNIVEAU"),
        newLeType("0437", "BED161", "N" , 225,   9, nil   , nil   , nil   , false , SignedAmountValueType   , "DECLARATIEBEDRAG (INCL. BTW)"),
        newLeType("0439", "NUM362", "AN", 234,  20, nil   , nil   , nil   , true  , StringValueType         , "REFERENTIENUMMER DIT PRESTATIERECORD"),
        newLeType("0440", "NUM363", "AN", 254,  20, nil   , nil   , nil   , false , StringValueType         , "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD"),
        newLeType("0480", "TEC007", "AN", 274,  37, nil   , nil   , nil   , false , StringValueType         , "RESERVE")
    ]
    result = LineType(
       name: "PrestatieRecord",
       length: 310,
       lineId: "04",
       index: 4,
       childLinks: @[createLink("98", true, false)],
       lineElementTypes: leTypes,
       hasDependentElements: true
    )

proc createLineTypeAP3047298(): LineType =
    let leTypes = @[
        newLeType("9801", "COD001", "N" ,   1,   2, nil   , nil   , nil   , true  , NaturalValueType        , "KENMERK RECORD"),
        newLeType("9802", "NUM040", "N" ,   3,  12, nil   , nil   , nil   , true  , NaturalValueType        , "IDENTIFICATIE DETAILRECORD"),
        newLeType("9803", "NUM109", "N" ,  15,   4, nil   , nil   , nil   , true  , NaturalValueType        , "REGELNUMMER VRIJE TEKST"),
        newLeType("9804", "OMS016", "AN",  19, 140, nil   , nil   , nil   , true  , StringValueType         , "VRIJE TEKST"),
        newLeType("9880", "TEC007", "AN", 159, 152, nil   , nil   , nil   , false , StringValueType         , "RESERVE")
    ]
    result = LineType(
       name: "CommentaarRecord",
       length: 310,
       lineId: "98",
       index: 98,
       childLinks: @[],
       lineElementTypes: leTypes,
       hasDependentElements: false
    )

proc createLineTypeAP3047299(): LineType =
    let leTypes = @[
        newLeType("9901", "COD001", "N" ,   1,   2, nil   , nil   , nil   , true  , NaturalValueType        , "KENMERK RECORD"),
        newLeType("9902", "ANT085", "N" ,   3,   6, "0200", nil   , nil   , true  , NaturalValueType        , "AANTAL VERZEKERDENRECORDS"),
        newLeType("9903", "ANT086", "N" ,   9,   6, "0300", nil   , nil   , false , NaturalValueType        , "AANTAL DEBITEURRECORDS"),
        newLeType("9904", "ANT087", "N" ,  15,   6, "0400", nil   , nil   , true  , NaturalValueType        , "AANTAL PRESTATIERECORDS"),
        newLeType("9905", "ANT089", "N" ,  21,   6, "9800", nil   , nil   , false , NaturalValueType        , "AANTAL COMMENTAARRECORDS"),
        newLeType("9906", "ANT265", "N" ,  27,   7, "0000", nil   , nil   , true  , NaturalValueType        , "TOTAAL AANTAL DETAILRECORDS"),
        newLeType("9907", "BED025", "N" ,  34,  12, "0437", nil   , nil   , false , SignedAmountValueType   , "TOTAAL DECLARATIEBEDRAG"),
        newLeType("9980", "TEC007", "AN",  46, 265, nil   , nil   , nil   , false , StringValueType         , "RESERVE")
    ]
    result = LineType(
       name: "SluitRecord",
       length: 310,
       lineId: "99",
       index: 99,
       childLinks: @[],
       lineElementTypes: leTypes,
       hasDependentElements: false
    )


proc createLineTypesAP30472(): seq[LineType] =
    @[
        createLineTypeAP3047201(),
        createLineTypeAP3047202(),
        createLineTypeAP3047203(),
        createLineTypeAP3047204(),
        createLineTypeAP3047298(),
        createLineTypeAP3047299()
    ]




proc createDocTypeAP30472*(): DocumentType =
    let lineTypes = createLineTypesAP30472()
    DocumentType(
        name: "AP304",
        description: "DECLARATIE FARMACEUTISCHE HULP",
        formatVersion: 7,
        formatSubVersion: 2,
        vektisEICode: 106,
        lineLength: 310,
        lineTypes: lineTypes
    )

    

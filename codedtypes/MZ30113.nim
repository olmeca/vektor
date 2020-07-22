import strutils, sequtils, common, factory

# MZ30113.nim
# Generated: 27 February 2019 19:33:12

proc createLineTypeMZ3011301(): LineType =
    let leTypes = @[
        newLeType("0101", "COD001", "N" ,   1,   2, ""    , ""    , ""    , true  , NaturalValueType        , "KENMERK RECORD"),
        newLeType("0102", "COD002", "N" ,   3,   3, ""    , ""    , ""    , true  , NaturalValueType        , "CODE EXTERNE-INTEGRATIEBERICHT"),
        newLeType("0103", "NUM001", "N" ,   6,   2, ""    , ""    , ""    , true  , NaturalValueType        , "VERSIENUMMER BERICHTSTANDAARD"),
        newLeType("0104", "NUM309", "N" ,   8,   2, ""    , ""    , ""    , false , NaturalValueType        , "SUBVERSIENUMMER BERICHTSTANDAARD"),
        newLeType("0105", "COD856", "AN",  10,   1, ""    , ""    , ""    , true  , StringValueType         , "SOORT BERICHT"),
        newLeType("0106", "COD805", "N" ,  11,   6, ""    , ""    , ""    , false , NaturalValueType        , "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER"),
        newLeType("0107", "NUM284", "AN",  17,  10, ""    , ""    , ""    , false , StringValueType         , "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER"),
        newLeType("0108", "COD061", "N" ,  27,   4, ""    , ""    , ""    , false , NaturalValueType        , "UZOVI-NUMMER"),
        newLeType("0109", "COD377", "N" ,  31,   8, ""    , ""    , ""    , false , NaturalValueType        , "CODE SERVICEBUREAU"),
        newLeType("0110", "COD009", "N" ,  39,   8, ""    , ""    , ""    , false , NaturalValueType        , "ZORGVERLENERSCODE"),
        newLeType("0111", "COD181", "N" ,  47,   8, ""    , ""    , ""    , false , NaturalValueType        , "PRAKTIJKCODE"),
        newLeType("0112", "COD031", "N" ,  55,   8, ""    , ""    , ""    , false , NaturalValueType        , "INSTELLINGSCODE"),
        newLeType("0113", "COD833", "N" ,  63,   2, ""    , ""    , ""    , true  , NaturalValueType        , "IDENTIFICATIECODE BETALING AAN"),
        newLeType("0114", "DAT043", "N" ,  65,   8, ""    , ""    , ""    , true  , DateValueType           , "BEGINDATUM DECLARATIEPERIODE"),
        newLeType("0115", "DAT044", "N" ,  73,   8, ""    , ""    , ""    , true  , DateValueType           , "EINDDATUM DECLARATIEPERIODE"),
        newLeType("0116", "NUM029", "AN",  81,  12, ""    , ""    , ""    , true  , StringValueType         , "FACTUURNUMMER DECLARANT"),
        newLeType("0117", "DAT031", "N" ,  93,   8, ""    , ""    , ""    , true  , DateValueType           , "DAGTEKENING FACTUUR"),
        newLeType("0118", "NUM351", "AN", 101,  14, ""    , ""    , ""    , false , StringValueType         , "BTW-IDENTIFICATIENUMMER"),
        newLeType("0119", "COD363", "AN", 115,   3, ""    , ""    , ""    , true  , StringValueType         , "VALUTACODE"),
        newLeType("0180", "TEC007", "AN", 118, 193, ""    , ""    , ""    , false , StringValueType         , "RESERVE")
    ]
    result = LineType(
       name: "VoorloopRecord",
       length: 310,
       lineId: "01",
       index: 1,
       childLinks: @[createLink("02", false, true), createLink("99", false, true)],
       lineElementTypes: leTypes,
       hasDependentElements: false
    )

proc createLineTypeMZ3011302(): LineType =
    let leTypes = @[
        newLeType("0201", "COD001", "N" ,   1,   2, ""    , ""    , ""    , true  , NaturalValueType        , "KENMERK RECORD"),
        newLeType("0202", "NUM040", "N" ,   3,  12, ""    , ""    , ""    , true  , NaturalValueType        , "IDENTIFICATIE DETAILRECORD"),
        newLeType("0203", "NUM313", "N" ,  15,   9, ""    , ""    , ""    , true  , NaturalValueType        , "BURGERSERVICENUMMER (BSN) VERZEKERDE"),
        newLeType("0204", "COD061", "N" ,  24,   4, ""    , ""    , ""    , true  , NaturalValueType        , "UZOVI-NUMMER"),
        newLeType("0205", "NUM003", "AN",  28,  15, ""    , ""    , ""    , false , StringValueType         , "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)"),
        newLeType("0206", "NUM366", "AN",  43,  11, ""    , ""    , ""    , false , StringValueType         , "PATIENT(IDENTIFICATIE)NUMMER"),
        newLeType("0207", "DAT006", "N" ,  54,   8, ""    , ""    , ""    , true  , DateValueType           , "DATUM GEBOORTE VERZEKERDE"),
        newLeType("0208", "COD134", "N" ,  62,   1, ""    , ""    , ""    , true  , NaturalValueType        , "CODE GESLACHT VERZEKERDE"),
        newLeType("0209", "COD700", "N" ,  63,   1, ""    , ""    , ""    , true  , NaturalValueType        , "NAAMCODE/NAAMGEBRUIK (01)"),
        newLeType("0210", "NAM193", "AN",  64,  25, ""    , ""    , ""    , true  , StringValueType         , "NAAM VERZEKERDE (01)"),
        newLeType("0211", "NAM194", "AN",  89,  10, ""    , ""    , ""    , false , StringValueType         , "VOORVOEGSEL VERZEKERDE (01)"),
        newLeType("0212", "COD701", "N" ,  99,   1, ""    , ""    , ""    , false , NaturalValueType        , "NAAMCODE/NAAMGEBRUIK (02)"),
        newLeType("0213", "NAM191", "AN", 100,  25, ""    , ""    , ""    , false , StringValueType         , "NAAM VERZEKERDE (02)"),
        newLeType("0214", "NAM192", "AN", 125,  10, ""    , ""    , ""    , false , StringValueType         , "VOORVOEGSEL VERZEKERDE (02)"),
        newLeType("0215", "NAM025", "AN", 135,   6, ""    , ""    , ""    , true  , StringValueType         , "VOORLETTERS VERZEKERDE"),
        newLeType("0216", "COD829", "N" , 141,   1, ""    , ""    , ""    , false , NaturalValueType        , "NAAMCODE/NAAMGEBRUIK (03)"),
        newLeType("0217", "COD083", "AN", 142,   6, ""    , ""    , ""    , false , StringValueType         , "POSTCODE (HUISADRES) VERZEKERDE"),
        newLeType("0218", "COD434", "AN", 148,   9, ""    , ""    , ""    , false , StringValueType         , "POSTCODE BUITENLAND"),
        newLeType("0219", "NUM030", "N" , 157,   5, ""    , ""    , ""    , true  , NaturalValueType        , "HUISNUMMER (HUISADRES) VERZEKERDE"),
        newLeType("0220", "NUM079", "AN", 162,   6, ""    , ""    , ""    , false , StringValueType         , "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE"),
        newLeType("0221", "COD090", "AN", 168,   2, ""    , ""    , ""    , false , StringValueType         , "CODE LAND VERZEKERDE"),
        newLeType("0222", "COD316", "AN", 170,  11, ""    , ""    , ""    , false , StringValueType         , "DEBITEURNUMMER"),
        newLeType("0223", "COD841", "N" , 181,   1, ""    , ""    , ""    , true  , NaturalValueType        , "INDICATIE CLIENT OVERLEDEN"),
        newLeType("0280", "TEC007", "AN", 182, 129, ""    , ""    , ""    , false , StringValueType         , "RESERVE")
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

proc createLineTypeMZ3011303(): LineType =
    let leTypes = @[
        newLeType("0301", "COD001", "N" ,   1,   2, ""    , ""    , ""    , false , NaturalValueType        , "KENMERK RECORD"),
        newLeType("0302", "NUM040", "N" ,   3,  12, ""    , ""    , ""    , false , NaturalValueType        , "IDENTIFICATIE DETAILRECORD"),
        newLeType("0303", "COD316", "AN",  15,  11, ""    , ""    , ""    , false , StringValueType         , "DEBITEURNUMMER"),
        newLeType("0304", "DAT264", "N" ,  26,   8, ""    , ""    , ""    , false , DateValueType           , "DATUM GEBOORTE DEBITEUR"),
        newLeType("0305", "COD446", "N" ,  34,   1, ""    , ""    , ""    , false , NaturalValueType        , "CODE GESLACHT DEBITEUR"),
        newLeType("0306", "COD700", "N" ,  35,   1, ""    , ""    , ""    , false , NaturalValueType        , "NAAMCODE/NAAMGEBRUIK (01)"),
        newLeType("0307", "NAM214", "AN",  36,  25, ""    , ""    , ""    , false , StringValueType         , "NAAM DEBITEUR (01)"),
        newLeType("0308", "NAM216", "AN",  61,  10, ""    , ""    , ""    , false , StringValueType         , "VOORVOEGSEL DEBITEUR (01)"),
        newLeType("0309", "COD701", "N" ,  71,   1, ""    , ""    , ""    , false , NaturalValueType        , "NAAMCODE/NAAMGEBRUIK (02)"),
        newLeType("0310", "NAM215", "AN",  72,  25, ""    , ""    , ""    , false , StringValueType         , "NAAM DEBITEUR (02)"),
        newLeType("0311", "NAM217", "AN",  97,  10, ""    , ""    , ""    , false , StringValueType         , "VOORVOEGSEL DEBITEUR (02)"),
        newLeType("0312", "NAM089", "AN", 107,   6, ""    , ""    , ""    , false , StringValueType         , "VOORLETTERS DEBITEUR"),
        newLeType("0313", "COD829", "N" , 113,   1, ""    , ""    , ""    , false , NaturalValueType        , "NAAMCODE/NAAMGEBRUIK (03)"),
        newLeType("0314", "COD843", "N" , 114,   2, ""    , ""    , ""    , false , NaturalValueType        , "TITULATUUR"),
        newLeType("0315", "NAM141", "AN", 116,  24, ""    , ""    , ""    , false , StringValueType         , "STRAATNAAM DEBITEUR"),
        newLeType("0316", "NUM098", "N" , 140,   5, ""    , ""    , ""    , false , NaturalValueType        , "HUISNUMMER (HUISADRES) DEBITEUR"),
        newLeType("0317", "NUM099", "AN", 145,   6, ""    , ""    , ""    , false , StringValueType         , "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR"),
        newLeType("0318", "COD312", "AN", 151,   6, ""    , ""    , ""    , false , StringValueType         , "POSTCODE (HUISADRES) DEBITEUR"),
        newLeType("0319", "COD434", "AN", 157,   9, ""    , ""    , ""    , false , StringValueType         , "POSTCODE BUITENLAND"),
        newLeType("0320", "NAM142", "AN", 166,  24, ""    , ""    , ""    , false , StringValueType         , "WOONPLAATSNAAM DEBITEUR"),
        newLeType("0321", "COD313", "AN", 190,   2, ""    , ""    , ""    , false , StringValueType         , "CODE LAND DEBITEUR"),
        newLeType("0322", "NUM364", "AN", 192,  15, ""    , ""    , ""    , false , StringValueType         , "TELEFOONNUMMER DEBITEUR"),
        newLeType("0323", "NUM092", "N" , 207,   3, ""    , ""    , ""    , false , NaturalValueType        , "LANDNUMMER TELEFOON (CODE LAND)"),
        newLeType("0324", "NAM221", "AN", 210,  70, ""    , ""    , ""    , false , StringValueType         , "E-MAILADRES DEBITEUR"),
        newLeType("0325", "NUM008", "N" , 280,  16, ""    , ""    , ""    , false , NaturalValueType        , "BANKREKENINGNUMMER"),
        newLeType("0326", "COD819", "N" , 296,   2, ""    , ""    , ""    , false , NaturalValueType        , "SOORT RELATIE DEBITEUR"),
        newLeType("0380", "TEC007", "AN", 298,  12, ""    , ""    , ""    , false , StringValueType         , "RESERVE")
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

proc createLineTypeMZ3011304(): LineType =
    let leTypes = @[
        newLeType("0401", "COD001", "N" ,   1,   2, ""    , ""    , ""    , true  , NaturalValueType        , "KENMERK RECORD"),
        newLeType("0402", "NUM040", "N" ,   3,  12, ""    , ""    , ""    , true  , NaturalValueType        , "IDENTIFICATIE DETAILRECORD"),
        newLeType("0403", "NUM313", "N" ,  15,   9, ""    , "0203", ""    , true  , NaturalValueType        , "BURGERSERVICENUMMER (BSN) VERZEKERDE"),
        newLeType("0404", "COD061", "N" ,  24,   4, ""    , "0204", ""    , true  , NaturalValueType        , "UZOVI-NUMMER"),
        newLeType("0405", "NUM003", "AN",  28,  15, ""    , "0205", ""    , false , StringValueType         , "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)"),
        newLeType("0406", "NUM013", "AN",  43,  15, ""    , ""    , ""    , false , StringValueType         , "MACHTIGINGSNUMMER"),
        newLeType("0407", "COD820", "N" ,  58,   1, ""    , ""    , ""    , true  , NaturalValueType        , "DOORSTUREN TOEGESTAAN"),
        newLeType("0408", "DAT272", "N" ,  59,   8, ""    , ""    , ""    , true  , DateValueType           , "DATUM PRESTATIE"),
        newLeType("0409", "COD853", "N" ,  67,   2, ""    , ""    , ""    , true  , NaturalValueType        , "INDICATIE SOORT PRESTATIERECORD"),
        newLeType("0410", "COD854", "AN",  69,   1, ""    , ""    , ""    , true  , StringValueType         , "INDICATIE BIJZONDERE TANDHEELKUNDE"),
        newLeType("0411", "COD859", "N" ,  70,   3, ""    , ""    , ""    , false , NaturalValueType        , "SOORT BIJZONDERE TANDHEELKUNDE"),
        newLeType("0412", "COD367", "N" ,  73,   3, ""    , ""    , ""    , true  , NaturalValueType        , "AANDUIDING PRESTATIECODELIJST"),
        newLeType("0413", "COD388", "AN",  76,   6, ""    , ""    , ""    , true  , StringValueType         , "PRESTATIECODE"),
        newLeType("0414", "COD176", "N" ,  82,   1, ""    , ""    , ""    , false , NaturalValueType        , "INDICATIE BOVEN/ONDER TANDHEELKUNDE"),
        newLeType("0415", "COD040", "N" ,  83,   2, ""    , ""    , ""    , false , NaturalValueType        , "GEBITSELEMENTCODE"),
        newLeType("0416", "COD041", "AN",  85,   6, ""    , ""    , ""    , false , StringValueType         , "VLAKCODE"),
        newLeType("0417", "COD392", "N" ,  91,   3, ""    , ""    , ""    , false , NaturalValueType        , "AANDUIDING DIAGNOSECODELIJST"),
        newLeType("0418", "COD852", "N" ,  94,   4, ""    , ""    , ""    , false , NaturalValueType        , "DIAGNOSECODE BIJZONDERE TANDHEELKUNDE"),
        newLeType("0419", "COD183", "AN",  98,   1, ""    , ""    , ""    , false , StringValueType         , "INDICATIE ONGEVAL (ONGEVALSGEVOLG)"),
        newLeType("0420", "COD089", "N" ,  99,   8, ""    , ""    , ""    , false , NaturalValueType        , "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER"),
        newLeType("0421", "COD952", "N" , 107,   4, ""    , ""    , ""    , false , NaturalValueType        , "SPECIALISME BEHANDELAAR/UITVOERDER"),
        newLeType("0422", "COD836", "N" , 111,   8, ""    , ""    , ""    , false , NaturalValueType        , "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER"),
        newLeType("0423", "COD953", "N" , 119,   4, ""    , ""    , ""    , false , NaturalValueType        , "SPECIALISME VOORSCHRIJVER/VERWIJZER"),
        newLeType("0424", "BED160", "N" , 123,   8, ""    , ""    , ""    , true  , UnsignedAmountValueType , "TARIEF PRESTATIE (INCL. BTW)"),
        newLeType("0425", "ANT054", "N" , 131,   4, ""    , ""    , ""    , true  , NaturalValueType        , "AANTAL UITGEVOERDE PRESTATIES"),
        newLeType("0426", "BED153", "N" , 135,   9, ""    , ""    , ""    , true  , SignedAmountValueType   , "BEREKEND BEDRAG (INCL. BTW)"),
        newLeType("0428", "BED151", "N" , 144,   8, ""    , ""    , ""    , false , UnsignedAmountValueType , "BEDRAG VERMINDERING BIJZONDERE TANDHEELKUNDE"),
        newLeType("0429", "NUM352", "N" , 152,   4, ""    , ""    , ""    , false , NaturalValueType        , "BTW-PERCENTAGE DECLARATIEBEDRAG"),
        newLeType("0430", "BED161", "N" , 156,   9, ""    , ""    , ""    , true  , SignedAmountValueType   , "DECLARATIEBEDRAG (INCL. BTW)"),
        newLeType("0432", "NUM362", "AN", 165,  20, ""    , ""    , ""    , true  , StringValueType         , "REFERENTIENUMMER DIT PRESTATIERECORD"),
        newLeType("0433", "NUM363", "AN", 185,  20, ""    , ""    , ""    , false , StringValueType         , "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD"),
        newLeType("0480", "TEC007", "AN", 205, 106, ""    , ""    , ""    , false , StringValueType         , "RESERVE")
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

proc createLineTypeMZ3011398(): LineType =
    let leTypes = @[
        newLeType("9801", "COD001", "N" ,   1,   2, ""    , ""    , ""    , true  , NaturalValueType        , "KENMERK RECORD"),
        newLeType("9802", "NUM040", "N" ,   3,  12, ""    , ""    , ""    , true  , NaturalValueType        , "IDENTIFICATIE DETAILRECORD"),
        newLeType("9803", "NUM109", "N" ,  15,   4, ""    , ""    , ""    , true  , NaturalValueType        , "REGELNUMMER VRIJE TEKST"),
        newLeType("9804", "OMS016", "AN",  19, 140, ""    , ""    , ""    , true  , StringValueType         , "VRIJE TEKST"),
        newLeType("9880", "TEC007", "AN", 159, 152, ""    , ""    , ""    , false , StringValueType         , "RESERVE")
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

proc createLineTypeMZ3011399(): LineType =
    let leTypes = @[
        newLeType("9901", "COD001", "N" ,   1,   2, ""    , ""    , ""    , true  , NaturalValueType        , "KENMERK RECORD"),
        newLeType("9902", "ANT085", "N" ,   3,   6, "0200", ""    , ""    , true  , NaturalValueType        , "AANTAL VERZEKERDENRECORDS"),
        newLeType("9903", "ANT086", "N" ,   9,   6, "0300", ""    , ""    , false , NaturalValueType        , "AANTAL DEBITEURRECORDS"),
        newLeType("9904", "ANT087", "N" ,  15,   6, "0400", ""    , ""    , true  , NaturalValueType        , "AANTAL PRESTATIERECORDS"),
        newLeType("9905", "ANT089", "N" ,  21,   6, "9800", ""    , ""    , false , NaturalValueType        , "AANTAL COMMENTAARRECORDS"),
        newLeType("9906", "ANT265", "N" ,  27,   7, "0000", ""    , ""    , true  , NaturalValueType        , "TOTAAL AANTAL DETAILRECORDS"),
        newLeType("9907", "BED025", "N" ,  34,  12, "0430", ""    , ""    , false , SignedAmountValueType   , "TOTAAL DECLARATIEBEDRAG"),
        newLeType("9980", "TEC007", "AN",  46, 265, ""    , ""    , ""    , false , StringValueType         , "RESERVE")
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


proc createLineTypesMZ30113(): seq[LineType] =
    @[
        createLineTypeMZ3011301(),
        createLineTypeMZ3011302(),
        createLineTypeMZ3011303(),
        createLineTypeMZ3011304(),
        createLineTypeMZ3011398(),
        createLineTypeMZ3011399()
    ]




proc createDocTypeMZ30113*(): DocumentType =
    let lineTypes = createLineTypesMZ30113()
    DocumentType(
        name: "MZ301",
        description: "DECLARATIE MONDZORG",
        formatVersion: 1,
        formatSubVersion: 3,
        vektisEICode: 176,
        lineLength: 310,
        lineTypes: lineTypes
    )

    

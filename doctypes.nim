import json, future, sequtils, strutils

type
   DocumentTypeError* = object of Exception
   
   LineElementType* = object
      lineElementId*: string
      code*: string
      fieldType*: string
      startPosition*: int
      length*: int
      description*: string
      
   LineType* = object
      name*: string
      length*: int
      lineId*: string
      lineElementTypes*: seq[LineElementType]
      
   DocumentType* = object
      name*: string
      description*: string
      formatVersion*: int
      formatSubVersion*: int
      vektisEICode: int
      lineTypes*: seq[LineType]

let doctypes_json_string = """
[
  {
    "description": "DECLARATIE FARMACEUTISCHE HULP",
    "formatSubVersion": 2,
    "formatVersion": 7,
    "name": "AP304",
    "vektisEICode": 106,
    "lineTypes": [
      {
        "length": 310,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "code": "COD002",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "code": "NUM001",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "code": "NUM309",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "code": "COD856",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "code": "COD805",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "code": "NUM284",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "code": "COD377",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "code": "COD009",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "code": "COD181",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "code": "COD031",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "code": "COD833",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "code": "DAT043",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "code": "DAT044",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "code": "NUM029",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "code": "DAT031",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "code": "NUM351",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "code": "COD363",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          }
        ]
      },
      {
        "length": 310,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "code": "NUM366",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "code": "DAT006",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "code": "COD134",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "code": "NAM193",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "code": "NAM194",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "code": "NAM191",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "code": "NAM192",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "code": "NAM025",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "code": "COD083",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "code": "NUM030",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "code": "NUM079",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "code": "COD090",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "code": "COD112",
            "description": "VERZEKERDENREGISTRATIE BIJ ZORGVERLENER",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0223",
            "startPosition": 171
          },
          {
            "code": "COD841",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0224",
            "startPosition": 182
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 128,
            "lineElementId": "0280",
            "startPosition": 183
          }
        ]
      },
      {
        "length": 310,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "code": "DAT264",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "code": "COD446",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "code": "NAM214",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "code": "NAM216",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "code": "NAM215",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "code": "NAM217",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "code": "NAM089",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "code": "COD843",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "code": "NAM141",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "code": "NUM098",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "code": "NUM099",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "code": "COD312",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "code": "NAM142",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "code": "COD313",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "code": "NUM364",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "code": "NUM092",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "code": "NAM221",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "code": "NUM008",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "code": "COD819",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          }
        ]
      },
      {
        "length": 310,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "code": "NUM013",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "code": "COD820",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "code": "COD181",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "code": "DAT272",
            "description": "DATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "code": "COD367",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0410",
            "startPosition": 75
          },
          {
            "code": "COD388",
            "description": "PRESTATIECODE",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0411",
            "startPosition": 78
          },
          {
            "code": "COD072",
            "description": "AFLEVERINGSEENHEID",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0412",
            "startPosition": 90
          },
          {
            "code": "ANT024",
            "description": "GEMIDDELDE DAGDOSERING",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0413",
            "startPosition": 92
          },
          {
            "code": "ANT025",
            "description": "HOEVEELHEID AFGELEVERD MIDDEL",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0414",
            "startPosition": 101
          },
          {
            "code": "COD978",
            "description": "WMG-TARIEFCODE MODULAIRE TARIEFSTRUCTUUR FARMACEUTISCHE HULP",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0415",
            "startPosition": 110
          },
          {
            "code": "COD089",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0416",
            "startPosition": 118
          },
          {
            "code": "COD952",
            "description": "SPECIALISME BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0417",
            "startPosition": 126
          },
          {
            "code": "COD836",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0418",
            "startPosition": 130
          },
          {
            "code": "COD953",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0419",
            "startPosition": 138
          },
          {
            "code": "NUM038",
            "description": "RECEPTNUMMER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 142
          },
          {
            "code": "NUM039",
            "description": "RECEPTVOORSCHRIFT, VOLGNUMMER",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0421",
            "startPosition": 150
          },
          {
            "code": "COD412",
            "description": "AANDUIDING SPECIFICATIE HULPMIDDEL",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0422",
            "startPosition": 152
          },
          {
            "code": "COD413",
            "description": "SPECIFICATIE HULPMIDDEL",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0423",
            "startPosition": 154
          },
          {
            "code": "COD114",
            "description": "INDICATIE SOORT RECEPTUUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0424",
            "startPosition": 166
          },
          {
            "code": "COD979",
            "description": "INDICATIE WMG",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0425",
            "startPosition": 167
          },
          {
            "code": "COD116",
            "description": "VOORGESCHREVEN DOSERING (BEKEND)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0426",
            "startPosition": 168
          },
          {
            "code": "COD450",
            "description": "TOELICHTING DECLARATIEPOST MIDDEL",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0427",
            "startPosition": 169
          },
          {
            "code": "BED172",
            "description": "WMG-TARIEFCODEBEDRAG (EXCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0428",
            "startPosition": 171
          },
          {
            "code": "BED174",
            "description": "BEDRAG BEREKENDE EIGEN BIJDRAGE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0429",
            "startPosition": 179
          },
          {
            "code": "COD980",
            "description": "INDICATIE GVS-BIJDRAGE OPGENOMEN IN DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0430",
            "startPosition": 187
          },
          {
            "code": "BED173",
            "description": "VERGOEDINGSBEDRAG MIDDELEN (EXCL. WMG, GVS, BTW; INCL AFTREK CLAWBACK)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0431",
            "startPosition": 188
          },
          {
            "code": "BED176",
            "description": "TARIEF PRESTATIE (EXCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0432",
            "startPosition": 196
          },
          {
            "code": "BED153",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0433",
            "startPosition": 204
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0434",
            "startPosition": 212
          },
          {
            "code": "NUM352",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0435",
            "startPosition": 213
          },
          {
            "code": "BED079",
            "description": "BTW BEDRAG OP DETAILNIVEAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0436",
            "startPosition": 217
          },
          {
            "code": "BED161",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0437",
            "startPosition": 225
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0438",
            "startPosition": 233
          },
          {
            "code": "NUM362",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0439",
            "startPosition": 234
          },
          {
            "code": "NUM363",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0440",
            "startPosition": 254
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 37,
            "lineElementId": "0480",
            "startPosition": 274
          }
        ]
      },
      {
        "length": 310,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "code": "NUM109",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "code": "OMS016",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          }
        ]
      },
      {
        "length": 310,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "code": "ANT085",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "code": "ANT086",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "code": "ANT087",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "code": "ANT089",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "code": "ANT265",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "code": "BED025",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "code": "COD043",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 265,
            "lineElementId": "9980",
            "startPosition": 46
          }
        ]
      }
    ]
  },
  {
    "description": "DECLARATIE FARMACEUTISCHE HULP",
    "formatSubVersion": 0,
    "formatVersion": 8,
    "name": "AP304",
    "vektisEICode": 193,
    "lineTypes": [
      {
        "length": 360,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "code": "COD002",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "code": "NUM001",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "code": "NUM309",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "code": "COD856",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "code": "COD805",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "code": "NUM284",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "code": "COD377",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "code": "COD009",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "code": "COD181",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "code": "COD031",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "code": "COD833",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "code": "DAT043",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "code": "DAT044",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "code": "NUM029",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "code": "DAT031",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "code": "NUM351",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "code": "COD363",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 243,
            "lineElementId": "0180",
            "startPosition": 118
          }
        ]
      },
      {
        "length": 360,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "code": "NUM366",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "code": "DAT006",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "code": "COD134",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "code": "NAM193",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "code": "NAM194",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "code": "NAM191",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "code": "NAM192",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "code": "NAM025",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "code": "COD083",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "code": "NUM030",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "code": "NUM079",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "code": "COD090",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "code": "COD112",
            "description": "VERZEKERDENREGISTRATIE BIJ ZORGVERLENER",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0223",
            "startPosition": 171
          },
          {
            "code": "COD841",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0224",
            "startPosition": 182
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 178,
            "lineElementId": "0280",
            "startPosition": 183
          }
        ]
      },
      {
        "length": 360,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "code": "NUM013",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "code": "COD150",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "code": "DAT006",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "code": "COD609",
            "description": "INDICATIE INFORMATIERECORD",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "code": "DAT272",
            "description": "DATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0410",
            "startPosition": 68
          },
          {
            "code": "DAT314",
            "description": "TIJDSTIP PRESTATIE",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0411",
            "startPosition": 76
          },
          {
            "code": "NUM083",
            "description": "ZORGCONTRACTNUMMER",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0412",
            "startPosition": 80
          },
          {
            "code": "COD692",
            "description": "AANDUIDING PRESTATIECODELIJST (01)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0413",
            "startPosition": 92
          },
          {
            "code": "COD626",
            "description": "PRESTATIECODE (01)",
            "fieldType": "N",
            "length": 14,
            "lineElementId": "0414",
            "startPosition": 95
          },
          {
            "code": "COD072",
            "description": "AFLEVERINGSEENHEID",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0415",
            "startPosition": 109
          },
          {
            "code": "ANT024",
            "description": "GEMIDDELDE DAGDOSERING",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0416",
            "startPosition": 111
          },
          {
            "code": "ANT054",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0417",
            "startPosition": 120
          },
          {
            "code": "COD089",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0418",
            "startPosition": 129
          },
          {
            "code": "COD952",
            "description": "SPECIALISME BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0419",
            "startPosition": 137
          },
          {
            "code": "COD512",
            "description": "PRAKTIJKCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 141
          },
          {
            "code": "COD836",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0421",
            "startPosition": 149
          },
          {
            "code": "COD953",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0422",
            "startPosition": 157
          },
          {
            "code": "COD339",
            "description": "INSTELLINGSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0423",
            "startPosition": 161
          },
          {
            "code": "NUM038",
            "description": "RECEPTNUMMER",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0424",
            "startPosition": 169
          },
          {
            "code": "NUM039",
            "description": "RECEPTVOORSCHRIFT, VOLGNUMMER",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0425",
            "startPosition": 181
          },
          {
            "code": "NUM409",
            "description": "PRESTATIEKOPPELNUMMER",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0426",
            "startPosition": 183
          },
          {
            "code": "COD677",
            "description": "AANDUIDING PRESTATIECODELIJST (02)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0427",
            "startPosition": 203
          },
          {
            "code": "COD678",
            "description": "PRESTATIECODE (02)",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0428",
            "startPosition": 206
          },
          {
            "code": "COD114",
            "description": "INDICATIE SOORT RECEPTUUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0429",
            "startPosition": 218
          },
          {
            "code": "COD526",
            "description": "WMG-SYSTEMATIEK PRIJS MIDDELEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0430",
            "startPosition": 219
          },
          {
            "code": "COD116",
            "description": "VOORGESCHREVEN DOSERING (BEKEND)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0431",
            "startPosition": 220
          },
          {
            "code": "COD450",
            "description": "TOELICHTING DECLARATIEPOST MIDDEL",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0432",
            "startPosition": 221
          },
          {
            "code": "NUM368",
            "description": "ZORGTRAJECTNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0433",
            "startPosition": 223
          },
          {
            "code": "COD646",
            "description": "INDICATIE DUUR GENEESMIDDEL",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0434",
            "startPosition": 238
          },
          {
            "code": "BED214",
            "description": "BEDRAG BEREKENDE GVS-BIJDRAGE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0435",
            "startPosition": 253
          },
          {
            "code": "COD980",
            "description": "INDICATIE GVS-BIJDRAGE OPGENOMEN IN DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0436",
            "startPosition": 261
          },
          {
            "code": "BED213",
            "description": "DECLARATIEBEDRAG EXCL GVS-BIJDRAGE EN EXCL.BTW",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0437",
            "startPosition": 262
          },
          {
            "code": "BED160",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0438",
            "startPosition": 270
          },
          {
            "code": "BED153",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0439",
            "startPosition": 278
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0440",
            "startPosition": 286
          },
          {
            "code": "NUM352",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0441",
            "startPosition": 287
          },
          {
            "code": "BED079",
            "description": "BTW BEDRAG OP DETAILNIVEAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0442",
            "startPosition": 291
          },
          {
            "code": "BED161",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0443",
            "startPosition": 299
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0444",
            "startPosition": 307
          },
          {
            "code": "NUM362",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0445",
            "startPosition": 308
          },
          {
            "code": "NUM363",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0446",
            "startPosition": 328
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0480",
            "startPosition": 348
          }
        ]
      },
      {
        "length": 360,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "code": "NUM109",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "code": "OMS016",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 202,
            "lineElementId": "9880",
            "startPosition": 159
          }
        ]
      },
      {
        "length": 360,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "code": "ANT085",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "code": "ANT086",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "code": "ANT087",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "code": "ANT089",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "code": "ANT265",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "code": "BED025",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "code": "COD043",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 315,
            "lineElementId": "9980",
            "startPosition": 46
          }
        ]
      },
      {
        "length": 360,
        "lineId": "03",
        "name": "DebiteurenenRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "code": "DAT264",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "code": "COD446",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "code": "NAM214",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "code": "NAM216",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "code": "NAM215",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "code": "NAM217",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "code": "NAM089",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "code": "COD843",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "code": "NAM141",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "code": "NUM098",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "code": "NUM099",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "code": "COD312",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "code": "NAM142",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "code": "COD313",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "code": "NUM364",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "code": "NUM092",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "code": "NAM221",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 50,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "code": "NUM406",
            "description": "IBAN",
            "fieldType": "AN",
            "length": 34,
            "lineElementId": "0325",
            "startPosition": 260
          },
          {
            "code": "COD819",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 294
          },
          {
            "code": "COD908",
            "description": "CODE INCASSO",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0327",
            "startPosition": 296
          },
          {
            "code": "NUM413",
            "description": "VERSIENUMMER DEBITEURRECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0328",
            "startPosition": 298
          },
          {
            "code": "FAM001",
            "description": "MACHTIGINGSDATUM",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0329",
            "startPosition": 300
          },
          {
            "code": "FAM002",
            "description": "FACTURATIEVORM",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0330",
            "startPosition": 308
          },
          {
            "code": "FAM003",
            "description": "EXTRA ADRESREGEL",
            "fieldType": "AN",
            "length": 35,
            "lineElementId": "0331",
            "startPosition": 309
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 17,
            "lineElementId": "0380",
            "startPosition": 344
          }
        ]
      }
    ]
  },
  {
    "description": "DECLARATIE AWBZ",
    "formatSubVersion": 3,
    "formatVersion": 1,
    "name": "AW319",
    "vektisEICode": 187,
    "lineTypes": [
      {
        "length": 310,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "code": "COD002",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "code": "NUM001",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "code": "NUM309",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "code": "COD856",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "code": "COD805",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "code": "NUM284",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "code": "COD377",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "code": "COD009",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "code": "COD181",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "code": "COD031",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "code": "COD833",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "code": "DAT043",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "code": "DAT044",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "code": "NUM029",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "code": "DAT031",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "code": "NUM351",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "code": "COD363",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          }
        ]
      },
      {
        "length": 310,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "code": "NUM366",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "code": "DAT006",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "code": "COD134",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "code": "NAM193",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "code": "NAM194",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "code": "NAM191",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "code": "NAM192",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "code": "NAM025",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "code": "COD083",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "code": "NUM030",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "code": "NUM079",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "code": "COD090",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "code": "COD841",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "code": "COD459",
            "description": "CODE INDICATIEORGAAN",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0224",
            "startPosition": 182
          },
          {
            "code": "NUM258",
            "description": "CLIËNTNUMMER INDICATIEORGAAN",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0225",
            "startPosition": 186
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 105,
            "lineElementId": "0280",
            "startPosition": 206
          }
        ]
      },
      {
        "length": 310,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "code": "DAT264",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "code": "COD446",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "code": "NAM214",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "code": "NAM216",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "code": "NAM215",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "code": "NAM217",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "code": "NAM089",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "code": "COD843",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "code": "NAM141",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "code": "NUM098",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "code": "NUM099",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "code": "COD312",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "code": "NAM142",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "code": "COD313",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "code": "NUM364",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "code": "NUM092",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "code": "NAM221",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "code": "NUM008",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "code": "COD819",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          }
        ]
      },
      {
        "length": 310,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "code": "NUM013",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "code": "COD150",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "code": "COD459",
            "description": "CODE INDICATIEORGAAN",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "code": "NUM258",
            "description": "CLIËNTNUMMER INDICATIEORGAAN",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0409",
            "startPosition": 63
          },
          {
            "code": "NUM259",
            "description": "INDICATIE-AANVRAAGNUMMER INDICATIEORGAAN",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0410",
            "startPosition": 83
          },
          {
            "code": "NUM260",
            "description": "INDICATIEBESLUITNUMMER INDICATIEORGAAN",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0411",
            "startPosition": 92
          },
          {
            "code": "COD732",
            "description": "FUNCTIECODE",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0412",
            "startPosition": 101
          },
          {
            "code": "COD163",
            "description": "ZORGZWAARTEPAKKETCODE",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0413",
            "startPosition": 103
          },
          {
            "code": "DAT001",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0414",
            "startPosition": 106
          },
          {
            "code": "DAT003",
            "description": "EINDDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0415",
            "startPosition": 114
          },
          {
            "code": "COD367",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0416",
            "startPosition": 122
          },
          {
            "code": "COD388",
            "description": "PRESTATIECODE",
            "fieldType": "AN",
            "length": 5,
            "lineElementId": "0417",
            "startPosition": 125
          },
          {
            "code": "ANT054",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0418",
            "startPosition": 130
          },
          {
            "code": "COD218",
            "description": "TIJDSEENHEID ZORGPERIODE",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0419",
            "startPosition": 134
          },
          {
            "code": "COD089",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 136
          },
          {
            "code": "COD952",
            "description": "SPECIALISME BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0421",
            "startPosition": 144
          },
          {
            "code": "COD836",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0422",
            "startPosition": 148
          },
          {
            "code": "COD953",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0423",
            "startPosition": 156
          },
          {
            "code": "ANT094",
            "description": "VERREKENPERCENTAGE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0424",
            "startPosition": 160
          },
          {
            "code": "BED160",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0425",
            "startPosition": 165
          },
          {
            "code": "BED153",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0426",
            "startPosition": 173
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0427",
            "startPosition": 181
          },
          {
            "code": "NUM352",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0428",
            "startPosition": 182
          },
          {
            "code": "BED161",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0429",
            "startPosition": 186
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0430",
            "startPosition": 194
          },
          {
            "code": "NUM362",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0431",
            "startPosition": 195
          },
          {
            "code": "NUM363",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0432",
            "startPosition": 215
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 76,
            "lineElementId": "0480",
            "startPosition": 235
          }
        ]
      },
      {
        "length": 310,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "code": "NUM109",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "code": "OMS016",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          }
        ]
      },
      {
        "length": 310,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "code": "ANT085",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "code": "ANT086",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "code": "ANT087",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "code": "ANT089",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "code": "ANT265",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "code": "BED025",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "code": "COD043",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 265,
            "lineElementId": "9980",
            "startPosition": 46
          }
        ]
      }
    ]
  },
  {
    "description": "RETOURINFORMATIE DECLARATIE AWBZ",
    "formatSubVersion": 3,
    "formatVersion": 1,
    "name": "AW320",
    "vektisEICode": 188,
    "lineTypes": [
      {
        "length": 370,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "code": "COD002",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "code": "NUM001",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "code": "NUM309",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "code": "COD856",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "code": "COD805",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "code": "NUM284",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "code": "COD377",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "code": "COD009",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "code": "COD181",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "code": "COD031",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "code": "COD833",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "code": "DAT043",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "code": "DAT044",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "code": "NUM029",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "code": "DAT031",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "code": "NUM351",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "code": "COD363",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          },
          {
            "code": "NUM370",
            "description": "REFERENTIENUMMER ZORGVERZEKERAAR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0181",
            "startPosition": 311
          },
          {
            "code": "DAT277",
            "description": "DAGTEKENING RETOURBERICHT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0182",
            "startPosition": 335
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0196",
            "startPosition": 343
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0197",
            "startPosition": 347
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0198",
            "startPosition": 351
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 16,
            "lineElementId": "0199",
            "startPosition": 355
          }
        ]
      },
      {
        "length": 370,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "code": "NUM366",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "code": "DAT006",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "code": "COD134",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "code": "NAM193",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "code": "NAM194",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "code": "NAM191",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "code": "NAM192",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "code": "NAM025",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "code": "COD083",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "code": "NUM030",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "code": "NUM079",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "code": "COD090",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "code": "COD841",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "code": "COD459",
            "description": "CODE INDICATIEORGAAN",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0224",
            "startPosition": 182
          },
          {
            "code": "NUM258",
            "description": "CLIËNTNUMMER INDICATIEORGAAN",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0225",
            "startPosition": 186
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 105,
            "lineElementId": "0280",
            "startPosition": 206
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0296",
            "startPosition": 311
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0297",
            "startPosition": 315
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0298",
            "startPosition": 319
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0299",
            "startPosition": 323
          }
        ]
      },
      {
        "length": 370,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "code": "DAT264",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "code": "COD446",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "code": "NAM214",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "code": "NAM216",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "code": "NAM215",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "code": "NAM217",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "code": "NAM089",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "code": "COD843",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "code": "NAM141",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "code": "NUM098",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "code": "NUM099",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "code": "COD312",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "code": "NAM142",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "code": "COD313",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "code": "NUM364",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "code": "NUM092",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "code": "NAM221",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "code": "NUM008",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "code": "COD819",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0396",
            "startPosition": 311
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0397",
            "startPosition": 315
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0398",
            "startPosition": 319
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0399",
            "startPosition": 323
          }
        ]
      },
      {
        "length": 370,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "code": "NUM013",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "code": "COD150",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "code": "COD459",
            "description": "CODE INDICATIEORGAAN",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "code": "NUM258",
            "description": "CLIËNTNUMMER INDICATIEORGAAN",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0409",
            "startPosition": 63
          },
          {
            "code": "NUM259",
            "description": "INDICATIE-AANVRAAGNUMMER INDICATIEORGAAN",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0410",
            "startPosition": 83
          },
          {
            "code": "NUM260",
            "description": "INDICATIEBESLUITNUMMER INDICATIEORGAAN",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0411",
            "startPosition": 92
          },
          {
            "code": "COD732",
            "description": "FUNCTIECODE",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0412",
            "startPosition": 101
          },
          {
            "code": "COD163",
            "description": "ZORGZWAARTEPAKKETCODE",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0413",
            "startPosition": 103
          },
          {
            "code": "DAT001",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0414",
            "startPosition": 106
          },
          {
            "code": "DAT003",
            "description": "EINDDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0415",
            "startPosition": 114
          },
          {
            "code": "COD367",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0416",
            "startPosition": 122
          },
          {
            "code": "COD388",
            "description": "PRESTATIECODE",
            "fieldType": "AN",
            "length": 5,
            "lineElementId": "0417",
            "startPosition": 125
          },
          {
            "code": "ANT054",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0418",
            "startPosition": 130
          },
          {
            "code": "COD218",
            "description": "TIJDSEENHEID ZORGPERIODE",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0419",
            "startPosition": 134
          },
          {
            "code": "COD089",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 136
          },
          {
            "code": "COD952",
            "description": "SPECIALISME BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0421",
            "startPosition": 144
          },
          {
            "code": "COD836",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0422",
            "startPosition": 148
          },
          {
            "code": "COD953",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0423",
            "startPosition": 156
          },
          {
            "code": "ANT094",
            "description": "VERREKENPERCENTAGE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0424",
            "startPosition": 160
          },
          {
            "code": "BED160",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0425",
            "startPosition": 165
          },
          {
            "code": "BED153",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0426",
            "startPosition": 173
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0427",
            "startPosition": 181
          },
          {
            "code": "NUM352",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0428",
            "startPosition": 182
          },
          {
            "code": "BED161",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0429",
            "startPosition": 186
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0430",
            "startPosition": 194
          },
          {
            "code": "NUM362",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0431",
            "startPosition": 195
          },
          {
            "code": "NUM363",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0432",
            "startPosition": 215
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 76,
            "lineElementId": "0480",
            "startPosition": 235
          },
          {
            "code": "BED165",
            "description": "BEREKEND BEDRAG ZORGVERZEKERAAR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0481",
            "startPosition": 311
          },
          {
            "code": "COD672",
            "description": "INDICATIE DEBET/CREDIT (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0482",
            "startPosition": 319
          },
          {
            "code": "BED166",
            "description": "TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0483",
            "startPosition": 320
          },
          {
            "code": "COD673",
            "description": "INDICATIE DEBET/CREDIT (04)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0484",
            "startPosition": 328
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0496",
            "startPosition": 329
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0497",
            "startPosition": 333
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0498",
            "startPosition": 337
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 30,
            "lineElementId": "0499",
            "startPosition": 341
          }
        ]
      },
      {
        "length": 370,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "code": "NUM109",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "code": "OMS016",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9896",
            "startPosition": 311
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9897",
            "startPosition": 315
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9898",
            "startPosition": 319
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "9899",
            "startPosition": 323
          }
        ]
      },
      {
        "length": 370,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "code": "ANT085",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "code": "ANT086",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "code": "ANT087",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "code": "ANT089",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "code": "ANT265",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "code": "BED168",
            "description": "TOTAAL INGEDIEND DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "code": "BED167",
            "description": "TOTAAL TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9909",
            "startPosition": 46
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9910",
            "startPosition": 57
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 313,
            "lineElementId": "9999",
            "startPosition": 58
          }
        ]
      }
    ]
  },
  {
    "description": "EI DECLARATIE EERSTELIJNSPSYCHOLOGISCHE HULP",
    "formatSubVersion": 2,
    "formatVersion": 1,
    "name": "EP301",
    "vektisEICode": 179,
    "lineTypes": [
      {
        "length": 310,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "code": "COD002",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "code": "NUM001",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "code": "NUM309",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "code": "COD856",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "code": "COD805",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "code": "NUM284",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "code": "COD377",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "code": "COD009",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "code": "COD181",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "code": "COD031",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "code": "COD833",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "code": "DAT043",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "code": "DAT044",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "code": "NUM029",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "code": "DAT031",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "code": "NUM351",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "code": "COD363",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          }
        ]
      },
      {
        "length": 310,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "code": "NUM366",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "code": "DAT006",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "code": "COD134",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "code": "NAM193",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "code": "NAM194",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "code": "NAM191",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "code": "NAM192",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "code": "NAM025",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "code": "COD083",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "code": "NUM030",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "code": "NUM079",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "code": "COD090",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "code": "COD841",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 129,
            "lineElementId": "0280",
            "startPosition": 182
          }
        ]
      },
      {
        "length": 310,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "code": "DAT264",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "code": "COD446",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "code": "NAM214",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "code": "NAM216",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "code": "NAM215",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "code": "NAM217",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "code": "NAM089",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "code": "COD843",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "code": "NAM141",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "code": "NUM098",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "code": "NUM099",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "code": "COD312",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "code": "NAM142",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "code": "COD313",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "code": "NUM364",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "code": "NUM092",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "code": "NAM221",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "code": "NUM008",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "code": "COD819",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          }
        ]
      },
      {
        "length": 310,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "code": "NUM013",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "code": "COD820",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "code": "DAT272",
            "description": "DATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "code": "COD367",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "code": "COD388",
            "description": "PRESTATIECODE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0410",
            "startPosition": 70
          },
          {
            "code": "COD392",
            "description": "AANDUIDING DIAGNOSECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0411",
            "startPosition": 75
          },
          {
            "code": "COD393",
            "description": "DIAGNOSECODE",
            "fieldType": "AN",
            "length": 8,
            "lineElementId": "0412",
            "startPosition": 78
          },
          {
            "code": "COD089",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0413",
            "startPosition": 86
          },
          {
            "code": "COD836",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0414",
            "startPosition": 94
          },
          {
            "code": "COD953",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0415",
            "startPosition": 102
          },
          {
            "code": "BED160",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0416",
            "startPosition": 106
          },
          {
            "code": "BED153",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0417",
            "startPosition": 114
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0418",
            "startPosition": 122
          },
          {
            "code": "NUM352",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0419",
            "startPosition": 123
          },
          {
            "code": "BED161",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 127
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0421",
            "startPosition": 135
          },
          {
            "code": "NUM362",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0422",
            "startPosition": 136
          },
          {
            "code": "NUM363",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0423",
            "startPosition": 156
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 135,
            "lineElementId": "0480",
            "startPosition": 176
          }
        ]
      },
      {
        "length": 310,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "code": "NUM109",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "code": "OMS016",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          }
        ]
      },
      {
        "length": 310,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "code": "ANT085",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "code": "ANT086",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "code": "ANT087",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "code": "ANT089",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "code": "ANT265",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "code": "BED025",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "code": "COD043",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 265,
            "lineElementId": "9980",
            "startPosition": 46
          }
        ]
      }
    ]
  },
  {
    "description": "RETOURINFORMATIE DECLARATIE EERSTELIJNSPSYCHOLOGISCHE HULP",
    "formatSubVersion": 2,
    "formatVersion": 1,
    "name": "EP302",
    "vektisEICode": 180,
    "lineTypes": [
      {
        "length": 370,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "code": "COD002",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "code": "NUM001",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "code": "NUM309",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "code": "COD856",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "code": "COD805",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "code": "NUM284",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "code": "COD377",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "code": "COD009",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "code": "COD181",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "code": "COD031",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "code": "COD833",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "code": "DAT043",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "code": "DAT044",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "code": "NUM029",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "code": "DAT031",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "code": "NUM351",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "code": "COD363",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          },
          {
            "code": "NUM370",
            "description": "REFERENTIENUMMER ZORGVERZEKERAAR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0181",
            "startPosition": 311
          },
          {
            "code": "DAT277",
            "description": "DAGTEKENING RETOURBERICHT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0182",
            "startPosition": 335
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0196",
            "startPosition": 343
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0197",
            "startPosition": 347
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0198",
            "startPosition": 351
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 16,
            "lineElementId": "0199",
            "startPosition": 355
          }
        ]
      },
      {
        "length": 370,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "code": "NUM366",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "code": "DAT006",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "code": "COD134",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "code": "NAM193",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "code": "NAM194",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "code": "NAM191",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "code": "NAM192",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "code": "NAM025",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "code": "COD083",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "code": "NUM030",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "code": "NUM079",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "code": "COD090",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "code": "COD841",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 129,
            "lineElementId": "0280",
            "startPosition": 182
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0296",
            "startPosition": 311
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0297",
            "startPosition": 315
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0298",
            "startPosition": 319
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0299",
            "startPosition": 323
          }
        ]
      },
      {
        "length": 370,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "code": "DAT264",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "code": "COD446",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "code": "NAM214",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "code": "NAM216",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "code": "NAM215",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "code": "NAM217",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "code": "NAM089",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "code": "COD843",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "code": "NAM141",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "code": "NUM098",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "code": "NUM099",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "code": "COD312",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "code": "NAM142",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "code": "COD313",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "code": "NUM364",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "code": "NUM092",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "code": "NAM221",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "code": "NUM008",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "code": "COD819",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0396",
            "startPosition": 311
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0397",
            "startPosition": 315
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0398",
            "startPosition": 319
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0399",
            "startPosition": 323
          }
        ]
      },
      {
        "length": 370,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "code": "NUM013",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "code": "COD820",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "code": "DAT272",
            "description": "DATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "code": "COD367",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "code": "COD388",
            "description": "PRESTATIECODE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0410",
            "startPosition": 70
          },
          {
            "code": "COD392",
            "description": "AANDUIDING DIAGNOSECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0411",
            "startPosition": 75
          },
          {
            "code": "COD393",
            "description": "DIAGNOSECODE",
            "fieldType": "AN",
            "length": 8,
            "lineElementId": "0412",
            "startPosition": 78
          },
          {
            "code": "COD089",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0413",
            "startPosition": 86
          },
          {
            "code": "COD836",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0414",
            "startPosition": 94
          },
          {
            "code": "COD953",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0415",
            "startPosition": 102
          },
          {
            "code": "BED160",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0416",
            "startPosition": 106
          },
          {
            "code": "BED153",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0417",
            "startPosition": 114
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0418",
            "startPosition": 122
          },
          {
            "code": "NUM352",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0419",
            "startPosition": 123
          },
          {
            "code": "BED161",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 127
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0421",
            "startPosition": 135
          },
          {
            "code": "NUM362",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0422",
            "startPosition": 136
          },
          {
            "code": "NUM363",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0423",
            "startPosition": 156
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 135,
            "lineElementId": "0480",
            "startPosition": 176
          },
          {
            "code": "BED165",
            "description": "BEREKEND BEDRAG ZORGVERZEKERAAR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0481",
            "startPosition": 311
          },
          {
            "code": "COD672",
            "description": "INDICATIE DEBET/CREDIT (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0482",
            "startPosition": 319
          },
          {
            "code": "BED166",
            "description": "TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0483",
            "startPosition": 320
          },
          {
            "code": "COD673",
            "description": "INDICATIE DEBET/CREDIT (04)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0484",
            "startPosition": 328
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0496",
            "startPosition": 329
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0497",
            "startPosition": 333
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0498",
            "startPosition": 337
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 30,
            "lineElementId": "0499",
            "startPosition": 341
          }
        ]
      },
      {
        "length": 370,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "code": "NUM109",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "code": "OMS016",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9896",
            "startPosition": 311
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9897",
            "startPosition": 315
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9898",
            "startPosition": 319
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "9899",
            "startPosition": 323
          }
        ]
      },
      {
        "length": 370,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "code": "ANT267",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "code": "ANT268",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "code": "ANT269",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "code": "ANT270",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "code": "ANT271",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "code": "BED168",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "code": "BED167",
            "description": "TOTAAL TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9909",
            "startPosition": 46
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9910",
            "startPosition": 57
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 313,
            "lineElementId": "9999",
            "startPosition": 58
          }
        ]
      }
    ]
  },
  {
    "description": "DECLARATIE HUISARTSENHULP",
    "formatSubVersion": 2,
    "formatVersion": 4,
    "name": "HA304",
    "vektisEICode": 112,
    "lineTypes": [
      {
        "length": 310,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "code": "COD002",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "code": "NUM001",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "code": "NUM309",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "code": "COD856",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "code": "COD805",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "code": "NUM284",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "code": "COD377",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "code": "COD009",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "code": "COD181",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "code": "COD031",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "code": "COD833",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "code": "DAT043",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "code": "DAT044",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "code": "NUM029",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "code": "DAT031",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "code": "NUM351",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "code": "COD363",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          }
        ]
      },
      {
        "length": 310,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "code": "NUM366",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "code": "DAT006",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "code": "COD134",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "code": "NAM193",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "code": "NAM194",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "code": "NAM191",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "code": "NAM192",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "code": "NAM025",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "code": "COD083",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "code": "NUM030",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "code": "NUM079",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "code": "COD090",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "code": "COD841",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 129,
            "lineElementId": "0280",
            "startPosition": 182
          }
        ]
      },
      {
        "length": 310,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "code": "DAT264",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "code": "COD446",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "code": "NAM214",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "code": "NAM216",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "code": "NAM215",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "code": "NAM217",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "code": "NAM089",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "code": "COD843",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "code": "NAM141",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "code": "NUM098",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "code": "NUM099",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "code": "COD312",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "code": "NAM142",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "code": "COD313",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "code": "NUM364",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "code": "NUM092",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "code": "NAM221",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "code": "NUM008",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "code": "COD819",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          }
        ]
      },
      {
        "length": 310,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "code": "NUM013",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "code": "COD820",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "code": "DAT001",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "code": "DAT003",
            "description": "EINDDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "code": "COD367",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0410",
            "startPosition": 75
          },
          {
            "code": "COD388",
            "description": "PRESTATIECODE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0411",
            "startPosition": 78
          },
          {
            "code": "ANT054",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0412",
            "startPosition": 83
          },
          {
            "code": "COD089",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0413",
            "startPosition": 87
          },
          {
            "code": "BED160",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0414",
            "startPosition": 95
          },
          {
            "code": "BED153",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0415",
            "startPosition": 103
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0416",
            "startPosition": 111
          },
          {
            "code": "NUM352",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0417",
            "startPosition": 112
          },
          {
            "code": "BED161",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0418",
            "startPosition": 116
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0419",
            "startPosition": 124
          },
          {
            "code": "NUM362",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0420",
            "startPosition": 125
          },
          {
            "code": "NUM363",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0421",
            "startPosition": 145
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 146,
            "lineElementId": "0480",
            "startPosition": 165
          }
        ]
      },
      {
        "length": 310,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "code": "NUM109",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "code": "OMS016",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          }
        ]
      },
      {
        "length": 310,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "code": "ANT085",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "code": "ANT086",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "code": "ANT087",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "code": "ANT089",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "code": "ANT265",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "code": "BED025",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "code": "COD043",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 265,
            "lineElementId": "9980",
            "startPosition": 46
          }
        ]
      }
    ]
  },
  {
    "description": "RETOURINFORMATIE DECLARATIE HUISARTSENHULP",
    "formatSubVersion": 2,
    "formatVersion": 4,
    "name": "HA305",
    "vektisEICode": 113,
    "lineTypes": [
      {
        "length": 380,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "code": "COD002",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "code": "NUM001",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "code": "NUM309",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "code": "COD856",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "code": "COD805",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "code": "NUM284",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "code": "COD377",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "code": "COD009",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "code": "COD181",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "code": "COD031",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "code": "COD833",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "code": "DAT043",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "code": "DAT044",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "code": "NUM029",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "code": "DAT031",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "code": "NUM351",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "code": "COD363",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          },
          {
            "code": "NUM370",
            "description": "REFERENTIENUMMER ZORGVERZEKERAAR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0181",
            "startPosition": 311
          },
          {
            "code": "DAT277",
            "description": "DAGTEKENING RETOURBERICHT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0182",
            "startPosition": 335
          },
          {
            "code": "COD027",
            "description": "CODE VERWERKING",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0189",
            "startPosition": 343
          },
          {
            "code": "NUM240",
            "description": "FOUT RUBRIEKNUMMER (01)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0190",
            "startPosition": 346
          },
          {
            "code": "COD957",
            "description": "FOUTCODE (01)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0191",
            "startPosition": 350
          },
          {
            "code": "COD133",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0192",
            "startPosition": 353
          },
          {
            "code": "NUM238",
            "description": "FOUT RUBRIEKNUMMER (02)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0193",
            "startPosition": 354
          },
          {
            "code": "COD958",
            "description": "FOUTCODE (02)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0194",
            "startPosition": 358
          },
          {
            "code": "COD685",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0195",
            "startPosition": 361
          },
          {
            "code": "NUM239",
            "description": "FOUT RUBRIEKNUMMER (03)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0196",
            "startPosition": 362
          },
          {
            "code": "COD959",
            "description": "FOUTCODE (03)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0197",
            "startPosition": 366
          },
          {
            "code": "COD686",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0198",
            "startPosition": 369
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0199",
            "startPosition": 370
          }
        ]
      },
      {
        "length": 380,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "code": "NUM366",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "code": "DAT006",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "code": "COD134",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "code": "NAM193",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "code": "NAM194",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "code": "NAM191",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "code": "NAM192",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "code": "NAM025",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "code": "COD083",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "code": "NUM030",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "code": "NUM079",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "code": "COD090",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "code": "COD841",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 129,
            "lineElementId": "0280",
            "startPosition": 182
          },
          {
            "code": "COD027",
            "description": "CODE VERWERKING",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0289",
            "startPosition": 311
          },
          {
            "code": "NUM240",
            "description": "FOUT RUBRIEKNUMMER (01)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0290",
            "startPosition": 314
          },
          {
            "code": "COD957",
            "description": "FOUTCODE (01)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0291",
            "startPosition": 318
          },
          {
            "code": "COD133",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0292",
            "startPosition": 321
          },
          {
            "code": "NUM238",
            "description": "FOUT RUBRIEKNUMMER (02)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0293",
            "startPosition": 322
          },
          {
            "code": "COD958",
            "description": "FOUTCODE (02)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0294",
            "startPosition": 326
          },
          {
            "code": "COD685",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0295",
            "startPosition": 329
          },
          {
            "code": "NUM239",
            "description": "FOUT RUBRIEKNUMMER (03)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0296",
            "startPosition": 330
          },
          {
            "code": "COD959",
            "description": "FOUTCODE (03)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0297",
            "startPosition": 334
          },
          {
            "code": "COD686",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0298",
            "startPosition": 337
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 43,
            "lineElementId": "0299",
            "startPosition": 338
          }
        ]
      },
      {
        "length": 380,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "code": "DAT264",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "code": "COD446",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "code": "NAM214",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "code": "NAM216",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "code": "NAM215",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "code": "NAM217",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "code": "NAM089",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "code": "COD843",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "code": "NAM141",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "code": "NUM098",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "code": "NUM099",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "code": "COD312",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "code": "NAM142",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "code": "COD313",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "code": "NUM364",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "code": "NUM092",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "code": "NAM221",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "code": "NUM008",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "code": "COD819",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          },
          {
            "code": "COD027",
            "description": "CODE VERWERKING",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0389",
            "startPosition": 311
          },
          {
            "code": "NUM240",
            "description": "FOUT RUBRIEKNUMMER (01)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0390",
            "startPosition": 314
          },
          {
            "code": "COD957",
            "description": "FOUTCODE (01)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0391",
            "startPosition": 318
          },
          {
            "code": "COD133",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0392",
            "startPosition": 321
          },
          {
            "code": "NUM238",
            "description": "FOUT RUBRIEKNUMMER (02)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0393",
            "startPosition": 322
          },
          {
            "code": "COD958",
            "description": "FOUTCODE (02)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0394",
            "startPosition": 326
          },
          {
            "code": "COD685",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0395",
            "startPosition": 329
          },
          {
            "code": "NUM239",
            "description": "FOUT RUBRIEKNUMMER (03)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0396",
            "startPosition": 330
          },
          {
            "code": "COD959",
            "description": "FOUTCODE (03)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0397",
            "startPosition": 334
          },
          {
            "code": "COD686",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0398",
            "startPosition": 337
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 43,
            "lineElementId": "0399",
            "startPosition": 338
          }
        ]
      },
      {
        "length": 380,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "code": "NUM013",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "code": "COD820",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "code": "DAT001",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "code": "DAT003",
            "description": "EINDDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "code": "COD367",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0410",
            "startPosition": 75
          },
          {
            "code": "COD388",
            "description": "PRESTATIECODE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0411",
            "startPosition": 78
          },
          {
            "code": "ANT054",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0412",
            "startPosition": 83
          },
          {
            "code": "COD089",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0413",
            "startPosition": 87
          },
          {
            "code": "BED160",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0414",
            "startPosition": 95
          },
          {
            "code": "BED153",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0415",
            "startPosition": 103
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0416",
            "startPosition": 111
          },
          {
            "code": "NUM352",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0417",
            "startPosition": 112
          },
          {
            "code": "BED161",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0418",
            "startPosition": 116
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0419",
            "startPosition": 124
          },
          {
            "code": "NUM362",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0420",
            "startPosition": 125
          },
          {
            "code": "NUM363",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0421",
            "startPosition": 145
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 146,
            "lineElementId": "0480",
            "startPosition": 165
          },
          {
            "code": "BED166",
            "description": "TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0481",
            "startPosition": 311
          },
          {
            "code": "COD672",
            "description": "INDICATIE DEBET/CREDIT (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0482",
            "startPosition": 319
          },
          {
            "code": "COD027",
            "description": "CODE VERWERKING",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0489",
            "startPosition": 320
          },
          {
            "code": "NUM240",
            "description": "FOUT RUBRIEKNUMMER (01)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0490",
            "startPosition": 323
          },
          {
            "code": "COD957",
            "description": "FOUTCODE (01)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0491",
            "startPosition": 327
          },
          {
            "code": "COD133",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0492",
            "startPosition": 330
          },
          {
            "code": "NUM238",
            "description": "FOUT RUBRIEKNUMMER (02)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0493",
            "startPosition": 331
          },
          {
            "code": "COD958",
            "description": "FOUTCODE (02)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0494",
            "startPosition": 335
          },
          {
            "code": "COD685",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0495",
            "startPosition": 338
          },
          {
            "code": "NUM239",
            "description": "FOUT RUBRIEKNUMMER (03)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0496",
            "startPosition": 339
          },
          {
            "code": "COD959",
            "description": "FOUTCODE (03)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0497",
            "startPosition": 343
          },
          {
            "code": "COD686",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0498",
            "startPosition": 346
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 34,
            "lineElementId": "0499",
            "startPosition": 347
          }
        ]
      },
      {
        "length": 380,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "code": "NUM109",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "code": "OMS016",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          },
          {
            "code": "COD027",
            "description": "CODE VERWERKING",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "9889",
            "startPosition": 311
          },
          {
            "code": "NUM240",
            "description": "FOUT RUBRIEKNUMMER (01)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9890",
            "startPosition": 314
          },
          {
            "code": "COD957",
            "description": "FOUTCODE (01)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "9891",
            "startPosition": 318
          },
          {
            "code": "COD133",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9892",
            "startPosition": 321
          },
          {
            "code": "NUM238",
            "description": "FOUT RUBRIEKNUMMER (02)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9893",
            "startPosition": 322
          },
          {
            "code": "COD958",
            "description": "FOUTCODE (02)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "9894",
            "startPosition": 326
          },
          {
            "code": "COD685",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9895",
            "startPosition": 329
          },
          {
            "code": "NUM239",
            "description": "FOUT RUBRIEKNUMMER (03)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9896",
            "startPosition": 330
          },
          {
            "code": "COD959",
            "description": "FOUTCODE (03)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "9897",
            "startPosition": 334
          },
          {
            "code": "COD686",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9898",
            "startPosition": 337
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 43,
            "lineElementId": "9899",
            "startPosition": 338
          }
        ]
      },
      {
        "length": 380,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "code": "ANT267",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "code": "ANT268",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "code": "ANT269",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "code": "ANT270",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "code": "ANT271",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "code": "BED168",
            "description": "TOTAAL INGEDIEND DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "code": "BED167",
            "description": "TOTAAL TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9909",
            "startPosition": 46
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9910",
            "startPosition": 57
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 323,
            "lineElementId": "9980",
            "startPosition": 58
          }
        ]
      }
    ]
  },
  {
    "description": "DECLARATIE HULPMIDDELEN",
    "formatSubVersion": 2,
    "formatVersion": 5,
    "name": "LH307",
    "vektisEICode": 110,
    "lineTypes": [
      {
        "length": 310,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "code": "COD002",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "code": "NUM001",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "code": "NUM309",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "code": "COD856",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "code": "COD805",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "code": "NUM284",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "code": "COD377",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "code": "COD009",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "code": "COD181",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "code": "COD031",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "code": "COD833",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "code": "DAT043",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "code": "DAT044",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "code": "NUM029",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "code": "DAT031",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "code": "NUM351",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "code": "COD363",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          }
        ]
      },
      {
        "length": 310,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "code": "COD038",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "code": "DAT006",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "code": "COD134",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "code": "NAM193",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "code": "NAM194",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "code": "NAM191",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "code": "NAM192",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "code": "NAM025",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "code": "COD083",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "code": "NUM030",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "code": "NUM079",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "code": "COD090",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "code": "COD841",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 129,
            "lineElementId": "0280",
            "startPosition": 182
          }
        ]
      },
      {
        "length": 310,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "code": "DAT264",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "code": "COD446",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "code": "NAM214",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "code": "NAM216",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "code": "NAM215",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "code": "NAM217",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "code": "NAM089",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "code": "COD843",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "code": "NAM141",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "code": "NUM098",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "code": "NUM099",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "code": "COD312",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "code": "NAM142",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "code": "COD313",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "code": "NUM364",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "code": "NUM092",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "code": "NAM221",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "code": "NUM008",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "code": "COD819",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          }
        ]
      },
      {
        "length": 310,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "code": "NUM013",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "code": "COD820",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "code": "DAT001",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "code": "DAT003",
            "description": "EINDDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "code": "COD367",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0410",
            "startPosition": 75
          },
          {
            "code": "COD860",
            "description": "PRESTATIECODE (GPH)",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0411",
            "startPosition": 78
          },
          {
            "code": "COD456",
            "description": "A-GPH-1 AANVULLENDE GENERIEKE PRODUCTCODE HULPMIDDELEN 1",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0412",
            "startPosition": 90
          },
          {
            "code": "COD537",
            "description": "A-GPH-2 AANVULLENDE GENERIEKE PRODUCTCODE HULPMIDDELEN 2",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0413",
            "startPosition": 96
          },
          {
            "code": "COD367",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0414",
            "startPosition": 102
          },
          {
            "code": "COD068",
            "description": "ARTIKELCODE HULPMIDDEL",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0415",
            "startPosition": 105
          },
          {
            "code": "NAM014",
            "description": "MERKNAAM",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0416",
            "startPosition": 117
          },
          {
            "code": "COD069",
            "description": "TYPE HULPMIDDEL",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0417",
            "startPosition": 137
          },
          {
            "code": "DAT190",
            "description": "DATUM AFLEVERING VOORGAAND HULPMIDDEL",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0418",
            "startPosition": 157
          },
          {
            "code": "COD064",
            "description": "INDICATIE MEDISCH VOORSCHRIFT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0419",
            "startPosition": 165
          },
          {
            "code": "DAT045",
            "description": "DATUM AFGIFTE MEDISCH VOORSCHRIFT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 166
          },
          {
            "code": "COD089",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0421",
            "startPosition": 174
          },
          {
            "code": "COD952",
            "description": "SPECIALISME BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0422",
            "startPosition": 182
          },
          {
            "code": "COD070",
            "description": "INDICATIE SAMENGESTELD MIDDEL (TOTAAL, BESTANDDEEL/DETAILINFORMATIE)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0423",
            "startPosition": 186
          },
          {
            "code": "COD071",
            "description": "INDICATIE POSITIE HULPMIDDEL",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0424",
            "startPosition": 187
          },
          {
            "code": "COD072",
            "description": "AFLEVERINGSEENHEID",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0425",
            "startPosition": 189
          },
          {
            "code": "ANT121",
            "description": "HOEVEELHEID AFGELEVERD IN AANGEGEVEN AFLEVEREENHEID",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0426",
            "startPosition": 191
          },
          {
            "code": "ANT122",
            "description": "HOEVEELHEID AFGELEVERD IN STUKS",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0427",
            "startPosition": 196
          },
          {
            "code": "COD076",
            "description": "SOORT KOSTEN HULPMIDDEL",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0428",
            "startPosition": 201
          },
          {
            "code": "BED153",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0429",
            "startPosition": 203
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0430",
            "startPosition": 211
          },
          {
            "code": "NUM352",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0431",
            "startPosition": 212
          },
          {
            "code": "BED023",
            "description": "BEDRAG ONTVANGEN EIGEN BIJDRAGE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0432",
            "startPosition": 216
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0433",
            "startPosition": 224
          },
          {
            "code": "BED142",
            "description": "DECLARATIEBEDRAG BASISVERZEKERING",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0434",
            "startPosition": 225
          },
          {
            "code": "COD672",
            "description": "INDICATIE DEBET/CREDIT (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0435",
            "startPosition": 233
          },
          {
            "code": "BED022",
            "description": "DECLARATIEBEDRAG AANVULLENDE VERZEKERING",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0436",
            "startPosition": 234
          },
          {
            "code": "COD673",
            "description": "INDICATIE DEBET/CREDIT (04)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0437",
            "startPosition": 242
          },
          {
            "code": "BED161",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0438",
            "startPosition": 243
          },
          {
            "code": "COD591",
            "description": "INDICATIE DEBET/CREDIT (05)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0439",
            "startPosition": 251
          },
          {
            "code": "NUM362",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0440",
            "startPosition": 252
          },
          {
            "code": "NUM363",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0441",
            "startPosition": 272
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 19,
            "lineElementId": "0480",
            "startPosition": 292
          }
        ]
      },
      {
        "length": 310,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "code": "NUM109",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "code": "OMS016",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          }
        ]
      },
      {
        "length": 310,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "code": "ANT085",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "code": "ANT086",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "code": "ANT087",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "code": "ANT089",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "code": "ANT265",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "code": "BED025",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "code": "COD043",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 265,
            "lineElementId": "9980",
            "startPosition": 46
          }
        ]
      }
    ]
  },
  {
    "description": "RETOURINFORMATIE DECLARATIE HULPMIDDELEN",
    "formatSubVersion": 2,
    "formatVersion": 5,
    "name": "LH308",
    "vektisEICode": 111,
    "lineTypes": [
      {
        "length": 370,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "code": "COD002",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "code": "NUM001",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "code": "NUM309",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "code": "COD856",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "code": "COD805",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "code": "NUM284",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "code": "COD377",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "code": "COD009",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "code": "COD181",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "code": "COD031",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "code": "COD833",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "code": "DAT043",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "code": "DAT044",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "code": "NUM029",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "code": "DAT031",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "code": "NUM351",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "code": "COD363",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          },
          {
            "code": "NUM370",
            "description": "REFERENTIENUMMER ZORGVERZEKERAAR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0181",
            "startPosition": 311
          },
          {
            "code": "DAT277",
            "description": "DAGTEKENING RETOURBERICHT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0182",
            "startPosition": 335
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0196",
            "startPosition": 343
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0197",
            "startPosition": 347
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0198",
            "startPosition": 351
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 16,
            "lineElementId": "0199",
            "startPosition": 355
          }
        ]
      },
      {
        "length": 370,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "code": "COD038",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "code": "DAT006",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "code": "COD134",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "code": "NAM193",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "code": "NAM194",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "code": "NAM191",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "code": "NAM192",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "code": "NAM025",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "code": "COD083",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "code": "NUM030",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "code": "NUM079",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "code": "COD090",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "code": "COD841",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 129,
            "lineElementId": "0280",
            "startPosition": 182
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0296",
            "startPosition": 311
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0297",
            "startPosition": 315
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0298",
            "startPosition": 319
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0299",
            "startPosition": 323
          }
        ]
      },
      {
        "length": 370,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "code": "DAT264",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "code": "COD446",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "code": "NAM214",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "code": "NAM216",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "code": "NAM215",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "code": "NAM217",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "code": "NAM089",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "code": "COD843",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "code": "NAM141",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "code": "NUM098",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "code": "NUM099",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "code": "COD312",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "code": "NAM142",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "code": "COD313",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "code": "NUM364",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "code": "NUM092",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "code": "NAM221",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "code": "NUM008",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "code": "COD819",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0396",
            "startPosition": 311
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0397",
            "startPosition": 315
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0398",
            "startPosition": 319
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0399",
            "startPosition": 323
          }
        ]
      },
      {
        "length": 370,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "code": "NUM013",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "code": "COD820",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "code": "DAT001",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "code": "DAT003",
            "description": "EINDDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "code": "COD367",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0410",
            "startPosition": 75
          },
          {
            "code": "COD860",
            "description": "PRESTATIECODE (GPH)",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0411",
            "startPosition": 78
          },
          {
            "code": "COD456",
            "description": "A-GPH-1 AANVULLENDE GENERIEKE PRODUCTCODE HULPMIDDELEN 1",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0412",
            "startPosition": 90
          },
          {
            "code": "COD537",
            "description": "A-GPH-2 AANVULLENDE GENERIEKE PRODUCTCODE HULPMIDDELEN 2",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0413",
            "startPosition": 96
          },
          {
            "code": "COD367",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0414",
            "startPosition": 102
          },
          {
            "code": "COD068",
            "description": "ARTIKELCODE HULPMIDDEL",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0415",
            "startPosition": 105
          },
          {
            "code": "NAM014",
            "description": "MERKNAAM",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0416",
            "startPosition": 117
          },
          {
            "code": "COD069",
            "description": "TYPE HULPMIDDEL",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0417",
            "startPosition": 137
          },
          {
            "code": "DAT190",
            "description": "DATUM AFLEVERING VOORGAAND HULPMIDDEL",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0418",
            "startPosition": 157
          },
          {
            "code": "COD064",
            "description": "INDICATIE MEDISCH VOORSCHRIFT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0419",
            "startPosition": 165
          },
          {
            "code": "DAT045",
            "description": "DATUM AFGIFTE MEDISCH VOORSCHRIFT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 166
          },
          {
            "code": "COD089",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0421",
            "startPosition": 174
          },
          {
            "code": "COD952",
            "description": "SPECIALISME BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0422",
            "startPosition": 182
          },
          {
            "code": "COD070",
            "description": "INDICATIE SAMENGESTELD MIDDEL (TOTAAL, BESTANDDEEL/DETAILINFORMATIE)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0423",
            "startPosition": 186
          },
          {
            "code": "COD071",
            "description": "INDICATIE POSITIE HULPMIDDEL",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0424",
            "startPosition": 187
          },
          {
            "code": "COD072",
            "description": "AFLEVERINGSEENHEID",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0425",
            "startPosition": 189
          },
          {
            "code": "ANT121",
            "description": "HOEVEELHEID AFGELEVERD IN AANGEGEVEN AFLEVEREENHEID",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0426",
            "startPosition": 191
          },
          {
            "code": "ANT122",
            "description": "HOEVEELHEID AFGELEVERD IN STUKS",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0427",
            "startPosition": 196
          },
          {
            "code": "COD076",
            "description": "SOORT KOSTEN HULPMIDDEL",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0428",
            "startPosition": 201
          },
          {
            "code": "BED153",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0429",
            "startPosition": 203
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0430",
            "startPosition": 211
          },
          {
            "code": "NUM352",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0431",
            "startPosition": 212
          },
          {
            "code": "BED023",
            "description": "BEDRAG ONTVANGEN EIGEN BIJDRAGE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0432",
            "startPosition": 216
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0433",
            "startPosition": 224
          },
          {
            "code": "BED142",
            "description": "DECLARATIEBEDRAG BASISVERZEKERING",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0434",
            "startPosition": 225
          },
          {
            "code": "COD672",
            "description": "INDICATIE DEBET/CREDIT (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0435",
            "startPosition": 233
          },
          {
            "code": "BED022",
            "description": "DECLARATIEBEDRAG AANVULLENDE VERZEKERING",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0436",
            "startPosition": 234
          },
          {
            "code": "COD673",
            "description": "INDICATIE DEBET/CREDIT (04)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0437",
            "startPosition": 242
          },
          {
            "code": "BED161",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0438",
            "startPosition": 243
          },
          {
            "code": "COD591",
            "description": "INDICATIE DEBET/CREDIT (05)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0439",
            "startPosition": 251
          },
          {
            "code": "NUM362",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0440",
            "startPosition": 252
          },
          {
            "code": "NUM363",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0441",
            "startPosition": 272
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 19,
            "lineElementId": "0480",
            "startPosition": 292
          },
          {
            "code": "BED165",
            "description": "BEREKEND BEDRAG ZORGVERZEKERAAR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0481",
            "startPosition": 311
          },
          {
            "code": "COD592",
            "description": "INDICATIE DEBET/CREDIT (06)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0482",
            "startPosition": 319
          },
          {
            "code": "BED166",
            "description": "TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0483",
            "startPosition": 320
          },
          {
            "code": "COD593",
            "description": "INDICATIE DEBET/CREDIT (07)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0484",
            "startPosition": 328
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0496",
            "startPosition": 329
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0497",
            "startPosition": 333
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0498",
            "startPosition": 337
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 30,
            "lineElementId": "0499",
            "startPosition": 341
          }
        ]
      },
      {
        "length": 370,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "code": "NUM109",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "code": "OMS016",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9896",
            "startPosition": 311
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9897",
            "startPosition": 315
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9898",
            "startPosition": 319
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "9899",
            "startPosition": 323
          }
        ]
      },
      {
        "length": 370,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "code": "ANT267",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "code": "ANT268",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "code": "ANT269",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "code": "ANT270",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "code": "ANT271",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "code": "BED168",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "code": "BED167",
            "description": "TOTAAL TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9909",
            "startPosition": 46
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9910",
            "startPosition": 57
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 313,
            "lineElementId": "9980",
            "startPosition": 58
          }
        ]
      }
    ]
  },
  {
    "description": "DECLARATIE MONDZORG",
    "formatSubVersion": 3,
    "formatVersion": 1,
    "name": "MZ301",
    "vektisEICode": 176,
    "lineTypes": [
      {
        "length": 310,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "code": "COD002",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "code": "NUM001",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "code": "NUM309",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "code": "COD856",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "code": "COD805",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "code": "NUM284",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "code": "COD377",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "code": "COD009",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "code": "COD181",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "code": "COD031",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "code": "COD833",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "code": "DAT043",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "code": "DAT044",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "code": "NUM029",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "code": "DAT031",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "code": "NUM351",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "code": "COD363",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          }
        ]
      },
      {
        "length": 310,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "code": "NUM366",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "code": "DAT006",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "code": "COD134",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "code": "NAM193",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "code": "NAM194",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "code": "NAM191",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "code": "NAM192",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "code": "NAM025",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "code": "COD083",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "code": "NUM030",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "code": "NUM079",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "code": "COD090",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "code": "COD841",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 129,
            "lineElementId": "0280",
            "startPosition": 182
          }
        ]
      },
      {
        "length": 310,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "code": "DAT264",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "code": "COD446",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "code": "NAM214",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "code": "NAM216",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "code": "NAM215",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "code": "NAM217",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "code": "NAM089",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "code": "COD843",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "code": "NAM141",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "code": "NUM098",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "code": "NUM099",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "code": "COD312",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "code": "NAM142",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "code": "COD313",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "code": "NUM364",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "code": "NUM092",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "code": "NAM221",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "code": "NUM008",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "code": "COD819",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          }
        ]
      },
      {
        "length": 310,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "code": "NUM013",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "code": "COD820",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "code": "DAT272",
            "description": "DATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "code": "COD853",
            "description": "INDICATIE SOORT PRESTATIERECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "code": "COD854",
            "description": "INDICATIE BIJZONDERE TANDHEELKUNDE",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0410",
            "startPosition": 69
          },
          {
            "code": "COD859",
            "description": "SOORT BIJZONDERE TANDHEELKUNDE",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0411",
            "startPosition": 70
          },
          {
            "code": "COD367",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0412",
            "startPosition": 73
          },
          {
            "code": "COD388",
            "description": "PRESTATIECODE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0413",
            "startPosition": 76
          },
          {
            "code": "COD176",
            "description": "INDICATIE BOVEN/ONDER TANDHEELKUNDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0414",
            "startPosition": 82
          },
          {
            "code": "COD040",
            "description": "GEBITSELEMENTCODE",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0415",
            "startPosition": 83
          },
          {
            "code": "COD041",
            "description": "VLAKCODE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0416",
            "startPosition": 85
          },
          {
            "code": "COD392",
            "description": "AANDUIDING DIAGNOSECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0417",
            "startPosition": 91
          },
          {
            "code": "COD852",
            "description": "DIAGNOSECODE BIJZONDERE TANDHEELKUNDE",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0418",
            "startPosition": 94
          },
          {
            "code": "COD183",
            "description": "INDICATIE ONGEVAL (ONGEVALSGEVOLG)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0419",
            "startPosition": 98
          },
          {
            "code": "COD089",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 99
          },
          {
            "code": "COD952",
            "description": "SPECIALISME BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0421",
            "startPosition": 107
          },
          {
            "code": "COD836",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0422",
            "startPosition": 111
          },
          {
            "code": "COD953",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0423",
            "startPosition": 119
          },
          {
            "code": "BED160",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0424",
            "startPosition": 123
          },
          {
            "code": "ANT054",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0425",
            "startPosition": 131
          },
          {
            "code": "BED153",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0426",
            "startPosition": 135
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0427",
            "startPosition": 143
          },
          {
            "code": "BED151",
            "description": "BEDRAG VERMINDERING BIJZONDERE TANDHEELKUNDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0428",
            "startPosition": 144
          },
          {
            "code": "NUM352",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0429",
            "startPosition": 152
          },
          {
            "code": "BED161",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0430",
            "startPosition": 156
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0431",
            "startPosition": 164
          },
          {
            "code": "NUM362",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0432",
            "startPosition": 165
          },
          {
            "code": "NUM363",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0433",
            "startPosition": 185
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 106,
            "lineElementId": "0480",
            "startPosition": 205
          }
        ]
      },
      {
        "length": 310,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "code": "NUM109",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "code": "OMS016",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          }
        ]
      },
      {
        "length": 310,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "code": "ANT085",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "code": "ANT086",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "code": "ANT087",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "code": "ANT089",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "code": "ANT265",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "code": "BED025",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "code": "COD043",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 265,
            "lineElementId": "9980",
            "startPosition": 46
          }
        ]
      }
    ]
  },
  {
    "description": "RETOURINFORMATIE DECLARATIE MONDZORG",
    "formatSubVersion": 3,
    "formatVersion": 1,
    "name": "MZ302",
    "vektisEICode": 177,
    "lineTypes": [
      {
        "length": 370,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "code": "COD002",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "code": "NUM001",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "code": "NUM309",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "code": "COD856",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "code": "COD805",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "code": "NUM284",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "code": "COD377",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "code": "COD009",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "code": "COD181",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "code": "COD031",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "code": "COD833",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "code": "DAT043",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "code": "DAT044",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "code": "NUM029",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "code": "DAT031",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "code": "NUM351",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "code": "COD363",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          },
          {
            "code": "NUM370",
            "description": "REFERENTIENUMMER ZORGVERZEKERAAR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0181",
            "startPosition": 311
          },
          {
            "code": "DAT277",
            "description": "DAGTEKENING RETOURBERICHT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0182",
            "startPosition": 335
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0196",
            "startPosition": 343
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0197",
            "startPosition": 347
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0198",
            "startPosition": 351
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 16,
            "lineElementId": "0199",
            "startPosition": 355
          }
        ]
      },
      {
        "length": 370,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "code": "NUM366",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "code": "DAT006",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "code": "COD134",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "code": "NAM193",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "code": "NAM194",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "code": "NAM191",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "code": "NAM192",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "code": "NAM025",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "code": "COD083",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "code": "NUM030",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "code": "NUM079",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "code": "COD090",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "code": "COD841",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 129,
            "lineElementId": "0280",
            "startPosition": 182
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0296",
            "startPosition": 311
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0297",
            "startPosition": 315
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0298",
            "startPosition": 319
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0299",
            "startPosition": 323
          }
        ]
      },
      {
        "length": 370,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "code": "DAT264",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "code": "COD446",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "code": "NAM214",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "code": "NAM216",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "code": "NAM215",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "code": "NAM217",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "code": "NAM089",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "code": "COD843",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "code": "NAM141",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "code": "NUM098",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "code": "NUM099",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "code": "COD312",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "code": "NAM142",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "code": "COD313",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "code": "NUM364",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "code": "NUM092",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "code": "NAM221",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "code": "NUM008",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "code": "COD819",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0396",
            "startPosition": 311
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0397",
            "startPosition": 315
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0398",
            "startPosition": 319
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0399",
            "startPosition": 323
          }
        ]
      },
      {
        "length": 370,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "code": "NUM013",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "code": "COD820",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "code": "DAT272",
            "description": "DATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "code": "COD853",
            "description": "INDICATIE SOORT PRESTATIERECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "code": "COD854",
            "description": "INDICATIE BIJZONDERE TANDHEELKUNDE",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0410",
            "startPosition": 69
          },
          {
            "code": "COD859",
            "description": "SOORT BIJZONDERE TANDHEELKUNDE",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0411",
            "startPosition": 70
          },
          {
            "code": "COD367",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0412",
            "startPosition": 73
          },
          {
            "code": "COD388",
            "description": "PRESTATIECODE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0413",
            "startPosition": 76
          },
          {
            "code": "COD176",
            "description": "INDICATIE BOVEN/ONDER TANDHEELKUNDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0414",
            "startPosition": 82
          },
          {
            "code": "COD040",
            "description": "GEBITSELEMENTCODE",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0415",
            "startPosition": 83
          },
          {
            "code": "COD041",
            "description": "VLAKCODE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0416",
            "startPosition": 85
          },
          {
            "code": "COD392",
            "description": "AANDUIDING DIAGNOSECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0417",
            "startPosition": 91
          },
          {
            "code": "COD852",
            "description": "DIAGNOSECODE BIJZONDERE TANDHEELKUNDE",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0418",
            "startPosition": 94
          },
          {
            "code": "COD183",
            "description": "INDICATIE ONGEVAL (ONGEVALSGEVOLG)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0419",
            "startPosition": 98
          },
          {
            "code": "COD089",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 99
          },
          {
            "code": "COD952",
            "description": "SPECIALISME BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0421",
            "startPosition": 107
          },
          {
            "code": "COD836",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0422",
            "startPosition": 111
          },
          {
            "code": "COD953",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0423",
            "startPosition": 119
          },
          {
            "code": "BED160",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0424",
            "startPosition": 123
          },
          {
            "code": "ANT054",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0425",
            "startPosition": 131
          },
          {
            "code": "BED153",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0426",
            "startPosition": 135
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0427",
            "startPosition": 143
          },
          {
            "code": "BED151",
            "description": "BEDRAG VERMINDERING BIJZONDERE TANDHEELKUNDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0428",
            "startPosition": 144
          },
          {
            "code": "NUM352",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0429",
            "startPosition": 152
          },
          {
            "code": "BED161",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0430",
            "startPosition": 156
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0431",
            "startPosition": 164
          },
          {
            "code": "NUM362",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0432",
            "startPosition": 165
          },
          {
            "code": "NUM363",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0433",
            "startPosition": 185
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 106,
            "lineElementId": "0480",
            "startPosition": 205
          },
          {
            "code": "BED165",
            "description": "BEREKEND BEDRAG ZORGVERZEKERAAR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0481",
            "startPosition": 311
          },
          {
            "code": "COD672",
            "description": "INDICATIE DEBET/CREDIT (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0482",
            "startPosition": 319
          },
          {
            "code": "BED166",
            "description": "TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0483",
            "startPosition": 320
          },
          {
            "code": "COD673",
            "description": "INDICATIE DEBET/CREDIT (04)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0484",
            "startPosition": 328
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0496",
            "startPosition": 329
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0497",
            "startPosition": 333
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0498",
            "startPosition": 337
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 30,
            "lineElementId": "0499",
            "startPosition": 341
          }
        ]
      },
      {
        "length": 370,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "code": "NUM109",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "code": "OMS016",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9896",
            "startPosition": 311
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9897",
            "startPosition": 315
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9898",
            "startPosition": 319
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "9899",
            "startPosition": 323
          }
        ]
      },
      {
        "length": 370,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "code": "ANT267",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "code": "ANT268",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "code": "ANT269",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "code": "ANT270",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "code": "ANT271",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "code": "BED168",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "code": "BED167",
            "description": "TOTAAL TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9909",
            "startPosition": 46
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9910",
            "startPosition": 57
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 313,
            "lineElementId": "9999",
            "startPosition": 58
          }
        ]
      }
    ]
  },
  {
    "description": "DECLARATIE ZORG OVERIGE SECTOREN",
    "formatSubVersion": 0,
    "formatVersion": 1,
    "name": "OS301",
    "vektisEICode": 185,
    "lineTypes": [
      {
        "length": 310,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "code": "COD002",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "code": "NUM001",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "code": "NUM309",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "code": "COD856",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "code": "COD805",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "code": "NUM284",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "code": "COD377",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "code": "COD009",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "code": "COD181",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "code": "COD031",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "code": "COD833",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "code": "DAT043",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "code": "DAT044",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "code": "NUM029",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "code": "DAT031",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "code": "NUM351",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "code": "COD363",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          }
        ]
      },
      {
        "length": 310,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "code": "NUM366",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "code": "DAT006",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "code": "COD134",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "code": "NAM193",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "code": "NAM194",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "code": "NAM191",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "code": "NAM192",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "code": "NAM025",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "code": "COD083",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "code": "NUM030",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "code": "NUM079",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "code": "COD090",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "code": "COD841",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 129,
            "lineElementId": "0280",
            "startPosition": 182
          }
        ]
      },
      {
        "length": 310,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "code": "DAT264",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "code": "COD446",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "code": "NAM214",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "code": "NAM216",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "code": "NAM215",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "code": "NAM217",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "code": "NAM089",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "code": "COD843",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "code": "NAM141",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "code": "NUM098",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "code": "NUM099",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "code": "COD312",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "code": "NAM142",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "code": "COD313",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "code": "NUM364",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "code": "NUM092",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "code": "NAM221",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "code": "NUM008",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "code": "COD819",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          }
        ]
      },
      {
        "length": 310,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "code": "NUM013",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "code": "COD820",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "code": "DAT001",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "code": "DAT003",
            "description": "EINDDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "code": "COD367",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0410",
            "startPosition": 75
          },
          {
            "code": "COD388",
            "description": "PRESTATIECODE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0411",
            "startPosition": 78
          },
          {
            "code": "ANT054",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0412",
            "startPosition": 83
          },
          {
            "code": "COD089",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0413",
            "startPosition": 87
          },
          {
            "code": "BED160",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0414",
            "startPosition": 95
          },
          {
            "code": "BED153",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0415",
            "startPosition": 103
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0416",
            "startPosition": 111
          },
          {
            "code": "NUM352",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0417",
            "startPosition": 112
          },
          {
            "code": "BED161",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0418",
            "startPosition": 116
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0419",
            "startPosition": 124
          },
          {
            "code": "NUM362",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0420",
            "startPosition": 125
          },
          {
            "code": "NUM363",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0421",
            "startPosition": 145
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 146,
            "lineElementId": "0480",
            "startPosition": 165
          }
        ]
      },
      {
        "length": 310,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "code": "NUM109",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "code": "OMS016",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          }
        ]
      },
      {
        "length": 310,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "code": "ANT085",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "code": "ANT086",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "code": "ANT087",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "code": "ANT089",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "code": "ANT265",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "code": "BED025",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "code": "COD043",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 265,
            "lineElementId": "9980",
            "startPosition": 46
          }
        ]
      }
    ]
  },
  {
    "description": "RETOURINFORMATIE DECLARATIE ZORG OVERIGE SECTOREN",
    "formatSubVersion": 0,
    "formatVersion": 1,
    "name": "OS302",
    "vektisEICode": 186,
    "lineTypes": [
      {
        "length": 370,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "code": "COD002",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "code": "NUM001",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "code": "NUM309",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "code": "COD856",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "code": "COD805",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "code": "NUM284",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "code": "COD377",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "code": "COD009",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "code": "COD181",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "code": "COD031",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "code": "COD833",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "code": "DAT043",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "code": "DAT044",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "code": "NUM029",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "code": "DAT031",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "code": "NUM351",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "code": "COD363",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          },
          {
            "code": "NUM370",
            "description": "REFERENTIENUMMER ZORGVERZEKERAAR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0181",
            "startPosition": 311
          },
          {
            "code": "DAT277",
            "description": "DAGTEKENING RETOURBERICHT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0182",
            "startPosition": 335
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0196",
            "startPosition": 343
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0197",
            "startPosition": 347
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0198",
            "startPosition": 351
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 16,
            "lineElementId": "0199",
            "startPosition": 355
          }
        ]
      },
      {
        "length": 370,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "code": "NUM366",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "code": "DAT006",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "code": "COD134",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "code": "NAM193",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "code": "NAM194",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "code": "NAM191",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "code": "NAM192",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "code": "NAM025",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "code": "COD083",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "code": "NUM030",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "code": "NUM079",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "code": "COD090",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "code": "COD841",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 129,
            "lineElementId": "0280",
            "startPosition": 182
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0296",
            "startPosition": 311
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0297",
            "startPosition": 315
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0298",
            "startPosition": 319
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0299",
            "startPosition": 323
          }
        ]
      },
      {
        "length": 370,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "code": "DAT264",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "code": "COD446",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "code": "NAM214",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "code": "NAM216",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "code": "NAM215",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "code": "NAM217",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "code": "NAM089",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "code": "COD843",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "code": "NAM141",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "code": "NUM098",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "code": "NUM099",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "code": "COD312",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "code": "NAM142",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "code": "COD313",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "code": "NUM364",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "code": "NUM092",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "code": "NAM221",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "code": "NUM008",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "code": "COD819",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0396",
            "startPosition": 311
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0397",
            "startPosition": 315
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0398",
            "startPosition": 319
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0399",
            "startPosition": 323
          }
        ]
      },
      {
        "length": 370,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "code": "NUM013",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "code": "COD820",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "code": "DAT001",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "code": "DAT003",
            "description": "EINDDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "code": "COD367",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0410",
            "startPosition": 75
          },
          {
            "code": "COD388",
            "description": "PRESTATIECODE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0411",
            "startPosition": 78
          },
          {
            "code": "ANT054",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0412",
            "startPosition": 83
          },
          {
            "code": "COD089",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0413",
            "startPosition": 87
          },
          {
            "code": "BED160",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0414",
            "startPosition": 95
          },
          {
            "code": "BED153",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0415",
            "startPosition": 103
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0416",
            "startPosition": 111
          },
          {
            "code": "NUM352",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0417",
            "startPosition": 112
          },
          {
            "code": "BED161",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0418",
            "startPosition": 116
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0419",
            "startPosition": 124
          },
          {
            "code": "NUM362",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0420",
            "startPosition": 125
          },
          {
            "code": "NUM363",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0421",
            "startPosition": 145
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 146,
            "lineElementId": "0480",
            "startPosition": 165
          },
          {
            "code": "BED165",
            "description": "BEREKEND BEDRAG ZORGVERZEKERAAR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0481",
            "startPosition": 311
          },
          {
            "code": "COD672",
            "description": "INDICATIE DEBET/CREDIT (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0482",
            "startPosition": 319
          },
          {
            "code": "BED166",
            "description": "TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0483",
            "startPosition": 320
          },
          {
            "code": "COD673",
            "description": "INDICATIE DEBET/CREDIT (04)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0484",
            "startPosition": 328
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0496",
            "startPosition": 329
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0497",
            "startPosition": 333
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0498",
            "startPosition": 337
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 30,
            "lineElementId": "0499",
            "startPosition": 341
          }
        ]
      },
      {
        "length": 370,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "code": "NUM109",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "code": "OMS016",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9896",
            "startPosition": 311
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9897",
            "startPosition": 315
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9898",
            "startPosition": 319
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "9899",
            "startPosition": 323
          }
        ]
      },
      {
        "length": 370,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "code": "ANT267",
            "description": "AANTAL VERZEKERDENRECORDS RETOUR",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "code": "ANT268",
            "description": "AANTAL DEBITEURRECORDS RETOUR",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "code": "ANT269",
            "description": "AANTAL PRESTATIERECORDS RETOUR",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "code": "ANT270",
            "description": "AANTAL COMMENTAARRECORDS RETOUR",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "code": "ANT271",
            "description": "TOTAAL AANTAL DETAILRECORDS RETOUR",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "code": "BED168",
            "description": "TOTAAL INGEDIEND DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "code": "BED167",
            "description": "TOTAAL TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9909",
            "startPosition": 46
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9910",
            "startPosition": 57
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 313,
            "lineElementId": "9980",
            "startPosition": 58
          }
        ]
      }
    ]
  },
  {
    "description": "DECLARATIE PARAMEDISCHE HULP",
    "formatSubVersion": 2,
    "formatVersion": 3,
    "name": "PM304",
    "vektisEICode": 107,
    "lineTypes": [
      {
        "length": 310,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "code": "COD002",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "code": "NUM001",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "code": "NUM309",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "code": "COD856",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "code": "COD805",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "code": "NUM284",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "code": "COD377",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "code": "COD009",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "code": "COD181",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "code": "COD031",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "code": "COD833",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "code": "DAT043",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "code": "DAT044",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "code": "NUM029",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "code": "DAT031",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "code": "NUM351",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "code": "COD363",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          }
        ]
      },
      {
        "length": 310,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "code": "COD038",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "code": "DAT006",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "code": "COD134",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "code": "NAM193",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "code": "NAM194",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "code": "NAM191",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "code": "NAM192",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "code": "NAM025",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "code": "COD083",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "code": "NUM030",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "code": "NUM079",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "code": "COD090",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 130,
            "lineElementId": "0280",
            "startPosition": 181
          }
        ]
      },
      {
        "length": 310,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "code": "DAT264",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "code": "COD446",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "code": "NAM214",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "code": "NAM216",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "code": "NAM215",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "code": "NAM217",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "code": "NAM089",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "code": "COD843",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "code": "NAM141",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "code": "NUM098",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "code": "NUM099",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "code": "COD312",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "code": "NAM142",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "code": "COD313",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "code": "NUM364",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "code": "NUM092",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "code": "NAM221",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "code": "NUM008",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "code": "COD819",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          }
        ]
      },
      {
        "length": 310,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "code": "NUM013",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "code": "COD820",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "code": "DAT272",
            "description": "DATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "code": "COD367",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "code": "COD388",
            "description": "PRESTATIECODE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0410",
            "startPosition": 70
          },
          {
            "code": "ANT054",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0411",
            "startPosition": 76
          },
          {
            "code": "COD183",
            "description": "INDICATIE ONGEVAL (ONGEVALSGEVOLG)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0412",
            "startPosition": 80
          },
          {
            "code": "COD696",
            "description": "AANDUIDING DIAGNOSECODELIJST (01)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0413",
            "startPosition": 81
          },
          {
            "code": "COD697",
            "description": "VERWIJSDIAGNOSECODE PARAMEDISCHE HULP (01)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0414",
            "startPosition": 84
          },
          {
            "code": "COD687",
            "description": "AANDUIDING DIAGNOSECODELIJST (02)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0415",
            "startPosition": 92
          },
          {
            "code": "COD690",
            "description": "VERWIJSDIAGNOSECODE PARAMEDISCHE HULP (02)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0416",
            "startPosition": 95
          },
          {
            "code": "COD688",
            "description": "AANDUIDING DIAGNOSECODELIJST (03)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0417",
            "startPosition": 103
          },
          {
            "code": "COD597",
            "description": "PARAMEDISCHE DIAGNOSECODE (01)",
            "fieldType": "AN",
            "length": 8,
            "lineElementId": "0418",
            "startPosition": 106
          },
          {
            "code": "COD689",
            "description": "AANDUIDING DIAGNOSECODELIJST (04)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0419",
            "startPosition": 114
          },
          {
            "code": "COD691",
            "description": "PARAMEDISCHE DIAGNOSECODE (02)",
            "fieldType": "AN",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 117
          },
          {
            "code": "COD321",
            "description": "CODE SOORT INDICATIE PARAMEDISCHE HULP",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0421",
            "startPosition": 125
          },
          {
            "code": "COD089",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0422",
            "startPosition": 128
          },
          {
            "code": "COD952",
            "description": "SPECIALISME BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0423",
            "startPosition": 136
          },
          {
            "code": "DAT062",
            "description": "VERWIJSDATUM",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0424",
            "startPosition": 140
          },
          {
            "code": "COD836",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0425",
            "startPosition": 148
          },
          {
            "code": "COD953",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0426",
            "startPosition": 156
          },
          {
            "code": "COD217",
            "description": "REDEN EINDE ZORG",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0427",
            "startPosition": 160
          },
          {
            "code": "BED160",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0428",
            "startPosition": 162
          },
          {
            "code": "BED153",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0429",
            "startPosition": 170
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0430",
            "startPosition": 178
          },
          {
            "code": "NUM352",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0431",
            "startPosition": 179
          },
          {
            "code": "BED161",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0432",
            "startPosition": 183
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0433",
            "startPosition": 191
          },
          {
            "code": "NUM362",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0434",
            "startPosition": 192
          },
          {
            "code": "NUM363",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0435",
            "startPosition": 212
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 79,
            "lineElementId": "0480",
            "startPosition": 232
          }
        ]
      },
      {
        "length": 310,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "code": "NUM109",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "code": "OMS016",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          }
        ]
      },
      {
        "length": 310,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "code": "ANT085",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "code": "ANT086",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "code": "ANT087",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "code": "ANT089",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "code": "ANT265",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "code": "BED025",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "code": "COD043",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 265,
            "lineElementId": "9980",
            "startPosition": 46
          }
        ]
      }
    ]
  },
  {
    "description": "RETOURINFORMATIE DECLARATIE PARAMEDISCHE HULP",
    "formatSubVersion": 2,
    "formatVersion": 3,
    "name": "PM305",
    "vektisEICode": 108,
    "lineTypes": [
      {
        "length": 370,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "code": "COD002",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "code": "NUM001",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "code": "NUM309",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "code": "COD856",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "code": "COD805",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "code": "NUM284",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "code": "COD377",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "code": "COD009",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "code": "COD181",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "code": "COD031",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "code": "COD833",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "code": "DAT043",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "code": "DAT044",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "code": "NUM029",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "code": "DAT031",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "code": "NUM351",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "code": "COD363",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          },
          {
            "code": "NUM370",
            "description": "REFERENTIENUMMER ZORGVERZEKERAAR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0181",
            "startPosition": 311
          },
          {
            "code": "DAT277",
            "description": "DAGTEKENING RETOURBERICHT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0182",
            "startPosition": 335
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0196",
            "startPosition": 343
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0197",
            "startPosition": 347
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0198",
            "startPosition": 351
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 16,
            "lineElementId": "0199",
            "startPosition": 355
          }
        ]
      },
      {
        "length": 370,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "code": "COD038",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "code": "DAT006",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "code": "COD134",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "code": "NAM193",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "code": "NAM194",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "code": "NAM191",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "code": "NAM192",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "code": "NAM025",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "code": "COD083",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "code": "NUM030",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "code": "NUM079",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "code": "COD090",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 130,
            "lineElementId": "0280",
            "startPosition": 181
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0296",
            "startPosition": 311
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0297",
            "startPosition": 315
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0298",
            "startPosition": 319
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0299",
            "startPosition": 323
          }
        ]
      },
      {
        "length": 370,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "code": "DAT264",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "code": "COD446",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "code": "NAM214",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "code": "NAM216",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "code": "NAM215",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "code": "NAM217",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "code": "NAM089",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "code": "COD843",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "code": "NAM141",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "code": "NUM098",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "code": "NUM099",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "code": "COD312",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "code": "NAM142",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "code": "COD313",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "code": "NUM364",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "code": "NUM092",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "code": "NAM221",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "code": "NUM008",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "code": "COD819",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 311
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0396",
            "startPosition": 324
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0397",
            "startPosition": 328
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0398",
            "startPosition": 332
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0399",
            "startPosition": 336
          }
        ]
      },
      {
        "length": 370,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "code": "NUM013",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "code": "COD820",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "code": "DAT272",
            "description": "DATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "code": "COD367",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "code": "COD388",
            "description": "PRESTATIECODE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0410",
            "startPosition": 70
          },
          {
            "code": "ANT054",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0411",
            "startPosition": 76
          },
          {
            "code": "COD183",
            "description": "INDICATIE ONGEVAL (ONGEVALSGEVOLG)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0412",
            "startPosition": 80
          },
          {
            "code": "COD696",
            "description": "AANDUIDING DIAGNOSECODELIJST (01)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0413",
            "startPosition": 81
          },
          {
            "code": "COD697",
            "description": "VERWIJSDIAGNOSECODE PARAMEDISCHE HULP (01)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0414",
            "startPosition": 84
          },
          {
            "code": "COD687",
            "description": "AANDUIDING DIAGNOSECODELIJST (02)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0415",
            "startPosition": 92
          },
          {
            "code": "COD690",
            "description": "VERWIJSDIAGNOSECODE PARAMEDISCHE HULP (02)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0416",
            "startPosition": 95
          },
          {
            "code": "COD688",
            "description": "AANDUIDING DIAGNOSECODELIJST (03)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0417",
            "startPosition": 103
          },
          {
            "code": "COD597",
            "description": "PARAMEDISCHE DIAGNOSECODE (01)",
            "fieldType": "AN",
            "length": 8,
            "lineElementId": "0418",
            "startPosition": 106
          },
          {
            "code": "COD689",
            "description": "AANDUIDING DIAGNOSECODELIJST (04)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0419",
            "startPosition": 114
          },
          {
            "code": "COD691",
            "description": "PARAMEDISCHE DIAGNOSECODE (02)",
            "fieldType": "AN",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 117
          },
          {
            "code": "COD321",
            "description": "CODE SOORT INDICATIE PARAMEDISCHE HULP",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0421",
            "startPosition": 125
          },
          {
            "code": "COD089",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0422",
            "startPosition": 128
          },
          {
            "code": "COD952",
            "description": "SPECIALISME BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0423",
            "startPosition": 136
          },
          {
            "code": "DAT062",
            "description": "VERWIJSDATUM",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0424",
            "startPosition": 140
          },
          {
            "code": "COD836",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0425",
            "startPosition": 148
          },
          {
            "code": "COD953",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0426",
            "startPosition": 156
          },
          {
            "code": "COD217",
            "description": "REDEN EINDE ZORG",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0427",
            "startPosition": 160
          },
          {
            "code": "BED160",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0428",
            "startPosition": 162
          },
          {
            "code": "BED153",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0429",
            "startPosition": 170
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0430",
            "startPosition": 178
          },
          {
            "code": "NUM352",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0431",
            "startPosition": 179
          },
          {
            "code": "BED161",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0432",
            "startPosition": 183
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0433",
            "startPosition": 191
          },
          {
            "code": "NUM362",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0434",
            "startPosition": 192
          },
          {
            "code": "NUM363",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0435",
            "startPosition": 212
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 79,
            "lineElementId": "0480",
            "startPosition": 232
          },
          {
            "code": "BED165",
            "description": "BEREKEND BEDRAG ZORGVERZEKERAAR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0481",
            "startPosition": 311
          },
          {
            "code": "COD672",
            "description": "INDICATIE DEBET/CREDIT (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0482",
            "startPosition": 319
          },
          {
            "code": "BED166",
            "description": "TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0483",
            "startPosition": 320
          },
          {
            "code": "COD673",
            "description": "INDICATIE DEBET/CREDIT (04)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0484",
            "startPosition": 328
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0496",
            "startPosition": 329
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0497",
            "startPosition": 333
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0498",
            "startPosition": 337
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 30,
            "lineElementId": "0499",
            "startPosition": 341
          }
        ]
      },
      {
        "length": 370,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "code": "NUM109",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "code": "OMS016",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9896",
            "startPosition": 311
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9897",
            "startPosition": 315
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9898",
            "startPosition": 319
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "9899",
            "startPosition": 323
          }
        ]
      },
      {
        "length": 370,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "code": "ANT267",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "code": "ANT268",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "code": "ANT269",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "code": "ANT270",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "code": "ANT271",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "code": "BED168",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "code": "BED167",
            "description": "TOTAAL TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9909",
            "startPosition": 46
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9910",
            "startPosition": 57
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 313,
            "lineElementId": "9980",
            "startPosition": 58
          }
        ]
      }
    ]
  },
  {
    "description": "DEBITEURRECORD bij DECLARATIEBERICHTEN",
    "formatSubVersion": 0,
    "formatVersion": 1,
    "name": "SB311",
    "vektisEICode": 901,
    "lineTypes": [
      {
        "length": 310,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "code": "DAT264",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "code": "COD446",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "code": "NAM214",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "code": "NAM216",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "code": "NAM215",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "code": "NAM217",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "code": "NAM089",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "code": "COD843",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "code": "NAM141",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "code": "NUM098",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "code": "NUM099",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "code": "COD312",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "code": "NAM142",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "code": "COD313",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "code": "NUM364",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "code": "NUM092",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "code": "NAM221",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 50,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "code": "NUM406",
            "description": "IBAN",
            "fieldType": "AN",
            "length": 34,
            "lineElementId": "0325",
            "startPosition": 260
          },
          {
            "code": "COD819",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 294
          },
          {
            "code": "COD908",
            "description": "CODE INCASSO",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0327",
            "startPosition": 296
          },
          {
            "code": "NUM413",
            "description": "VERSIENUMMER DEBITEURRECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0328",
            "startPosition": 298
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 0,
            "lineElementId": "0380",
            "startPosition": 300
          }
        ]
      }
    ]
  },
  {
    "description": "DEBITEURRECORD bij DECLARATIEBERICHTEN",
    "formatSubVersion": 0,
    "formatVersion": 2,
    "name": "SB311",
    "vektisEICode": 902,
    "lineTypes": [
      {
        "length": 310,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "code": "DAT264",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "code": "COD446",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "code": "NAM214",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "code": "NAM216",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "code": "NAM215",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "code": "NAM217",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "code": "NAM089",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "code": "COD843",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "code": "NAM141",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "code": "NUM098",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "code": "NUM099",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "code": "COD312",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "code": "NAM142",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "code": "COD313",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "code": "NUM364",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "code": "NUM092",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "code": "NAM221",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 50,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "code": "NUM406",
            "description": "IBAN",
            "fieldType": "AN",
            "length": 34,
            "lineElementId": "0325",
            "startPosition": 260
          },
          {
            "code": "COD819",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 294
          },
          {
            "code": "COD908",
            "description": "CODE INCASSO",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0327",
            "startPosition": 296
          },
          {
            "code": "NUM413",
            "description": "VERSIENUMMER DEBITEURRECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0328",
            "startPosition": 298
          },
          {
            "code": "DAT320",
            "description": "MACHTIGINGSDATUM AUTOMATISCHE INCASSO",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0329",
            "startPosition": 300
          },
          {
            "code": "COD655",
            "description": "FACTURATIEVORM",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0330",
            "startPosition": 308
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 0,
            "lineElementId": "0380",
            "startPosition": 309
          }
        ]
      }
    ]
  },
  {
    "description": "DECLARATIE VERLOSKUNDIGE HULP",
    "formatSubVersion": 2,
    "formatVersion": 2,
    "name": "VK301",
    "vektisEICode": 141,
    "lineTypes": [
      {
        "length": 310,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "code": "COD002",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "code": "NUM001",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "code": "NUM309",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "code": "COD856",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "code": "COD805",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "code": "NUM284",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "code": "COD377",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "code": "COD009",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "code": "COD181",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "code": "COD031",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "code": "COD833",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "code": "DAT043",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "code": "DAT044",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "code": "NUM029",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "code": "DAT031",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "code": "NUM351",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "code": "COD363",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          }
        ]
      },
      {
        "length": 310,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "code": "COD038",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "code": "DAT006",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "code": "COD134",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "code": "NAM193",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "code": "NAM194",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "code": "NAM191",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "code": "NAM192",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "code": "NAM025",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "code": "COD083",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "code": "NUM030",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "code": "NUM079",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "code": "COD090",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "code": "COD841",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 129,
            "lineElementId": "0280",
            "startPosition": 182
          }
        ]
      },
      {
        "length": 310,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "code": "DAT264",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "code": "COD446",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "code": "NAM214",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "code": "NAM216",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "code": "NAM215",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "code": "NAM217",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "code": "NAM089",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "code": "COD843",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "code": "NAM141",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "code": "NUM098",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "code": "NUM099",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "code": "COD312",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "code": "NAM142",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "code": "COD313",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "code": "NUM364",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "code": "NUM092",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "code": "NAM221",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "code": "NUM008",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "code": "COD819",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          }
        ]
      },
      {
        "length": 310,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "code": "NUM013",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "code": "COD820",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "code": "COD723",
            "description": "INDICATIE MEDIUM RISK VERLOSKUNDIGE ZORG",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "code": "COD599",
            "description": "INDICATIE OVERNAME VERLOSKUNDIGE ZORG",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0409",
            "startPosition": 60
          },
          {
            "code": "COD598",
            "description": "ZORGVERLENERSCODE VORIGE ZORGVERLENER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0410",
            "startPosition": 61
          },
          {
            "code": "COD528",
            "description": "ZORGVERLENERSSPECIFICATIE VORIGE ZORGVERLENER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0411",
            "startPosition": 69
          },
          {
            "code": "DAT001",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0412",
            "startPosition": 73
          },
          {
            "code": "DAT003",
            "description": "EINDDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0413",
            "startPosition": 81
          },
          {
            "code": "DAT221",
            "description": "DATUM PARTUS (BEVALLINGSDATUM)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0414",
            "startPosition": 89
          },
          {
            "code": "COD367",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0415",
            "startPosition": 97
          },
          {
            "code": "COD388",
            "description": "PRESTATIECODE",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0416",
            "startPosition": 100
          },
          {
            "code": "COD089",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0417",
            "startPosition": 104
          },
          {
            "code": "COD952",
            "description": "SPECIALISME BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0418",
            "startPosition": 112
          },
          {
            "code": "COD836",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0419",
            "startPosition": 116
          },
          {
            "code": "COD953",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0420",
            "startPosition": 124
          },
          {
            "code": "ANT054",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0421",
            "startPosition": 128
          },
          {
            "code": "COD218",
            "description": "TIJDSEENHEID ZORGPERIODE",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0422",
            "startPosition": 132
          },
          {
            "code": "BED160",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0423",
            "startPosition": 134
          },
          {
            "code": "BED153",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0424",
            "startPosition": 142
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0425",
            "startPosition": 150
          },
          {
            "code": "NUM352",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0426",
            "startPosition": 151
          },
          {
            "code": "BED161",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0427",
            "startPosition": 155
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0428",
            "startPosition": 163
          },
          {
            "code": "NUM362",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0429",
            "startPosition": 164
          },
          {
            "code": "NUM363",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0430",
            "startPosition": 184
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 107,
            "lineElementId": "0480",
            "startPosition": 204
          }
        ]
      },
      {
        "length": 310,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "code": "NUM109",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "code": "OMS016",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          }
        ]
      },
      {
        "length": 310,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "code": "ANT085",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "code": "ANT086",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "code": "ANT087",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "code": "ANT089",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "code": "ANT265",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "code": "BED025",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "code": "COD043",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 265,
            "lineElementId": "9980",
            "startPosition": 46
          }
        ]
      }
    ]
  },
  {
    "description": "RETOURINFORMATIE DECLARATIE VERLOSKUNDIGE HULP",
    "formatSubVersion": 2,
    "formatVersion": 2,
    "name": "VK302",
    "vektisEICode": 142,
    "lineTypes": [
      {
        "length": 370,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "code": "COD002",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "code": "NUM001",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "code": "NUM309",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "code": "COD856",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "code": "COD805",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "code": "NUM284",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "code": "COD377",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "code": "COD009",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "code": "COD181",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "code": "COD031",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "code": "COD833",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "code": "DAT043",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "code": "DAT044",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "code": "NUM029",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "code": "DAT031",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "code": "NUM351",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "code": "COD363",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          },
          {
            "code": "NUM370",
            "description": "REFERENTIENUMMER ZORGVERZEKERAAR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0181",
            "startPosition": 311
          },
          {
            "code": "DAT277",
            "description": "DAGTEKENING RETOURBERICHT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0182",
            "startPosition": 335
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0196",
            "startPosition": 343
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0197",
            "startPosition": 347
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0198",
            "startPosition": 351
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 16,
            "lineElementId": "0199",
            "startPosition": 355
          }
        ]
      },
      {
        "length": 370,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "code": "COD038",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "code": "DAT006",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "code": "COD134",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "code": "NAM193",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "code": "NAM194",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "code": "NAM191",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "code": "NAM192",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "code": "NAM025",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "code": "COD083",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "code": "NUM030",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "code": "NUM079",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "code": "COD090",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "code": "COD841",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 129,
            "lineElementId": "0280",
            "startPosition": 182
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0296",
            "startPosition": 311
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0297",
            "startPosition": 315
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0298",
            "startPosition": 319
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0299",
            "startPosition": 323
          }
        ]
      },
      {
        "length": 370,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "code": "DAT264",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "code": "COD446",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "code": "NAM214",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "code": "NAM216",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "code": "NAM215",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "code": "NAM217",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "code": "NAM089",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "code": "COD843",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "code": "NAM141",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "code": "NUM098",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "code": "NUM099",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "code": "COD312",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "code": "NAM142",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "code": "COD313",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "code": "NUM364",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "code": "NUM092",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "code": "NAM221",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "code": "NUM008",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "code": "COD819",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0396",
            "startPosition": 311
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0397",
            "startPosition": 315
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0398",
            "startPosition": 319
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0399",
            "startPosition": 323
          }
        ]
      },
      {
        "length": 370,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "code": "NUM013",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "code": "COD820",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "code": "COD723",
            "description": "INDICATIE MEDIUM RISK VERLOSKUNDIGE ZORG",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "code": "COD599",
            "description": "INDICATIE OVERNAME VERLOSKUNDIGE ZORG",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0409",
            "startPosition": 60
          },
          {
            "code": "COD598",
            "description": "ZORGVERLENERSCODE VORIGE ZORGVERLENER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0410",
            "startPosition": 61
          },
          {
            "code": "COD528",
            "description": "ZORGVERLENERSSPECIFICATIE VORIGE ZORGVERLENER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0411",
            "startPosition": 69
          },
          {
            "code": "DAT001",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0412",
            "startPosition": 73
          },
          {
            "code": "DAT003",
            "description": "EINDDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0413",
            "startPosition": 81
          },
          {
            "code": "DAT221",
            "description": "DATUM PARTUS (BEVALLINGSDATUM)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0414",
            "startPosition": 89
          },
          {
            "code": "COD367",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0415",
            "startPosition": 97
          },
          {
            "code": "COD388",
            "description": "PRESTATIECODE",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0416",
            "startPosition": 100
          },
          {
            "code": "COD089",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0417",
            "startPosition": 104
          },
          {
            "code": "COD952",
            "description": "SPECIALISME BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0418",
            "startPosition": 112
          },
          {
            "code": "COD836",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0419",
            "startPosition": 116
          },
          {
            "code": "COD953",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0420",
            "startPosition": 124
          },
          {
            "code": "ANT054",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0421",
            "startPosition": 128
          },
          {
            "code": "COD218",
            "description": "TIJDSEENHEID ZORGPERIODE",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0422",
            "startPosition": 132
          },
          {
            "code": "BED160",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0423",
            "startPosition": 134
          },
          {
            "code": "BED153",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0424",
            "startPosition": 142
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0425",
            "startPosition": 150
          },
          {
            "code": "NUM352",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0426",
            "startPosition": 151
          },
          {
            "code": "BED161",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0427",
            "startPosition": 155
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0428",
            "startPosition": 163
          },
          {
            "code": "NUM362",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0429",
            "startPosition": 164
          },
          {
            "code": "NUM363",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0430",
            "startPosition": 184
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 107,
            "lineElementId": "0480",
            "startPosition": 204
          },
          {
            "code": "BED165",
            "description": "BEREKEND BEDRAG ZORGVERZEKERAAR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0481",
            "startPosition": 311
          },
          {
            "code": "COD672",
            "description": "INDICATIE DEBET/CREDIT (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0482",
            "startPosition": 319
          },
          {
            "code": "BED166",
            "description": "TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0483",
            "startPosition": 320
          },
          {
            "code": "COD673",
            "description": "INDICATIE DEBET/CREDIT (04)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0484",
            "startPosition": 328
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0496",
            "startPosition": 329
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0497",
            "startPosition": 333
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0498",
            "startPosition": 337
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 30,
            "lineElementId": "0499",
            "startPosition": 341
          }
        ]
      },
      {
        "length": 370,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "code": "NUM109",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "code": "OMS016",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9896",
            "startPosition": 311
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9897",
            "startPosition": 315
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9898",
            "startPosition": 319
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "9899",
            "startPosition": 323
          }
        ]
      },
      {
        "length": 370,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "code": "ANT267",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "code": "ANT268",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "code": "ANT269",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "code": "ANT270",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "code": "ANT271",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "code": "BED168",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "code": "BED167",
            "description": "TOTAAL TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9909",
            "startPosition": 46
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9910",
            "startPosition": 57
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 313,
            "lineElementId": "9980",
            "startPosition": 46
          }
        ]
      }
    ]
  },
  {
    "description": "DECLARATIE DBC/ZIEKENHUISZORG",
    "formatSubVersion": 0,
    "formatVersion": 8,
    "name": "ZH308",
    "vektisEICode": 101,
    "lineTypes": [
      {
        "length": 570,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "code": "COD002",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "code": "NUM001",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "code": "NUM309",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "code": "COD856",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "code": "COD805",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "code": "NUM284",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "code": "COD377",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "code": "COD009",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "code": "COD181",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "code": "COD031",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "code": "COD833",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "code": "DAT043",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "code": "DAT044",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "code": "NUM029",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "code": "DAT031",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "code": "NUM351",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "code": "COD363",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 453,
            "lineElementId": "0180",
            "startPosition": 118
          }
        ]
      },
      {
        "length": 570,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "code": "NUM366",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "code": "DAT006",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "code": "COD134",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "code": "NAM193",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "code": "NAM194",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "code": "NAM191",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "code": "NAM192",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "code": "NAM025",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "code": "COD083",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "code": "NUM030",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "code": "NUM079",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "code": "COD090",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "code": "COD841",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 389,
            "lineElementId": "0280",
            "startPosition": 182
          }
        ]
      },
      {
        "length": 570,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "code": "DAT264",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "code": "COD446",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "code": "NAM214",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "code": "NAM216",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "code": "NAM215",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "code": "NAM217",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "code": "NAM089",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "code": "COD843",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "code": "NAM141",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "code": "NUM098",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "code": "NUM099",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "code": "COD312",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "code": "NAM142",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "code": "COD313",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "code": "NUM364",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "code": "NUM092",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "code": "NAM221",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "code": "NUM008",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "code": "COD819",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 273,
            "lineElementId": "0380",
            "startPosition": 298
          }
        ]
      },
      {
        "length": 570,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "code": "NUM013",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "code": "COD150",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "code": "COD367",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "code": "COD695",
            "description": "PRESTATIECODE/DBC DECLARATIECODE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0409",
            "startPosition": 62
          },
          {
            "code": "DAT001",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0410",
            "startPosition": 68
          },
          {
            "code": "DAT003",
            "description": "EINDDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0411",
            "startPosition": 76
          },
          {
            "code": "NUM123",
            "description": "PRESTATIEVOLGNUMMER",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0412",
            "startPosition": 84
          },
          {
            "code": "COD988",
            "description": "ZORGPRODUCTCODE",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0413",
            "startPosition": 86
          },
          {
            "code": "NUM368",
            "description": "ZORGTRAJECTNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0414",
            "startPosition": 95
          },
          {
            "code": "DAT291",
            "description": "BEGINDATUM ZORGTRAJECT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0415",
            "startPosition": 110
          },
          {
            "code": "DAT292",
            "description": "EINDDATUM ZORGTRAJECT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0416",
            "startPosition": 118
          },
          {
            "code": "COD990",
            "description": "AFSLUITREDEN ZORGTRAJECT/SUBTRAJECT",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0417",
            "startPosition": 126
          },
          {
            "code": "NUM379",
            "description": "SUBTRAJECTNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0418",
            "startPosition": 128
          },
          {
            "code": "COD327",
            "description": "CODE (ZELF)VERWIJZER",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0419",
            "startPosition": 143
          },
          {
            "code": "COD836",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 145
          },
          {
            "code": "COD953",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0421",
            "startPosition": 153
          },
          {
            "code": "NUM369",
            "description": "VERWIJZEND ZORGTRAJECTNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0422",
            "startPosition": 157
          },
          {
            "code": "ANT054",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0423",
            "startPosition": 172
          },
          {
            "code": "COD788",
            "description": "ZORGTYPECODE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0424",
            "startPosition": 176
          },
          {
            "code": "COD074",
            "description": "SOORT ZORGVRAAG",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0425",
            "startPosition": 182
          },
          {
            "code": "COD789",
            "description": "ZORGVRAAGCODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0426",
            "startPosition": 183
          },
          {
            "code": "COD075",
            "description": "SOORT DIAGNOSE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0427",
            "startPosition": 186
          },
          {
            "code": "COD127",
            "description": "DIAGNOSECODE",
            "fieldType": "AN",
            "length": 7,
            "lineElementId": "0428",
            "startPosition": 187
          },
          {
            "code": "COD994",
            "description": "INDICATIE AANSPRAAK ZORGVERZEKERINGSWET TOEGEPAST",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0429",
            "startPosition": 194
          },
          {
            "code": "COD276",
            "description": "TOELICHTING PRESTATIE",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0430",
            "startPosition": 195
          },
          {
            "code": "COD274",
            "description": "ACCEPTATIE TERMIJNOVERSCHRIJDING HERDECLARATIE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0431",
            "startPosition": 198
          },
          {
            "code": "COD224",
            "description": "INDICATIE MACHTIGING",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0432",
            "startPosition": 199
          },
          {
            "code": "COD227",
            "description": "INDICATIE PRODUCTTYPERENDE ORANJE VERRICHTING IN HET PROFIEL",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0433",
            "startPosition": 200
          },
          {
            "code": "COD286",
            "description": "ZORGVERLENERSSPECIFICATIE BEHANDELAAR/UITVOERDER (SUBBEROEPSGROEP)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0434",
            "startPosition": 201
          },
          {
            "code": "COD031",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0435",
            "startPosition": 205
          },
          {
            "code": "COD989",
            "description": "HASHTOTAAL ZV",
            "fieldType": "AN",
            "length": 200,
            "lineElementId": "0436",
            "startPosition": 213
          },
          {
            "code": "NUM383",
            "description": "HASHVERSIE ZV",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0437",
            "startPosition": 413
          },
          {
            "code": "NUM384",
            "description": "CERTIFICAATVERSIE HASH",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0438",
            "startPosition": 425
          },
          {
            "code": "COD153",
            "description": "GROUPERIDENTIFICATIE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0439",
            "startPosition": 437
          },
          {
            "code": "NUM385",
            "description": "GROUPERVERSIE",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0440",
            "startPosition": 440
          },
          {
            "code": "NUM386",
            "description": "TABELSETVERSIE GROUPER",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0441",
            "startPosition": 452
          },
          {
            "code": "COD328",
            "description": "GROUPERWERKOMGEVING",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0442",
            "startPosition": 472
          },
          {
            "code": "COD329",
            "description": "ZORGACTIVITEITCODE",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0443",
            "startPosition": 473
          },
          {
            "code": "COD099",
            "description": "ZORGACTIVITEITNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0444",
            "startPosition": 483
          },
          {
            "code": "COD100",
            "description": "ZORGPADCODE",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0445",
            "startPosition": 498
          },
          {
            "code": "COD392",
            "description": "AANDUIDING DIAGNOSECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0446",
            "startPosition": 500
          },
          {
            "code": "COD185",
            "description": "VERWIJSDIAGNOSECODE PARAMEDISCHE HULP",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0447",
            "startPosition": 503
          },
          {
            "code": "COD321",
            "description": "CODE SOORT INDICATIE PARAMEDISCHE HULP",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0448",
            "startPosition": 511
          },
          {
            "code": "COD119",
            "description": "INDICATIE TWEEDE OPERATIE ZELFDE AANDOENING PARAMEDISCHE HULP",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0449",
            "startPosition": 514
          },
          {
            "code": "COD217",
            "description": "REDEN EINDE ZORG",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0450",
            "startPosition": 515
          },
          {
            "code": "COD183",
            "description": "INDICATIE ONGEVAL (ONGEVALSGEVOLG)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0451",
            "startPosition": 517
          },
          {
            "code": "COD043",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0452",
            "startPosition": 518
          },
          {
            "code": "NUM362",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0453",
            "startPosition": 519
          },
          {
            "code": "NUM363",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0454",
            "startPosition": 539
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0480",
            "startPosition": 559
          }
        ]
      },
      {
        "length": 570,
        "lineId": "06",
        "name": "TariefRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0601",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0602",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0603",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0604",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0605",
            "startPosition": 28
          },
          {
            "code": "COD692",
            "description": "AANDUIDING PRESTATIECODELIJST (01)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0606",
            "startPosition": 43
          },
          {
            "code": "COD677",
            "description": "AANDUIDING PRESTATIECODELIJST (02)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0607",
            "startPosition": 46
          },
          {
            "code": "COD695",
            "description": "PRESTATIECODE/DBC DECLARATIECODE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0608",
            "startPosition": 49
          },
          {
            "code": "DAT001",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0609",
            "startPosition": 55
          },
          {
            "code": "NUM123",
            "description": "PRESTATIEVOLGNUMMER",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0610",
            "startPosition": 63
          },
          {
            "code": "COD029",
            "description": "SOORT PRESTATIE/TARIEF",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0611",
            "startPosition": 65
          },
          {
            "code": "COD089",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0612",
            "startPosition": 67
          },
          {
            "code": "COD286",
            "description": "ZORGVERLENERSSPECIFICATIE BEHANDELAAR/UITVOERDER (SUBBEROEPSGROEP)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0613",
            "startPosition": 75
          },
          {
            "code": "BED160",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0614",
            "startPosition": 79
          },
          {
            "code": "ANT094",
            "description": "VERREKENPERCENTAGE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0615",
            "startPosition": 87
          },
          {
            "code": "COD030",
            "description": "SOORT TOESLAG",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0616",
            "startPosition": 92
          },
          {
            "code": "BED153",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0617",
            "startPosition": 94
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0618",
            "startPosition": 102
          },
          {
            "code": "NUM352",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0619",
            "startPosition": 103
          },
          {
            "code": "BED161",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0620",
            "startPosition": 107
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0621",
            "startPosition": 115
          },
          {
            "code": "NUM371",
            "description": "REFERENTIENUMMER DIT TARIEFRECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0622",
            "startPosition": 116
          },
          {
            "code": "NUM372",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE TARIEFRECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0623",
            "startPosition": 136
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 415,
            "lineElementId": "0680",
            "startPosition": 156
          }
        ]
      },
      {
        "length": 570,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "code": "NUM109",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "code": "OMS016",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 412,
            "lineElementId": "9880",
            "startPosition": 159
          }
        ]
      },
      {
        "length": 570,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "code": "ANT085",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "code": "ANT086",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "code": "ANT087",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "code": "ANT002",
            "description": "AANTAL TARIEFRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "code": "ANT089",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "code": "ANT265",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9907",
            "startPosition": 33
          },
          {
            "code": "BED025",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9908",
            "startPosition": 40
          },
          {
            "code": "COD043",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9909",
            "startPosition": 51
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 519,
            "lineElementId": "9980",
            "startPosition": 52
          }
        ]
      }
    ]
  },
  {
    "description": "RETOURINFORMATIE DECLARATIE DBC/ZIEKENHUISZORG",
    "formatSubVersion": 0,
    "formatVersion": 8,
    "name": "ZH309",
    "vektisEICode": 102,
    "lineTypes": [
      {
        "length": 630,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "code": "COD002",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "code": "NUM001",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "code": "NUM309",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "code": "COD856",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "code": "COD805",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "code": "NUM284",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "code": "COD377",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "code": "COD009",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "code": "COD181",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "code": "COD031",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "code": "COD833",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "code": "DAT043",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "code": "DAT044",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "code": "NUM029",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "code": "DAT031",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "code": "NUM351",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "code": "COD363",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 453,
            "lineElementId": "0180",
            "startPosition": 118
          },
          {
            "code": "NUM370",
            "description": "REFERENTIENUMMER ZORGVERZEKERAAR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0181",
            "startPosition": 571
          },
          {
            "code": "DAT277",
            "description": "DAGTEKENING RETOURBERICHT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0182",
            "startPosition": 595
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0196",
            "startPosition": 603
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0197",
            "startPosition": 607
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0198",
            "startPosition": 611
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 16,
            "lineElementId": "0199",
            "startPosition": 615
          }
        ]
      },
      {
        "length": 630,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "code": "NUM366",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "code": "DAT006",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "code": "COD134",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "code": "NAM193",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "code": "NAM194",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "code": "NAM191",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "code": "NAM192",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "code": "NAM025",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "code": "COD083",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "code": "NUM030",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "code": "NUM079",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "code": "COD090",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "code": "COD841",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 389,
            "lineElementId": "0280",
            "startPosition": 182
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0296",
            "startPosition": 571
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0297",
            "startPosition": 575
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0298",
            "startPosition": 579
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0299",
            "startPosition": 583
          }
        ]
      },
      {
        "length": 630,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "code": "COD316",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "code": "DAT264",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "code": "COD446",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "code": "COD700",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "code": "NAM214",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "code": "NAM216",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "code": "COD701",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "code": "NAM215",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "code": "NAM217",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "code": "NAM089",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "code": "COD829",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "code": "COD843",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "code": "NAM141",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "code": "NUM098",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "code": "NUM099",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "code": "COD312",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "code": "COD434",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "code": "NAM142",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "code": "COD313",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "code": "NUM364",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "code": "NUM092",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "code": "NAM221",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "code": "NUM008",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "code": "COD819",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 273,
            "lineElementId": "0380",
            "startPosition": 298
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0396",
            "startPosition": 571
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0397",
            "startPosition": 575
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0398",
            "startPosition": 579
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0399",
            "startPosition": 583
          }
        ]
      },
      {
        "length": 630,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "code": "NUM013",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "code": "COD150",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "code": "COD367",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "code": "COD695",
            "description": "PRESTATIECODE/DBC DECLARATIECODE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0409",
            "startPosition": 62
          },
          {
            "code": "DAT001",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0410",
            "startPosition": 68
          },
          {
            "code": "DAT003",
            "description": "EINDDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0411",
            "startPosition": 76
          },
          {
            "code": "NUM123",
            "description": "PRESTATIEVOLGNUMMER",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0412",
            "startPosition": 84
          },
          {
            "code": "COD988",
            "description": "ZORGPRODUCTCODE",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0413",
            "startPosition": 86
          },
          {
            "code": "NUM368",
            "description": "ZORGTRAJECTNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0414",
            "startPosition": 95
          },
          {
            "code": "DAT291",
            "description": "BEGINDATUM ZORGTRAJECT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0415",
            "startPosition": 110
          },
          {
            "code": "DAT292",
            "description": "EINDDATUM ZORGTRAJECT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0416",
            "startPosition": 118
          },
          {
            "code": "COD990",
            "description": "AFSLUITREDEN ZORGTRAJECT/SUBTRAJECT",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0417",
            "startPosition": 126
          },
          {
            "code": "NUM379",
            "description": "SUBTRAJECTNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0418",
            "startPosition": 128
          },
          {
            "code": "COD327",
            "description": "CODE (ZELF)VERWIJZER",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0419",
            "startPosition": 143
          },
          {
            "code": "COD836",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 145
          },
          {
            "code": "COD953",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0421",
            "startPosition": 153
          },
          {
            "code": "NUM369",
            "description": "VERWIJZEND ZORGTRAJECTNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0422",
            "startPosition": 157
          },
          {
            "code": "ANT054",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0423",
            "startPosition": 172
          },
          {
            "code": "COD788",
            "description": "ZORGTYPECODE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0424",
            "startPosition": 176
          },
          {
            "code": "COD074",
            "description": "SOORT ZORGVRAAG",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0425",
            "startPosition": 182
          },
          {
            "code": "COD789",
            "description": "ZORGVRAAGCODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0426",
            "startPosition": 183
          },
          {
            "code": "COD075",
            "description": "SOORT DIAGNOSE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0427",
            "startPosition": 186
          },
          {
            "code": "COD127",
            "description": "DIAGNOSECODE",
            "fieldType": "AN",
            "length": 7,
            "lineElementId": "0428",
            "startPosition": 187
          },
          {
            "code": "COD994",
            "description": "INDICATIE AANSPRAAK ZORGVERZEKERINGSWET TOEGEPAST",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0429",
            "startPosition": 194
          },
          {
            "code": "COD276",
            "description": "TOELICHTING PRESTATIE",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0430",
            "startPosition": 195
          },
          {
            "code": "COD274",
            "description": "ACCEPTATIE TERMIJNOVERSCHRIJDING HERDECLARATIE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0431",
            "startPosition": 198
          },
          {
            "code": "COD224",
            "description": "INDICATIE MACHTIGING",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0432",
            "startPosition": 199
          },
          {
            "code": "COD227",
            "description": "INDICATIE PRODUCTTYPERENDE ORANJE VERRICHTING IN HET PROFIEL",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0433",
            "startPosition": 200
          },
          {
            "code": "COD286",
            "description": "ZORGVERLENERSSPECIFICATIE BEHANDELAAR/UITVOERDER (SUBBEROEPSGROEP)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0434",
            "startPosition": 201
          },
          {
            "code": "COD031",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0435",
            "startPosition": 205
          },
          {
            "code": "COD989",
            "description": "HASHTOTAAL ZV",
            "fieldType": "AN",
            "length": 200,
            "lineElementId": "0436",
            "startPosition": 213
          },
          {
            "code": "NUM383",
            "description": "HASHVERSIE ZV",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0437",
            "startPosition": 413
          },
          {
            "code": "NUM384",
            "description": "CERTIFICAATVERSIE HASH",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0438",
            "startPosition": 425
          },
          {
            "code": "COD153",
            "description": "GROUPERIDENTIFICATIE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0439",
            "startPosition": 437
          },
          {
            "code": "NUM385",
            "description": "GROUPERVERSIE",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0440",
            "startPosition": 440
          },
          {
            "code": "NUM386",
            "description": "TABELSETVERSIE GROUPER",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0441",
            "startPosition": 452
          },
          {
            "code": "COD328",
            "description": "GROUPERWERKOMGEVING",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0442",
            "startPosition": 472
          },
          {
            "code": "COD329",
            "description": "ZORGACTIVITEITCODE",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0443",
            "startPosition": 473
          },
          {
            "code": "COD099",
            "description": "ZORGACTIVITEITNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0444",
            "startPosition": 483
          },
          {
            "code": "COD100",
            "description": "ZORGPADCODE",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0445",
            "startPosition": 498
          },
          {
            "code": "COD392",
            "description": "AANDUIDING DIAGNOSECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0446",
            "startPosition": 500
          },
          {
            "code": "COD185",
            "description": "VERWIJSDIAGNOSECODE PARAMEDISCHE HULP",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0447",
            "startPosition": 503
          },
          {
            "code": "COD321",
            "description": "CODE SOORT INDICATIE PARAMEDISCHE HULP",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0448",
            "startPosition": 511
          },
          {
            "code": "COD119",
            "description": "INDICATIE TWEEDE OPERATIE ZELFDE AANDOENING PARAMEDISCHE HULP",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0449",
            "startPosition": 514
          },
          {
            "code": "COD217",
            "description": "REDEN EINDE ZORG",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0450",
            "startPosition": 515
          },
          {
            "code": "COD183",
            "description": "INDICATIE ONGEVAL (ONGEVALSGEVOLG)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0451",
            "startPosition": 517
          },
          {
            "code": "COD043",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0452",
            "startPosition": 518
          },
          {
            "code": "NUM362",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0453",
            "startPosition": 519
          },
          {
            "code": "NUM363",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0454",
            "startPosition": 539
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0480",
            "startPosition": 559
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0496",
            "startPosition": 571
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0497",
            "startPosition": 575
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0498",
            "startPosition": 579
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0499",
            "startPosition": 583
          }
        ]
      },
      {
        "length": 630,
        "lineId": "06",
        "name": "TariefRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0601",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0602",
            "startPosition": 3
          },
          {
            "code": "NUM313",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0603",
            "startPosition": 15
          },
          {
            "code": "COD061",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0604",
            "startPosition": 24
          },
          {
            "code": "NUM003",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0605",
            "startPosition": 28
          },
          {
            "code": "COD692",
            "description": "AANDUIDING PRESTATIECODELIJST (01)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0606",
            "startPosition": 43
          },
          {
            "code": "COD677",
            "description": "AANDUIDING PRESTATIECODELIJST (02)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0607",
            "startPosition": 46
          },
          {
            "code": "COD695",
            "description": "PRESTATIECODE/DBC DECLARATIECODE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0608",
            "startPosition": 49
          },
          {
            "code": "DAT001",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0609",
            "startPosition": 55
          },
          {
            "code": "NUM123",
            "description": "PRESTATIEVOLGNUMMER",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0610",
            "startPosition": 63
          },
          {
            "code": "COD029",
            "description": "SOORT PRESTATIE/TARIEF",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0611",
            "startPosition": 65
          },
          {
            "code": "COD089",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0612",
            "startPosition": 67
          },
          {
            "code": "COD286",
            "description": "ZORGVERLENERSSPECIFICATIE BEHANDELAAR/UITVOERDER (SUBBEROEPSGROEP)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0613",
            "startPosition": 75
          },
          {
            "code": "BED160",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0614",
            "startPosition": 79
          },
          {
            "code": "ANT094",
            "description": "VERREKENPERCENTAGE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0615",
            "startPosition": 87
          },
          {
            "code": "COD030",
            "description": "SOORT TOESLAG",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0616",
            "startPosition": 92
          },
          {
            "code": "BED153",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0617",
            "startPosition": 94
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0618",
            "startPosition": 102
          },
          {
            "code": "NUM352",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0619",
            "startPosition": 103
          },
          {
            "code": "BED161",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0620",
            "startPosition": 107
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0621",
            "startPosition": 115
          },
          {
            "code": "NUM371",
            "description": "REFERENTIENUMMER DIT TARIEFRECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0622",
            "startPosition": 116
          },
          {
            "code": "NUM372",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE TARIEFRECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0623",
            "startPosition": 136
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 415,
            "lineElementId": "0680",
            "startPosition": 156
          },
          {
            "code": "BED165",
            "description": "BEREKEND BEDRAG ZORGVERZEKERAAR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0681",
            "startPosition": 571
          },
          {
            "code": "COD672",
            "description": "INDICATIE DEBET/CREDIT (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0682",
            "startPosition": 579
          },
          {
            "code": "BED166",
            "description": "TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0683",
            "startPosition": 580
          },
          {
            "code": "COD673",
            "description": "INDICATIE DEBET/CREDIT (04)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0684",
            "startPosition": 588
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0696",
            "startPosition": 589
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0697",
            "startPosition": 593
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0698",
            "startPosition": 597
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 30,
            "lineElementId": "0699",
            "startPosition": 601
          }
        ]
      },
      {
        "length": 630,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "code": "NUM040",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "code": "NUM109",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "code": "OMS016",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 412,
            "lineElementId": "9880",
            "startPosition": 159
          },
          {
            "code": "COD954",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9896",
            "startPosition": 571
          },
          {
            "code": "COD955",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9897",
            "startPosition": 575
          },
          {
            "code": "COD956",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9898",
            "startPosition": 579
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "9899",
            "startPosition": 583
          }
        ]
      },
      {
        "length": 630,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "code": "COD001",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "code": "ANT267",
            "description": "AANTAL VERZEKERDENRECORDS RETOUR",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "code": "ANT268",
            "description": "AANTAL DEBITEURRECORDS RETOUR",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "code": "ANT269",
            "description": "AANTAL PRESTATIERECORDS RETOUR",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "code": "ANT276",
            "description": "AANTAL TARIEFRECORDS RETOUR",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "code": "ANT270",
            "description": "AANTAL COMMENTAARRECORDS RETOUR",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "code": "ANT271",
            "description": "TOTAAL AANTAL DETAILRECORDS RETOUR",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9907",
            "startPosition": 33
          },
          {
            "code": "BED168",
            "description": "TOTAAL INGEDIEND DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9908",
            "startPosition": 40
          },
          {
            "code": "COD668",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9909",
            "startPosition": 51
          },
          {
            "code": "BED167",
            "description": "TOTAAL TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9910",
            "startPosition": 52
          },
          {
            "code": "COD665",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9911",
            "startPosition": 63
          },
          {
            "code": "TEC007",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 567,
            "lineElementId": "9999",
            "startPosition": 64
          }
        ]
      }
    ]
  }
]

"""
let typesJson = parseJson(doctypes_json_string)
let types = lc[to(node, DocumentType) | (node <- typesJson), DocumentType]


proc get_doctype*(typeId: int, version: int, subversion: int): DocumentType = 
   let matches = filter(types, proc(t: DocumentType): bool = t.vektisEICode == typeId and t.formatVersion == version and t.formatSubVersion == subversion)
   if matches.len == 0:
      raise newException(DocumentTypeError, "Unknown declatation format: Vektis EI code: '$#', version: $#, subversion: $#" % [intToStr(typeId), intToStr(version), intToStr(subversion)])
   else:
      result = matches[0]


proc get_doctype_by_name*(name: string, version: int, subversion: int): DocumentType = 
   let matches = filter(types, proc(t: DocumentType): bool = t.name == name and t.formatVersion == version and t.formatSubVersion == subversion)
   if matches.len == 0:
      raise newException(DocumentTypeError, "Unknown declaration format: name: '$#', version: $#, subversion: $#" % [name, intToStr(version), intToStr(subversion)])
   else:
      result = matches[0]


proc get_all_doctypes*(): seq[DocumentType] = types
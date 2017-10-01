import json, future

type
   LineElementType* = object
      lineElementId*: string
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
    "id": 1,
    "type": "DocumentType",
    "description": "DECLARATIE FARMACEUTISCHE HULP",
    "formatSubVersion": 2,
    "formatVersion": 7,
    "name": "AP304",
    "vektisEICode": 106,
    "lineTypes": [
      {
        "id": 1,
        "type": "LineType",
        "length": 310,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "id": 1,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "id": 2,
            "type": "LineElementType",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "id": 3,
            "type": "LineElementType",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "id": 4,
            "type": "LineElementType",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "id": 5,
            "type": "LineElementType",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "id": 6,
            "type": "LineElementType",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "id": 7,
            "type": "LineElementType",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "id": 8,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "id": 9,
            "type": "LineElementType",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "id": 10,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "id": 11,
            "type": "LineElementType",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "id": 12,
            "type": "LineElementType",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "id": 13,
            "type": "LineElementType",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "id": 14,
            "type": "LineElementType",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "id": 15,
            "type": "LineElementType",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "id": 16,
            "type": "LineElementType",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "id": 17,
            "type": "LineElementType",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "id": 18,
            "type": "LineElementType",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "id": 19,
            "type": "LineElementType",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "id": 20,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          }
        ]
      },
      {
        "id": 2,
        "type": "LineType",
        "length": 310,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "id": 21,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "id": 22,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "id": 23,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "id": 24,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "id": 25,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "id": 26,
            "type": "LineElementType",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "id": 27,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "id": 28,
            "type": "LineElementType",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "id": 29,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "id": 30,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "id": 31,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "id": 32,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "id": 33,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "id": 34,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "id": 35,
            "type": "LineElementType",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "id": 36,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "id": 37,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "id": 38,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "id": 39,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "id": 40,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "id": 41,
            "type": "LineElementType",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "id": 42,
            "type": "LineElementType",
            "description": "VERZEKERDENREGISTRATIE BIJ ZORGVERLENER",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "id": 43,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0223",
            "startPosition": 171
          },
          {
            "id": 44,
            "type": "LineElementType",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0224",
            "startPosition": 182
          },
          {
            "id": 45,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 128,
            "lineElementId": "0280",
            "startPosition": 183
          }
        ]
      },
      {
        "id": 3,
        "type": "LineType",
        "length": 310,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "id": 46,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "id": 47,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "id": 48,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "id": 49,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "id": 50,
            "type": "LineElementType",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "id": 51,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "id": 52,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "id": 53,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "id": 54,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "id": 55,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "id": 56,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "id": 57,
            "type": "LineElementType",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "id": 58,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "id": 59,
            "type": "LineElementType",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "id": 60,
            "type": "LineElementType",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "id": 61,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "id": 62,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "id": 63,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "id": 64,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "id": 65,
            "type": "LineElementType",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "id": 66,
            "type": "LineElementType",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "id": 67,
            "type": "LineElementType",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "id": 68,
            "type": "LineElementType",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "id": 69,
            "type": "LineElementType",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "id": 70,
            "type": "LineElementType",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "id": 71,
            "type": "LineElementType",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "id": 72,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          }
        ]
      },
      {
        "id": 4,
        "type": "LineType",
        "length": 310,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "id": 73,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "id": 74,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "id": 75,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "id": 76,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "id": 77,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "id": 78,
            "type": "LineElementType",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "id": 79,
            "type": "LineElementType",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "id": 80,
            "type": "LineElementType",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "id": 81,
            "type": "LineElementType",
            "description": "DATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "id": 82,
            "type": "LineElementType",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0410",
            "startPosition": 75
          },
          {
            "id": 83,
            "type": "LineElementType",
            "description": "PRESTATIECODE",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0411",
            "startPosition": 78
          },
          {
            "id": 84,
            "type": "LineElementType",
            "description": "AFLEVERINGSEENHEID",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0412",
            "startPosition": 90
          },
          {
            "id": 85,
            "type": "LineElementType",
            "description": "GEMIDDELDE DAGDOSERING",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0413",
            "startPosition": 92
          },
          {
            "id": 86,
            "type": "LineElementType",
            "description": "HOEVEELHEID AFGELEVERD MIDDEL",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0414",
            "startPosition": 101
          },
          {
            "id": 87,
            "type": "LineElementType",
            "description": "WMG-TARIEFCODE MODULAIRE TARIEFSTRUCTUUR FARMACEUTISCHE HULP",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0415",
            "startPosition": 110
          },
          {
            "id": 88,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0416",
            "startPosition": 118
          },
          {
            "id": 89,
            "type": "LineElementType",
            "description": "SPECIALISME BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0417",
            "startPosition": 126
          },
          {
            "id": 90,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0418",
            "startPosition": 130
          },
          {
            "id": 91,
            "type": "LineElementType",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0419",
            "startPosition": 138
          },
          {
            "id": 92,
            "type": "LineElementType",
            "description": "RECEPTNUMMER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 142
          },
          {
            "id": 93,
            "type": "LineElementType",
            "description": "RECEPTVOORSCHRIFT, VOLGNUMMER",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0421",
            "startPosition": 150
          },
          {
            "id": 94,
            "type": "LineElementType",
            "description": "AANDUIDING SPECIFICATIE HULPMIDDEL",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0422",
            "startPosition": 152
          },
          {
            "id": 95,
            "type": "LineElementType",
            "description": "SPECIFICATIE HULPMIDDEL",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0423",
            "startPosition": 154
          },
          {
            "id": 96,
            "type": "LineElementType",
            "description": "INDICATIE SOORT RECEPTUUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0424",
            "startPosition": 166
          },
          {
            "id": 97,
            "type": "LineElementType",
            "description": "INDICATIE WMG",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0425",
            "startPosition": 167
          },
          {
            "id": 98,
            "type": "LineElementType",
            "description": "VOORGESCHREVEN DOSERING (BEKEND)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0426",
            "startPosition": 168
          },
          {
            "id": 99,
            "type": "LineElementType",
            "description": "TOELICHTING DECLARATIEPOST MIDDEL",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0427",
            "startPosition": 169
          },
          {
            "id": 100,
            "type": "LineElementType",
            "description": "WMG-TARIEFCODEBEDRAG (EXCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0428",
            "startPosition": 171
          },
          {
            "id": 101,
            "type": "LineElementType",
            "description": "BEDRAG BEREKENDE EIGEN BIJDRAGE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0429",
            "startPosition": 179
          },
          {
            "id": 102,
            "type": "LineElementType",
            "description": "INDICATIE GVS-BIJDRAGE OPGENOMEN IN DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0430",
            "startPosition": 187
          },
          {
            "id": 103,
            "type": "LineElementType",
            "description": "VERGOEDINGSBEDRAG MIDDELEN (EXCL. WMG, GVS, BTW; INCL AFTREK CLAWBACK)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0431",
            "startPosition": 188
          },
          {
            "id": 104,
            "type": "LineElementType",
            "description": "TARIEF PRESTATIE (EXCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0432",
            "startPosition": 196
          },
          {
            "id": 105,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0433",
            "startPosition": 204
          },
          {
            "id": 106,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0434",
            "startPosition": 212
          },
          {
            "id": 107,
            "type": "LineElementType",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0435",
            "startPosition": 213
          },
          {
            "id": 108,
            "type": "LineElementType",
            "description": "BTW BEDRAG OP DETAILNIVEAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0436",
            "startPosition": 217
          },
          {
            "id": 109,
            "type": "LineElementType",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0437",
            "startPosition": 225
          },
          {
            "id": 110,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0438",
            "startPosition": 233
          },
          {
            "id": 111,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0439",
            "startPosition": 234
          },
          {
            "id": 112,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0440",
            "startPosition": 254
          },
          {
            "id": 113,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 37,
            "lineElementId": "0480",
            "startPosition": 274
          }
        ]
      },
      {
        "id": 5,
        "type": "LineType",
        "length": 310,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "id": 114,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "id": 115,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "id": 116,
            "type": "LineElementType",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "id": 117,
            "type": "LineElementType",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "id": 118,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          }
        ]
      },
      {
        "id": 6,
        "type": "LineType",
        "length": 310,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "id": 119,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "id": 120,
            "type": "LineElementType",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "id": 121,
            "type": "LineElementType",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "id": 122,
            "type": "LineElementType",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "id": 123,
            "type": "LineElementType",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "id": 124,
            "type": "LineElementType",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "id": 125,
            "type": "LineElementType",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "id": 126,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "id": 127,
            "type": "LineElementType",
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
    "id": 35,
    "type": "DocumentType",
    "description": "DECLARATIE FARMACEUTISCHE HULP",
    "formatSubVersion": 0,
    "formatVersion": 8,
    "name": "AP304_8_0",
    "vektisEICode": 193,
    "lineTypes": [
      {
        "id": 208,
        "type": "LineType",
        "length": 360,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "id": 4552,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "id": 4553,
            "type": "LineElementType",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "id": 4554,
            "type": "LineElementType",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "id": 4555,
            "type": "LineElementType",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "id": 4556,
            "type": "LineElementType",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "id": 4557,
            "type": "LineElementType",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "id": 4558,
            "type": "LineElementType",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "id": 4559,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "id": 4560,
            "type": "LineElementType",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "id": 4561,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "id": 4562,
            "type": "LineElementType",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "id": 4563,
            "type": "LineElementType",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "id": 4564,
            "type": "LineElementType",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "id": 4565,
            "type": "LineElementType",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "id": 4566,
            "type": "LineElementType",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "id": 4567,
            "type": "LineElementType",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "id": 4568,
            "type": "LineElementType",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "id": 4569,
            "type": "LineElementType",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "id": 4570,
            "type": "LineElementType",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "id": 4571,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 243,
            "lineElementId": "0180",
            "startPosition": 118
          }
        ]
      },
      {
        "id": 209,
        "type": "LineType",
        "length": 360,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "id": 4572,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "id": 4573,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "id": 4574,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "id": 4575,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "id": 4576,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "id": 4577,
            "type": "LineElementType",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "id": 4578,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "id": 4579,
            "type": "LineElementType",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "id": 4580,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "id": 4581,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "id": 4582,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "id": 4583,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "id": 4584,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "id": 4585,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "id": 4586,
            "type": "LineElementType",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "id": 4587,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "id": 4588,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "id": 4589,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "id": 4590,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "id": 4591,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "id": 4592,
            "type": "LineElementType",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "id": 4593,
            "type": "LineElementType",
            "description": "VERZEKERDENREGISTRATIE BIJ ZORGVERLENER",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "id": 4594,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0223",
            "startPosition": 171
          },
          {
            "id": 4595,
            "type": "LineElementType",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0224",
            "startPosition": 182
          },
          {
            "id": 4596,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 178,
            "lineElementId": "0280",
            "startPosition": 183
          }
        ]
      },
      {
        "id": 210,
        "type": "LineType",
        "length": 360,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "id": 4597,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "id": 4598,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "id": 4599,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "id": 4600,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "id": 4601,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "id": 4602,
            "type": "LineElementType",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "id": 4603,
            "type": "LineElementType",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "id": 4604,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "id": 4605,
            "type": "LineElementType",
            "description": "INDICATIE INFORMATIERECORD",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "id": 4606,
            "type": "LineElementType",
            "description": "DATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0410",
            "startPosition": 68
          },
          {
            "id": 4607,
            "type": "LineElementType",
            "description": "TIJDSTIP PRESTATIE",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0411",
            "startPosition": 76
          },
          {
            "id": 4608,
            "type": "LineElementType",
            "description": "ZORGCONTRACTNUMMER",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0412",
            "startPosition": 80
          },
          {
            "id": 4609,
            "type": "LineElementType",
            "description": "AANDUIDING PRESTATIECODELIJST (01)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0413",
            "startPosition": 92
          },
          {
            "id": 4610,
            "type": "LineElementType",
            "description": "PRESTATIECODE (01)",
            "fieldType": "N",
            "length": 14,
            "lineElementId": "0414",
            "startPosition": 95
          },
          {
            "id": 4611,
            "type": "LineElementType",
            "description": "AFLEVERINGSEENHEID",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0415",
            "startPosition": 109
          },
          {
            "id": 4612,
            "type": "LineElementType",
            "description": "GEMIDDELDE DAGDOSERING",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0416",
            "startPosition": 111
          },
          {
            "id": 4613,
            "type": "LineElementType",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0417",
            "startPosition": 120
          },
          {
            "id": 4614,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0418",
            "startPosition": 129
          },
          {
            "id": 4615,
            "type": "LineElementType",
            "description": "SPECIALISME BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0419",
            "startPosition": 137
          },
          {
            "id": 4616,
            "type": "LineElementType",
            "description": "PRAKTIJKCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 141
          },
          {
            "id": 4617,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0421",
            "startPosition": 149
          },
          {
            "id": 4618,
            "type": "LineElementType",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0422",
            "startPosition": 157
          },
          {
            "id": 4619,
            "type": "LineElementType",
            "description": "INSTELLINGSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0423",
            "startPosition": 161
          },
          {
            "id": 4620,
            "type": "LineElementType",
            "description": "RECEPTNUMMER",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0424",
            "startPosition": 169
          },
          {
            "id": 4621,
            "type": "LineElementType",
            "description": "RECEPTVOORSCHRIFT, VOLGNUMMER",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0425",
            "startPosition": 181
          },
          {
            "id": 4622,
            "type": "LineElementType",
            "description": "PRESTATIEKOPPELNUMMER",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0426",
            "startPosition": 183
          },
          {
            "id": 4623,
            "type": "LineElementType",
            "description": "AANDUIDING PRESTATIECODELIJST (02)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0427",
            "startPosition": 203
          },
          {
            "id": 4624,
            "type": "LineElementType",
            "description": "PRESTATIECODE (02)",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0428",
            "startPosition": 206
          },
          {
            "id": 4625,
            "type": "LineElementType",
            "description": "INDICATIE SOORT RECEPTUUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0429",
            "startPosition": 218
          },
          {
            "id": 4626,
            "type": "LineElementType",
            "description": "WMG-SYSTEMATIEK PRIJS MIDDELEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0430",
            "startPosition": 219
          },
          {
            "id": 4627,
            "type": "LineElementType",
            "description": "VOORGESCHREVEN DOSERING (BEKEND)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0431",
            "startPosition": 220
          },
          {
            "id": 4628,
            "type": "LineElementType",
            "description": "TOELICHTING DECLARATIEPOST MIDDEL",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0432",
            "startPosition": 221
          },
          {
            "id": 4629,
            "type": "LineElementType",
            "description": "ZORGTRAJECTNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0433",
            "startPosition": 223
          },
          {
            "id": 4630,
            "type": "LineElementType",
            "description": "INDICATIE DUUR GENEESMIDDEL",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0434",
            "startPosition": 238
          },
          {
            "id": 4631,
            "type": "LineElementType",
            "description": "BEDRAG BEREKENDE GVS-BIJDRAGE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0435",
            "startPosition": 253
          },
          {
            "id": 4632,
            "type": "LineElementType",
            "description": "INDICATIE GVS-BIJDRAGE OPGENOMEN IN DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0436",
            "startPosition": 261
          },
          {
            "id": 4633,
            "type": "LineElementType",
            "description": "DECLARATIEBEDRAG EXCL GVS-BIJDRAGE EN EXCL.BTW",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0437",
            "startPosition": 262
          },
          {
            "id": 4634,
            "type": "LineElementType",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0438",
            "startPosition": 270
          },
          {
            "id": 4635,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0439",
            "startPosition": 278
          },
          {
            "id": 4636,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0440",
            "startPosition": 286
          },
          {
            "id": 4637,
            "type": "LineElementType",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0441",
            "startPosition": 287
          },
          {
            "id": 4638,
            "type": "LineElementType",
            "description": "BTW BEDRAG OP DETAILNIVEAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0442",
            "startPosition": 291
          },
          {
            "id": 4639,
            "type": "LineElementType",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0443",
            "startPosition": 299
          },
          {
            "id": 4640,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0444",
            "startPosition": 307
          },
          {
            "id": 4641,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0445",
            "startPosition": 308
          },
          {
            "id": 4642,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0446",
            "startPosition": 328
          },
          {
            "id": 4643,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0480",
            "startPosition": 348
          }
        ]
      },
      {
        "id": 211,
        "type": "LineType",
        "length": 360,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "id": 4644,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "id": 4645,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "id": 4646,
            "type": "LineElementType",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "id": 4647,
            "type": "LineElementType",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "id": 4648,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 202,
            "lineElementId": "9880",
            "startPosition": 159
          }
        ]
      },
      {
        "id": 212,
        "type": "LineType",
        "length": 360,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "id": 4649,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "id": 4650,
            "type": "LineElementType",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "id": 4651,
            "type": "LineElementType",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "id": 4652,
            "type": "LineElementType",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "id": 4653,
            "type": "LineElementType",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "id": 4654,
            "type": "LineElementType",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "id": 4655,
            "type": "LineElementType",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "id": 4656,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "id": 4657,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 315,
            "lineElementId": "9980",
            "startPosition": 46
          }
        ]
      },
      {
        "id": 213,
        "type": "LineType",
        "length": 360,
        "lineId": "03",
        "name": "DebiteurenenRecord",
        "lineElementTypes": [
          {
            "id": 5384,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "id": 5385,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "id": 5386,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "id": 5387,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "id": 5388,
            "type": "LineElementType",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "id": 5389,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "id": 5390,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "id": 5391,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "id": 5392,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "id": 5393,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "id": 5394,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "id": 5395,
            "type": "LineElementType",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "id": 5396,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "id": 5397,
            "type": "LineElementType",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "id": 5398,
            "type": "LineElementType",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "id": 5399,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "id": 5400,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "id": 5401,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "id": 5402,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "id": 5403,
            "type": "LineElementType",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "id": 5404,
            "type": "LineElementType",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "id": 5405,
            "type": "LineElementType",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "id": 5406,
            "type": "LineElementType",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "id": 5407,
            "type": "LineElementType",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 50,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "id": 5408,
            "type": "LineElementType",
            "description": "IBAN",
            "fieldType": "AN",
            "length": 34,
            "lineElementId": "0325",
            "startPosition": 260
          },
          {
            "id": 5409,
            "type": "LineElementType",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 294
          },
          {
            "id": 5410,
            "type": "LineElementType",
            "description": "CODE INCASSO",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0327",
            "startPosition": 296
          },
          {
            "id": 5411,
            "type": "LineElementType",
            "description": "VERSIENUMMER DEBITEURRECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0328",
            "startPosition": 298
          },
          {
            "id": 5412,
            "type": "LineElementType",
            "description": "MACHTIGINGSDATUM",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0329",
            "startPosition": 300
          },
          {
            "id": 5413,
            "type": "LineElementType",
            "description": "FACTURATIEVORM",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0330",
            "startPosition": 308
          },
          {
            "id": 5414,
            "type": "LineElementType",
            "description": "EXTRA ADRESREGEL",
            "fieldType": "AN",
            "length": 35,
            "lineElementId": "0331",
            "startPosition": 309
          },
          {
            "id": 5415,
            "type": "LineElementType",
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
    "id": 24,
    "type": "DocumentType",
    "description": "DECLARATIE AWBZ",
    "formatSubVersion": 3,
    "formatVersion": 1,
    "name": "AW319",
    "vektisEICode": 187,
    "lineTypes": [
      {
        "id": 140,
        "type": "LineType",
        "length": 310,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "id": 2969,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "id": 2970,
            "type": "LineElementType",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "id": 2971,
            "type": "LineElementType",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "id": 2972,
            "type": "LineElementType",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "id": 2973,
            "type": "LineElementType",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "id": 2974,
            "type": "LineElementType",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "id": 2975,
            "type": "LineElementType",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "id": 2976,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "id": 2977,
            "type": "LineElementType",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "id": 2978,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "id": 2979,
            "type": "LineElementType",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "id": 2980,
            "type": "LineElementType",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "id": 2981,
            "type": "LineElementType",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "id": 2982,
            "type": "LineElementType",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "id": 2983,
            "type": "LineElementType",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "id": 2984,
            "type": "LineElementType",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "id": 2985,
            "type": "LineElementType",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "id": 2986,
            "type": "LineElementType",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "id": 2987,
            "type": "LineElementType",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "id": 2988,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          }
        ]
      },
      {
        "id": 141,
        "type": "LineType",
        "length": 310,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "id": 2989,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "id": 2990,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "id": 2991,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "id": 2992,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "id": 2993,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "id": 2994,
            "type": "LineElementType",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "id": 2995,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "id": 2996,
            "type": "LineElementType",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "id": 2997,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "id": 2998,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "id": 2999,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "id": 3000,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "id": 3001,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "id": 3002,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "id": 3003,
            "type": "LineElementType",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "id": 3004,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "id": 3005,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "id": 3006,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "id": 3007,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "id": 3008,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "id": 3009,
            "type": "LineElementType",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "id": 3010,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "id": 3011,
            "type": "LineElementType",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "id": 3012,
            "type": "LineElementType",
            "description": "CODE INDICATIEORGAAN",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0224",
            "startPosition": 182
          },
          {
            "id": 3013,
            "type": "LineElementType",
            "description": "CLIËNTNUMMER INDICATIEORGAAN",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0225",
            "startPosition": 186
          },
          {
            "id": 3014,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 105,
            "lineElementId": "0280",
            "startPosition": 206
          }
        ]
      },
      {
        "id": 142,
        "type": "LineType",
        "length": 310,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "id": 3015,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "id": 3016,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "id": 3017,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "id": 3018,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "id": 3019,
            "type": "LineElementType",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "id": 3020,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "id": 3021,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "id": 3022,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "id": 3023,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "id": 3024,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "id": 3025,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "id": 3026,
            "type": "LineElementType",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "id": 3027,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "id": 3028,
            "type": "LineElementType",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "id": 3029,
            "type": "LineElementType",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "id": 3030,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "id": 3031,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "id": 3032,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "id": 3033,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "id": 3034,
            "type": "LineElementType",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "id": 3035,
            "type": "LineElementType",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "id": 3036,
            "type": "LineElementType",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "id": 3037,
            "type": "LineElementType",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "id": 3038,
            "type": "LineElementType",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "id": 3039,
            "type": "LineElementType",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "id": 3040,
            "type": "LineElementType",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "id": 3041,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          }
        ]
      },
      {
        "id": 143,
        "type": "LineType",
        "length": 310,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "id": 3042,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "id": 3043,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "id": 3044,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "id": 3045,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "id": 3046,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "id": 3047,
            "type": "LineElementType",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "id": 3048,
            "type": "LineElementType",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "id": 3049,
            "type": "LineElementType",
            "description": "CODE INDICATIEORGAAN",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "id": 3050,
            "type": "LineElementType",
            "description": "CLIËNTNUMMER INDICATIEORGAAN",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0409",
            "startPosition": 63
          },
          {
            "id": 3051,
            "type": "LineElementType",
            "description": "INDICATIE-AANVRAAGNUMMER INDICATIEORGAAN",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0410",
            "startPosition": 83
          },
          {
            "id": 3052,
            "type": "LineElementType",
            "description": "INDICATIEBESLUITNUMMER INDICATIEORGAAN",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0411",
            "startPosition": 92
          },
          {
            "id": 3053,
            "type": "LineElementType",
            "description": "FUNCTIECODE",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0412",
            "startPosition": 101
          },
          {
            "id": 3054,
            "type": "LineElementType",
            "description": "ZORGZWAARTEPAKKETCODE",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0413",
            "startPosition": 103
          },
          {
            "id": 3055,
            "type": "LineElementType",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0414",
            "startPosition": 106
          },
          {
            "id": 3056,
            "type": "LineElementType",
            "description": "EINDDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0415",
            "startPosition": 114
          },
          {
            "id": 3057,
            "type": "LineElementType",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0416",
            "startPosition": 122
          },
          {
            "id": 3058,
            "type": "LineElementType",
            "description": "PRESTATIECODE",
            "fieldType": "AN",
            "length": 5,
            "lineElementId": "0417",
            "startPosition": 125
          },
          {
            "id": 3059,
            "type": "LineElementType",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0418",
            "startPosition": 130
          },
          {
            "id": 3060,
            "type": "LineElementType",
            "description": "TIJDSEENHEID ZORGPERIODE",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0419",
            "startPosition": 134
          },
          {
            "id": 3061,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 136
          },
          {
            "id": 3062,
            "type": "LineElementType",
            "description": "SPECIALISME BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0421",
            "startPosition": 144
          },
          {
            "id": 3063,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0422",
            "startPosition": 148
          },
          {
            "id": 3064,
            "type": "LineElementType",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0423",
            "startPosition": 156
          },
          {
            "id": 3065,
            "type": "LineElementType",
            "description": "VERREKENPERCENTAGE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0424",
            "startPosition": 160
          },
          {
            "id": 3066,
            "type": "LineElementType",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0425",
            "startPosition": 165
          },
          {
            "id": 3067,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0426",
            "startPosition": 173
          },
          {
            "id": 3068,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0427",
            "startPosition": 181
          },
          {
            "id": 3069,
            "type": "LineElementType",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0428",
            "startPosition": 182
          },
          {
            "id": 3070,
            "type": "LineElementType",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0429",
            "startPosition": 186
          },
          {
            "id": 3071,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0430",
            "startPosition": 194
          },
          {
            "id": 3072,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0431",
            "startPosition": 195
          },
          {
            "id": 3073,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0432",
            "startPosition": 215
          },
          {
            "id": 3074,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 76,
            "lineElementId": "0480",
            "startPosition": 235
          }
        ]
      },
      {
        "id": 144,
        "type": "LineType",
        "length": 310,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "id": 3075,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "id": 3076,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "id": 3077,
            "type": "LineElementType",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "id": 3078,
            "type": "LineElementType",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "id": 3079,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          }
        ]
      },
      {
        "id": 145,
        "type": "LineType",
        "length": 310,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "id": 3080,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "id": 3081,
            "type": "LineElementType",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "id": 3082,
            "type": "LineElementType",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "id": 3083,
            "type": "LineElementType",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "id": 3084,
            "type": "LineElementType",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "id": 3085,
            "type": "LineElementType",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "id": 3086,
            "type": "LineElementType",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "id": 3087,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "id": 3088,
            "type": "LineElementType",
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
    "id": 25,
    "type": "DocumentType",
    "description": "RETOURINFORMATIE DECLARATIE AWBZ",
    "formatSubVersion": 3,
    "formatVersion": 1,
    "name": "AW320",
    "vektisEICode": 188,
    "lineTypes": [
      {
        "id": 146,
        "type": "LineType",
        "length": 370,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "id": 3089,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "id": 3090,
            "type": "LineElementType",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "id": 3091,
            "type": "LineElementType",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "id": 3092,
            "type": "LineElementType",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "id": 3093,
            "type": "LineElementType",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "id": 3094,
            "type": "LineElementType",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "id": 3095,
            "type": "LineElementType",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "id": 3096,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "id": 3097,
            "type": "LineElementType",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "id": 3098,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "id": 3099,
            "type": "LineElementType",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "id": 3100,
            "type": "LineElementType",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "id": 3101,
            "type": "LineElementType",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "id": 3102,
            "type": "LineElementType",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "id": 3103,
            "type": "LineElementType",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "id": 3104,
            "type": "LineElementType",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "id": 3105,
            "type": "LineElementType",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "id": 3106,
            "type": "LineElementType",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "id": 3107,
            "type": "LineElementType",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "id": 3108,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          },
          {
            "id": 3109,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER ZORGVERZEKERAAR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0181",
            "startPosition": 311
          },
          {
            "id": 3110,
            "type": "LineElementType",
            "description": "DAGTEKENING RETOURBERICHT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0182",
            "startPosition": 335
          },
          {
            "id": 3111,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0196",
            "startPosition": 343
          },
          {
            "id": 3112,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0197",
            "startPosition": 347
          },
          {
            "id": 3113,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0198",
            "startPosition": 351
          },
          {
            "id": 3114,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 16,
            "lineElementId": "0199",
            "startPosition": 355
          }
        ]
      },
      {
        "id": 147,
        "type": "LineType",
        "length": 370,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "id": 3115,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "id": 3116,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "id": 3117,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "id": 3118,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "id": 3119,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "id": 3120,
            "type": "LineElementType",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "id": 3121,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "id": 3122,
            "type": "LineElementType",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "id": 3123,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "id": 3124,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "id": 3125,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "id": 3126,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "id": 3127,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "id": 3128,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "id": 3129,
            "type": "LineElementType",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "id": 3130,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "id": 3131,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "id": 3132,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "id": 3133,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "id": 3134,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "id": 3135,
            "type": "LineElementType",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "id": 3136,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "id": 3137,
            "type": "LineElementType",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "id": 3138,
            "type": "LineElementType",
            "description": "CODE INDICATIEORGAAN",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0224",
            "startPosition": 182
          },
          {
            "id": 3139,
            "type": "LineElementType",
            "description": "CLIËNTNUMMER INDICATIEORGAAN",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0225",
            "startPosition": 186
          },
          {
            "id": 3140,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 105,
            "lineElementId": "0280",
            "startPosition": 206
          },
          {
            "id": 3141,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0296",
            "startPosition": 311
          },
          {
            "id": 3142,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0297",
            "startPosition": 315
          },
          {
            "id": 3143,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0298",
            "startPosition": 319
          },
          {
            "id": 3144,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0299",
            "startPosition": 323
          }
        ]
      },
      {
        "id": 148,
        "type": "LineType",
        "length": 370,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "id": 3145,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "id": 3146,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "id": 3147,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "id": 3148,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "id": 3149,
            "type": "LineElementType",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "id": 3150,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "id": 3151,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "id": 3152,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "id": 3153,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "id": 3154,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "id": 3155,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "id": 3156,
            "type": "LineElementType",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "id": 3157,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "id": 3158,
            "type": "LineElementType",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "id": 3159,
            "type": "LineElementType",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "id": 3160,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "id": 3161,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "id": 3162,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "id": 3163,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "id": 3164,
            "type": "LineElementType",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "id": 3165,
            "type": "LineElementType",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "id": 3166,
            "type": "LineElementType",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "id": 3167,
            "type": "LineElementType",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "id": 3168,
            "type": "LineElementType",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "id": 3169,
            "type": "LineElementType",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "id": 3170,
            "type": "LineElementType",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "id": 3171,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          },
          {
            "id": 3172,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0396",
            "startPosition": 311
          },
          {
            "id": 3173,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0397",
            "startPosition": 315
          },
          {
            "id": 3174,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0398",
            "startPosition": 319
          },
          {
            "id": 3175,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0399",
            "startPosition": 323
          }
        ]
      },
      {
        "id": 149,
        "type": "LineType",
        "length": 370,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "id": 3176,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "id": 3177,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "id": 3178,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "id": 3179,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "id": 3180,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "id": 3181,
            "type": "LineElementType",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "id": 3182,
            "type": "LineElementType",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "id": 3183,
            "type": "LineElementType",
            "description": "CODE INDICATIEORGAAN",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "id": 3184,
            "type": "LineElementType",
            "description": "CLIËNTNUMMER INDICATIEORGAAN",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0409",
            "startPosition": 63
          },
          {
            "id": 3185,
            "type": "LineElementType",
            "description": "INDICATIE-AANVRAAGNUMMER INDICATIEORGAAN",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0410",
            "startPosition": 83
          },
          {
            "id": 3186,
            "type": "LineElementType",
            "description": "INDICATIEBESLUITNUMMER INDICATIEORGAAN",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0411",
            "startPosition": 92
          },
          {
            "id": 3187,
            "type": "LineElementType",
            "description": "FUNCTIECODE",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0412",
            "startPosition": 101
          },
          {
            "id": 3188,
            "type": "LineElementType",
            "description": "ZORGZWAARTEPAKKETCODE",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0413",
            "startPosition": 103
          },
          {
            "id": 3189,
            "type": "LineElementType",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0414",
            "startPosition": 106
          },
          {
            "id": 3190,
            "type": "LineElementType",
            "description": "EINDDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0415",
            "startPosition": 114
          },
          {
            "id": 3191,
            "type": "LineElementType",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0416",
            "startPosition": 122
          },
          {
            "id": 3192,
            "type": "LineElementType",
            "description": "PRESTATIECODE",
            "fieldType": "AN",
            "length": 5,
            "lineElementId": "0417",
            "startPosition": 125
          },
          {
            "id": 3193,
            "type": "LineElementType",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0418",
            "startPosition": 130
          },
          {
            "id": 3194,
            "type": "LineElementType",
            "description": "TIJDSEENHEID ZORGPERIODE",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0419",
            "startPosition": 134
          },
          {
            "id": 3195,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 136
          },
          {
            "id": 3196,
            "type": "LineElementType",
            "description": "SPECIALISME BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0421",
            "startPosition": 144
          },
          {
            "id": 3197,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0422",
            "startPosition": 148
          },
          {
            "id": 3198,
            "type": "LineElementType",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0423",
            "startPosition": 156
          },
          {
            "id": 3199,
            "type": "LineElementType",
            "description": "VERREKENPERCENTAGE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0424",
            "startPosition": 160
          },
          {
            "id": 3200,
            "type": "LineElementType",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0425",
            "startPosition": 165
          },
          {
            "id": 3201,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0426",
            "startPosition": 173
          },
          {
            "id": 3202,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0427",
            "startPosition": 181
          },
          {
            "id": 3203,
            "type": "LineElementType",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0428",
            "startPosition": 182
          },
          {
            "id": 3204,
            "type": "LineElementType",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0429",
            "startPosition": 186
          },
          {
            "id": 3205,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0430",
            "startPosition": 194
          },
          {
            "id": 3206,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0431",
            "startPosition": 195
          },
          {
            "id": 3207,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0432",
            "startPosition": 215
          },
          {
            "id": 3208,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 76,
            "lineElementId": "0480",
            "startPosition": 235
          },
          {
            "id": 3209,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG ZORGVERZEKERAAR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0481",
            "startPosition": 311
          },
          {
            "id": 3210,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0482",
            "startPosition": 319
          },
          {
            "id": 3211,
            "type": "LineElementType",
            "description": "TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0483",
            "startPosition": 320
          },
          {
            "id": 3212,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (04)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0484",
            "startPosition": 328
          },
          {
            "id": 3213,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0496",
            "startPosition": 329
          },
          {
            "id": 3214,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0497",
            "startPosition": 333
          },
          {
            "id": 3215,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0498",
            "startPosition": 337
          },
          {
            "id": 3216,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 30,
            "lineElementId": "0499",
            "startPosition": 341
          }
        ]
      },
      {
        "id": 150,
        "type": "LineType",
        "length": 370,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "id": 3217,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "id": 3218,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "id": 3219,
            "type": "LineElementType",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "id": 3220,
            "type": "LineElementType",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "id": 3221,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          },
          {
            "id": 3222,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9896",
            "startPosition": 311
          },
          {
            "id": 3223,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9897",
            "startPosition": 315
          },
          {
            "id": 3224,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9898",
            "startPosition": 319
          },
          {
            "id": 3225,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "9899",
            "startPosition": 323
          }
        ]
      },
      {
        "id": 151,
        "type": "LineType",
        "length": 370,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "id": 3226,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "id": 3227,
            "type": "LineElementType",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "id": 3228,
            "type": "LineElementType",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "id": 3229,
            "type": "LineElementType",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "id": 3230,
            "type": "LineElementType",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "id": 3231,
            "type": "LineElementType",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "id": 3232,
            "type": "LineElementType",
            "description": "TOTAAL INGEDIEND DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "id": 3233,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "id": 3234,
            "type": "LineElementType",
            "description": "TOTAAL TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9909",
            "startPosition": 46
          },
          {
            "id": 3235,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9910",
            "startPosition": 57
          },
          {
            "id": 3236,
            "type": "LineElementType",
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
    "id": 2,
    "type": "DocumentType",
    "description": "EI DECLARATIE EERSTELIJNSPSYCHOLOGISCHE HULP",
    "formatSubVersion": 2,
    "formatVersion": 1,
    "name": "EP301",
    "vektisEICode": 179,
    "lineTypes": [
      {
        "id": 7,
        "type": "LineType",
        "length": 310,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "id": 128,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "id": 129,
            "type": "LineElementType",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "id": 130,
            "type": "LineElementType",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "id": 131,
            "type": "LineElementType",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "id": 132,
            "type": "LineElementType",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "id": 133,
            "type": "LineElementType",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "id": 134,
            "type": "LineElementType",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "id": 135,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "id": 136,
            "type": "LineElementType",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "id": 137,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "id": 138,
            "type": "LineElementType",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "id": 139,
            "type": "LineElementType",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "id": 140,
            "type": "LineElementType",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "id": 141,
            "type": "LineElementType",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "id": 142,
            "type": "LineElementType",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "id": 143,
            "type": "LineElementType",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "id": 144,
            "type": "LineElementType",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "id": 145,
            "type": "LineElementType",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "id": 146,
            "type": "LineElementType",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "id": 147,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          }
        ]
      },
      {
        "id": 8,
        "type": "LineType",
        "length": 310,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "id": 148,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "id": 149,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "id": 150,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "id": 151,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "id": 152,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "id": 153,
            "type": "LineElementType",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "id": 154,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "id": 155,
            "type": "LineElementType",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "id": 156,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "id": 157,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "id": 158,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "id": 159,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "id": 160,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "id": 161,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "id": 162,
            "type": "LineElementType",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "id": 163,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "id": 164,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "id": 165,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "id": 166,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "id": 167,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "id": 168,
            "type": "LineElementType",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "id": 169,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "id": 170,
            "type": "LineElementType",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "id": 171,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 129,
            "lineElementId": "0280",
            "startPosition": 182
          }
        ]
      },
      {
        "id": 9,
        "type": "LineType",
        "length": 310,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "id": 172,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "id": 173,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "id": 174,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "id": 175,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "id": 176,
            "type": "LineElementType",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "id": 177,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "id": 178,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "id": 179,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "id": 180,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "id": 181,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "id": 182,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "id": 183,
            "type": "LineElementType",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "id": 184,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "id": 185,
            "type": "LineElementType",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "id": 186,
            "type": "LineElementType",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "id": 187,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "id": 188,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "id": 189,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "id": 190,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "id": 191,
            "type": "LineElementType",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "id": 192,
            "type": "LineElementType",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "id": 193,
            "type": "LineElementType",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "id": 194,
            "type": "LineElementType",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "id": 195,
            "type": "LineElementType",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "id": 196,
            "type": "LineElementType",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "id": 197,
            "type": "LineElementType",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "id": 198,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          }
        ]
      },
      {
        "id": 10,
        "type": "LineType",
        "length": 310,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "id": 199,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "id": 200,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "id": 201,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "id": 202,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "id": 203,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "id": 204,
            "type": "LineElementType",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "id": 205,
            "type": "LineElementType",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "id": 206,
            "type": "LineElementType",
            "description": "DATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "id": 207,
            "type": "LineElementType",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "id": 208,
            "type": "LineElementType",
            "description": "PRESTATIECODE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0410",
            "startPosition": 70
          },
          {
            "id": 209,
            "type": "LineElementType",
            "description": "AANDUIDING DIAGNOSECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0411",
            "startPosition": 75
          },
          {
            "id": 210,
            "type": "LineElementType",
            "description": "DIAGNOSECODE",
            "fieldType": "AN",
            "length": 8,
            "lineElementId": "0412",
            "startPosition": 78
          },
          {
            "id": 211,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0413",
            "startPosition": 86
          },
          {
            "id": 212,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0414",
            "startPosition": 94
          },
          {
            "id": 213,
            "type": "LineElementType",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0415",
            "startPosition": 102
          },
          {
            "id": 214,
            "type": "LineElementType",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0416",
            "startPosition": 106
          },
          {
            "id": 215,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0417",
            "startPosition": 114
          },
          {
            "id": 216,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0418",
            "startPosition": 122
          },
          {
            "id": 217,
            "type": "LineElementType",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0419",
            "startPosition": 123
          },
          {
            "id": 218,
            "type": "LineElementType",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 127
          },
          {
            "id": 219,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0421",
            "startPosition": 135
          },
          {
            "id": 220,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0422",
            "startPosition": 136
          },
          {
            "id": 221,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0423",
            "startPosition": 156
          },
          {
            "id": 222,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 135,
            "lineElementId": "0480",
            "startPosition": 176
          }
        ]
      },
      {
        "id": 11,
        "type": "LineType",
        "length": 310,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "id": 223,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "id": 224,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "id": 225,
            "type": "LineElementType",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "id": 226,
            "type": "LineElementType",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "id": 227,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          }
        ]
      },
      {
        "id": 12,
        "type": "LineType",
        "length": 310,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "id": 228,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "id": 229,
            "type": "LineElementType",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "id": 230,
            "type": "LineElementType",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "id": 231,
            "type": "LineElementType",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "id": 232,
            "type": "LineElementType",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "id": 233,
            "type": "LineElementType",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "id": 234,
            "type": "LineElementType",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "id": 235,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "id": 236,
            "type": "LineElementType",
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
    "id": 12,
    "type": "DocumentType",
    "description": "RETOURINFORMATIE DECLARATIE EERSTELIJNSPSYCHOLOGISCHE HULP",
    "formatSubVersion": 2,
    "formatVersion": 1,
    "name": "EP302",
    "vektisEICode": 180,
    "lineTypes": [
      {
        "id": 69,
        "type": "LineType",
        "length": 370,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "id": 1385,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "id": 1386,
            "type": "LineElementType",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "id": 1387,
            "type": "LineElementType",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "id": 1388,
            "type": "LineElementType",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "id": 1389,
            "type": "LineElementType",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "id": 1390,
            "type": "LineElementType",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "id": 1391,
            "type": "LineElementType",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "id": 1392,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "id": 1393,
            "type": "LineElementType",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "id": 1394,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "id": 1395,
            "type": "LineElementType",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "id": 1396,
            "type": "LineElementType",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "id": 1397,
            "type": "LineElementType",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "id": 1398,
            "type": "LineElementType",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "id": 1399,
            "type": "LineElementType",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "id": 1400,
            "type": "LineElementType",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "id": 1401,
            "type": "LineElementType",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "id": 1402,
            "type": "LineElementType",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "id": 1403,
            "type": "LineElementType",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "id": 1404,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          },
          {
            "id": 1405,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER ZORGVERZEKERAAR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0181",
            "startPosition": 311
          },
          {
            "id": 1406,
            "type": "LineElementType",
            "description": "DAGTEKENING RETOURBERICHT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0182",
            "startPosition": 335
          },
          {
            "id": 1407,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0196",
            "startPosition": 343
          },
          {
            "id": 1408,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0197",
            "startPosition": 347
          },
          {
            "id": 1409,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0198",
            "startPosition": 351
          },
          {
            "id": 1410,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 16,
            "lineElementId": "0199",
            "startPosition": 355
          }
        ]
      },
      {
        "id": 70,
        "type": "LineType",
        "length": 370,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "id": 1411,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "id": 1412,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "id": 1413,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "id": 1414,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "id": 1415,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "id": 1416,
            "type": "LineElementType",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "id": 1417,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "id": 1418,
            "type": "LineElementType",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "id": 1419,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "id": 1420,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "id": 1421,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "id": 1422,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "id": 1423,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "id": 1424,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "id": 1425,
            "type": "LineElementType",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "id": 1426,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "id": 1427,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "id": 1428,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "id": 1429,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "id": 1430,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "id": 1431,
            "type": "LineElementType",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "id": 1432,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "id": 1433,
            "type": "LineElementType",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "id": 1434,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 129,
            "lineElementId": "0280",
            "startPosition": 182
          },
          {
            "id": 1435,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0296",
            "startPosition": 311
          },
          {
            "id": 1436,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0297",
            "startPosition": 315
          },
          {
            "id": 1437,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0298",
            "startPosition": 319
          },
          {
            "id": 1438,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0299",
            "startPosition": 323
          }
        ]
      },
      {
        "id": 71,
        "type": "LineType",
        "length": 370,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "id": 1439,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "id": 1440,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "id": 1441,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "id": 1442,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "id": 1443,
            "type": "LineElementType",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "id": 1444,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "id": 1445,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "id": 1446,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "id": 1447,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "id": 1448,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "id": 1449,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "id": 1450,
            "type": "LineElementType",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "id": 1451,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "id": 1452,
            "type": "LineElementType",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "id": 1453,
            "type": "LineElementType",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "id": 1454,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "id": 1455,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "id": 1456,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "id": 1457,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "id": 1458,
            "type": "LineElementType",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "id": 1459,
            "type": "LineElementType",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "id": 1460,
            "type": "LineElementType",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "id": 1461,
            "type": "LineElementType",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "id": 1462,
            "type": "LineElementType",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "id": 1463,
            "type": "LineElementType",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "id": 1464,
            "type": "LineElementType",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "id": 1465,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          },
          {
            "id": 1466,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0396",
            "startPosition": 311
          },
          {
            "id": 1467,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0397",
            "startPosition": 315
          },
          {
            "id": 1468,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0398",
            "startPosition": 319
          },
          {
            "id": 1469,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0399",
            "startPosition": 323
          }
        ]
      },
      {
        "id": 72,
        "type": "LineType",
        "length": 370,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "id": 1470,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "id": 1471,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "id": 1472,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "id": 1473,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "id": 1474,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "id": 1475,
            "type": "LineElementType",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "id": 1476,
            "type": "LineElementType",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "id": 1477,
            "type": "LineElementType",
            "description": "DATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "id": 1478,
            "type": "LineElementType",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "id": 1479,
            "type": "LineElementType",
            "description": "PRESTATIECODE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0410",
            "startPosition": 70
          },
          {
            "id": 1480,
            "type": "LineElementType",
            "description": "AANDUIDING DIAGNOSECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0411",
            "startPosition": 75
          },
          {
            "id": 1481,
            "type": "LineElementType",
            "description": "DIAGNOSECODE",
            "fieldType": "AN",
            "length": 8,
            "lineElementId": "0412",
            "startPosition": 78
          },
          {
            "id": 1482,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0413",
            "startPosition": 86
          },
          {
            "id": 1483,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0414",
            "startPosition": 94
          },
          {
            "id": 1484,
            "type": "LineElementType",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0415",
            "startPosition": 102
          },
          {
            "id": 1485,
            "type": "LineElementType",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0416",
            "startPosition": 106
          },
          {
            "id": 1486,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0417",
            "startPosition": 114
          },
          {
            "id": 1487,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0418",
            "startPosition": 122
          },
          {
            "id": 1488,
            "type": "LineElementType",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0419",
            "startPosition": 123
          },
          {
            "id": 1489,
            "type": "LineElementType",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 127
          },
          {
            "id": 1490,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0421",
            "startPosition": 135
          },
          {
            "id": 1491,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0422",
            "startPosition": 136
          },
          {
            "id": 1492,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0423",
            "startPosition": 156
          },
          {
            "id": 1493,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 135,
            "lineElementId": "0480",
            "startPosition": 176
          },
          {
            "id": 1494,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG ZORGVERZEKERAAR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0481",
            "startPosition": 311
          },
          {
            "id": 1495,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0482",
            "startPosition": 319
          },
          {
            "id": 1496,
            "type": "LineElementType",
            "description": "TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0483",
            "startPosition": 320
          },
          {
            "id": 1497,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (04)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0484",
            "startPosition": 328
          },
          {
            "id": 1498,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0496",
            "startPosition": 329
          },
          {
            "id": 1499,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0497",
            "startPosition": 333
          },
          {
            "id": 1500,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0498",
            "startPosition": 337
          },
          {
            "id": 1501,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 30,
            "lineElementId": "0499",
            "startPosition": 341
          }
        ]
      },
      {
        "id": 73,
        "type": "LineType",
        "length": 370,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "id": 1502,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "id": 1503,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "id": 1504,
            "type": "LineElementType",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "id": 1505,
            "type": "LineElementType",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "id": 1506,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          },
          {
            "id": 1507,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9896",
            "startPosition": 311
          },
          {
            "id": 1508,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9897",
            "startPosition": 315
          },
          {
            "id": 1509,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9898",
            "startPosition": 319
          },
          {
            "id": 1510,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "9899",
            "startPosition": 323
          }
        ]
      },
      {
        "id": 74,
        "type": "LineType",
        "length": 370,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "id": 1511,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "id": 1512,
            "type": "LineElementType",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "id": 1513,
            "type": "LineElementType",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "id": 1514,
            "type": "LineElementType",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "id": 1515,
            "type": "LineElementType",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "id": 1516,
            "type": "LineElementType",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "id": 1517,
            "type": "LineElementType",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "id": 1518,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "id": 1519,
            "type": "LineElementType",
            "description": "TOTAAL TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9909",
            "startPosition": 46
          },
          {
            "id": 1520,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9910",
            "startPosition": 57
          },
          {
            "id": 1521,
            "type": "LineElementType",
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
    "id": 4,
    "type": "DocumentType",
    "description": "DECLARATIE HUISARTSENHULP",
    "formatSubVersion": 2,
    "formatVersion": 4,
    "name": "HA304",
    "vektisEICode": 112,
    "lineTypes": [
      {
        "id": 19,
        "type": "LineType",
        "length": 310,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "id": 350,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "id": 351,
            "type": "LineElementType",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "id": 352,
            "type": "LineElementType",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "id": 353,
            "type": "LineElementType",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "id": 354,
            "type": "LineElementType",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "id": 355,
            "type": "LineElementType",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "id": 356,
            "type": "LineElementType",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "id": 357,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "id": 358,
            "type": "LineElementType",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "id": 359,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "id": 360,
            "type": "LineElementType",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "id": 361,
            "type": "LineElementType",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "id": 362,
            "type": "LineElementType",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "id": 363,
            "type": "LineElementType",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "id": 364,
            "type": "LineElementType",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "id": 365,
            "type": "LineElementType",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "id": 366,
            "type": "LineElementType",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "id": 367,
            "type": "LineElementType",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "id": 368,
            "type": "LineElementType",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "id": 369,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          }
        ]
      },
      {
        "id": 20,
        "type": "LineType",
        "length": 310,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "id": 370,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "id": 371,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "id": 372,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "id": 373,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "id": 374,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "id": 375,
            "type": "LineElementType",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "id": 376,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "id": 377,
            "type": "LineElementType",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "id": 378,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "id": 379,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "id": 380,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "id": 381,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "id": 382,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "id": 383,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "id": 384,
            "type": "LineElementType",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "id": 385,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "id": 386,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "id": 387,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "id": 388,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "id": 389,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "id": 390,
            "type": "LineElementType",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "id": 391,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "id": 392,
            "type": "LineElementType",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "id": 393,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 129,
            "lineElementId": "0280",
            "startPosition": 182
          }
        ]
      },
      {
        "id": 21,
        "type": "LineType",
        "length": 310,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "id": 394,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "id": 395,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "id": 396,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "id": 397,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "id": 398,
            "type": "LineElementType",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "id": 399,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "id": 400,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "id": 401,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "id": 402,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "id": 403,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "id": 404,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "id": 405,
            "type": "LineElementType",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "id": 406,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "id": 407,
            "type": "LineElementType",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "id": 408,
            "type": "LineElementType",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "id": 409,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "id": 410,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "id": 411,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "id": 412,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "id": 413,
            "type": "LineElementType",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "id": 414,
            "type": "LineElementType",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "id": 415,
            "type": "LineElementType",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "id": 416,
            "type": "LineElementType",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "id": 417,
            "type": "LineElementType",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "id": 418,
            "type": "LineElementType",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "id": 419,
            "type": "LineElementType",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "id": 420,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          }
        ]
      },
      {
        "id": 22,
        "type": "LineType",
        "length": 310,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "id": 421,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "id": 422,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "id": 423,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "id": 424,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "id": 425,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "id": 426,
            "type": "LineElementType",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "id": 427,
            "type": "LineElementType",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "id": 428,
            "type": "LineElementType",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "id": 429,
            "type": "LineElementType",
            "description": "EINDDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "id": 430,
            "type": "LineElementType",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0410",
            "startPosition": 75
          },
          {
            "id": 431,
            "type": "LineElementType",
            "description": "PRESTATIECODE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0411",
            "startPosition": 78
          },
          {
            "id": 432,
            "type": "LineElementType",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0412",
            "startPosition": 83
          },
          {
            "id": 433,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0413",
            "startPosition": 87
          },
          {
            "id": 434,
            "type": "LineElementType",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0414",
            "startPosition": 95
          },
          {
            "id": 435,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0415",
            "startPosition": 103
          },
          {
            "id": 436,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0416",
            "startPosition": 111
          },
          {
            "id": 437,
            "type": "LineElementType",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0417",
            "startPosition": 112
          },
          {
            "id": 438,
            "type": "LineElementType",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0418",
            "startPosition": 116
          },
          {
            "id": 439,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0419",
            "startPosition": 124
          },
          {
            "id": 440,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0420",
            "startPosition": 125
          },
          {
            "id": 441,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0421",
            "startPosition": 145
          },
          {
            "id": 442,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 146,
            "lineElementId": "0480",
            "startPosition": 165
          }
        ]
      },
      {
        "id": 23,
        "type": "LineType",
        "length": 310,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "id": 443,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "id": 444,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "id": 445,
            "type": "LineElementType",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "id": 446,
            "type": "LineElementType",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "id": 447,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          }
        ]
      },
      {
        "id": 24,
        "type": "LineType",
        "length": 310,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "id": 448,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "id": 449,
            "type": "LineElementType",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "id": 450,
            "type": "LineElementType",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "id": 451,
            "type": "LineElementType",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "id": 452,
            "type": "LineElementType",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "id": 453,
            "type": "LineElementType",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "id": 454,
            "type": "LineElementType",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "id": 455,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "id": 456,
            "type": "LineElementType",
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
    "id": 14,
    "type": "DocumentType",
    "description": "RETOURINFORMATIE DECLARATIE HUISARTSENHULP",
    "formatSubVersion": 2,
    "formatVersion": 4,
    "name": "HA305",
    "vektisEICode": 113,
    "lineTypes": [
      {
        "id": 81,
        "type": "LineType",
        "length": 380,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "id": 1663,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "id": 1664,
            "type": "LineElementType",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "id": 1665,
            "type": "LineElementType",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "id": 1666,
            "type": "LineElementType",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "id": 1667,
            "type": "LineElementType",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "id": 1668,
            "type": "LineElementType",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "id": 1669,
            "type": "LineElementType",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "id": 1670,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "id": 1671,
            "type": "LineElementType",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "id": 1672,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "id": 1673,
            "type": "LineElementType",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "id": 1674,
            "type": "LineElementType",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "id": 1675,
            "type": "LineElementType",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "id": 1676,
            "type": "LineElementType",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "id": 1677,
            "type": "LineElementType",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "id": 1678,
            "type": "LineElementType",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "id": 1679,
            "type": "LineElementType",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "id": 1680,
            "type": "LineElementType",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "id": 1681,
            "type": "LineElementType",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "id": 1682,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          },
          {
            "id": 1683,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER ZORGVERZEKERAAR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0181",
            "startPosition": 311
          },
          {
            "id": 1684,
            "type": "LineElementType",
            "description": "DAGTEKENING RETOURBERICHT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0182",
            "startPosition": 335
          },
          {
            "id": 1685,
            "type": "LineElementType",
            "description": "CODE VERWERKING",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0189",
            "startPosition": 343
          },
          {
            "id": 1686,
            "type": "LineElementType",
            "description": "FOUT RUBRIEKNUMMER (01)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0190",
            "startPosition": 346
          },
          {
            "id": 1687,
            "type": "LineElementType",
            "description": "FOUTCODE (01)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0191",
            "startPosition": 350
          },
          {
            "id": 1688,
            "type": "LineElementType",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0192",
            "startPosition": 353
          },
          {
            "id": 1689,
            "type": "LineElementType",
            "description": "FOUT RUBRIEKNUMMER (02)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0193",
            "startPosition": 354
          },
          {
            "id": 1690,
            "type": "LineElementType",
            "description": "FOUTCODE (02)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0194",
            "startPosition": 358
          },
          {
            "id": 1691,
            "type": "LineElementType",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0195",
            "startPosition": 361
          },
          {
            "id": 1692,
            "type": "LineElementType",
            "description": "FOUT RUBRIEKNUMMER (03)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0196",
            "startPosition": 362
          },
          {
            "id": 1693,
            "type": "LineElementType",
            "description": "FOUTCODE (03)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0197",
            "startPosition": 366
          },
          {
            "id": 1694,
            "type": "LineElementType",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0198",
            "startPosition": 369
          },
          {
            "id": 1695,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0199",
            "startPosition": 370
          }
        ]
      },
      {
        "id": 82,
        "type": "LineType",
        "length": 380,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "id": 1696,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "id": 1697,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "id": 1698,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "id": 1699,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "id": 1700,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "id": 1701,
            "type": "LineElementType",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "id": 1702,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "id": 1703,
            "type": "LineElementType",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "id": 1704,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "id": 1705,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "id": 1706,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "id": 1707,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "id": 1708,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "id": 1709,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "id": 1710,
            "type": "LineElementType",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "id": 1711,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "id": 1712,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "id": 1713,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "id": 1714,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "id": 1715,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "id": 1716,
            "type": "LineElementType",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "id": 1717,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "id": 1718,
            "type": "LineElementType",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "id": 1719,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 129,
            "lineElementId": "0280",
            "startPosition": 182
          },
          {
            "id": 1720,
            "type": "LineElementType",
            "description": "CODE VERWERKING",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0289",
            "startPosition": 311
          },
          {
            "id": 1721,
            "type": "LineElementType",
            "description": "FOUT RUBRIEKNUMMER (01)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0290",
            "startPosition": 314
          },
          {
            "id": 1722,
            "type": "LineElementType",
            "description": "FOUTCODE (01)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0291",
            "startPosition": 318
          },
          {
            "id": 1723,
            "type": "LineElementType",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0292",
            "startPosition": 321
          },
          {
            "id": 1724,
            "type": "LineElementType",
            "description": "FOUT RUBRIEKNUMMER (02)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0293",
            "startPosition": 322
          },
          {
            "id": 1725,
            "type": "LineElementType",
            "description": "FOUTCODE (02)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0294",
            "startPosition": 326
          },
          {
            "id": 1726,
            "type": "LineElementType",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0295",
            "startPosition": 329
          },
          {
            "id": 1727,
            "type": "LineElementType",
            "description": "FOUT RUBRIEKNUMMER (03)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0296",
            "startPosition": 330
          },
          {
            "id": 1728,
            "type": "LineElementType",
            "description": "FOUTCODE (03)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0297",
            "startPosition": 334
          },
          {
            "id": 1729,
            "type": "LineElementType",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0298",
            "startPosition": 337
          },
          {
            "id": 1730,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 43,
            "lineElementId": "0299",
            "startPosition": 338
          }
        ]
      },
      {
        "id": 83,
        "type": "LineType",
        "length": 380,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "id": 1731,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "id": 1732,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "id": 1733,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "id": 1734,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "id": 1735,
            "type": "LineElementType",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "id": 1736,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "id": 1737,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "id": 1738,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "id": 1739,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "id": 1740,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "id": 1741,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "id": 1742,
            "type": "LineElementType",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "id": 1743,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "id": 1744,
            "type": "LineElementType",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "id": 1745,
            "type": "LineElementType",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "id": 1746,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "id": 1747,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "id": 1748,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "id": 1749,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "id": 1750,
            "type": "LineElementType",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "id": 1751,
            "type": "LineElementType",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "id": 1752,
            "type": "LineElementType",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "id": 1753,
            "type": "LineElementType",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "id": 1754,
            "type": "LineElementType",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "id": 1755,
            "type": "LineElementType",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "id": 1756,
            "type": "LineElementType",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "id": 1757,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          },
          {
            "id": 1758,
            "type": "LineElementType",
            "description": "CODE VERWERKING",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0389",
            "startPosition": 311
          },
          {
            "id": 1759,
            "type": "LineElementType",
            "description": "FOUT RUBRIEKNUMMER (01)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0390",
            "startPosition": 314
          },
          {
            "id": 1760,
            "type": "LineElementType",
            "description": "FOUTCODE (01)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0391",
            "startPosition": 318
          },
          {
            "id": 1761,
            "type": "LineElementType",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0392",
            "startPosition": 321
          },
          {
            "id": 1762,
            "type": "LineElementType",
            "description": "FOUT RUBRIEKNUMMER (02)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0393",
            "startPosition": 322
          },
          {
            "id": 1763,
            "type": "LineElementType",
            "description": "FOUTCODE (02)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0394",
            "startPosition": 326
          },
          {
            "id": 1764,
            "type": "LineElementType",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0395",
            "startPosition": 329
          },
          {
            "id": 1765,
            "type": "LineElementType",
            "description": "FOUT RUBRIEKNUMMER (03)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0396",
            "startPosition": 330
          },
          {
            "id": 1766,
            "type": "LineElementType",
            "description": "FOUTCODE (03)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0397",
            "startPosition": 334
          },
          {
            "id": 1767,
            "type": "LineElementType",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0398",
            "startPosition": 337
          },
          {
            "id": 1768,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 43,
            "lineElementId": "0399",
            "startPosition": 338
          }
        ]
      },
      {
        "id": 84,
        "type": "LineType",
        "length": 380,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "id": 1769,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "id": 1770,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "id": 1771,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "id": 1772,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "id": 1773,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "id": 1774,
            "type": "LineElementType",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "id": 1775,
            "type": "LineElementType",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "id": 1776,
            "type": "LineElementType",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "id": 1777,
            "type": "LineElementType",
            "description": "EINDDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "id": 1778,
            "type": "LineElementType",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0410",
            "startPosition": 75
          },
          {
            "id": 1779,
            "type": "LineElementType",
            "description": "PRESTATIECODE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0411",
            "startPosition": 78
          },
          {
            "id": 1780,
            "type": "LineElementType",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0412",
            "startPosition": 83
          },
          {
            "id": 1781,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0413",
            "startPosition": 87
          },
          {
            "id": 1782,
            "type": "LineElementType",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0414",
            "startPosition": 95
          },
          {
            "id": 1783,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0415",
            "startPosition": 103
          },
          {
            "id": 1784,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0416",
            "startPosition": 111
          },
          {
            "id": 1785,
            "type": "LineElementType",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0417",
            "startPosition": 112
          },
          {
            "id": 1786,
            "type": "LineElementType",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0418",
            "startPosition": 116
          },
          {
            "id": 1787,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0419",
            "startPosition": 124
          },
          {
            "id": 1788,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0420",
            "startPosition": 125
          },
          {
            "id": 1789,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0421",
            "startPosition": 145
          },
          {
            "id": 1790,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 146,
            "lineElementId": "0480",
            "startPosition": 165
          },
          {
            "id": 1791,
            "type": "LineElementType",
            "description": "TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0481",
            "startPosition": 311
          },
          {
            "id": 1792,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0482",
            "startPosition": 319
          },
          {
            "id": 1793,
            "type": "LineElementType",
            "description": "CODE VERWERKING",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0489",
            "startPosition": 320
          },
          {
            "id": 1794,
            "type": "LineElementType",
            "description": "FOUT RUBRIEKNUMMER (01)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0490",
            "startPosition": 323
          },
          {
            "id": 1795,
            "type": "LineElementType",
            "description": "FOUTCODE (01)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0491",
            "startPosition": 327
          },
          {
            "id": 1796,
            "type": "LineElementType",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0492",
            "startPosition": 330
          },
          {
            "id": 1797,
            "type": "LineElementType",
            "description": "FOUT RUBRIEKNUMMER (02)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0493",
            "startPosition": 331
          },
          {
            "id": 1798,
            "type": "LineElementType",
            "description": "FOUTCODE (02)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0494",
            "startPosition": 335
          },
          {
            "id": 1799,
            "type": "LineElementType",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0495",
            "startPosition": 338
          },
          {
            "id": 1800,
            "type": "LineElementType",
            "description": "FOUT RUBRIEKNUMMER (03)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0496",
            "startPosition": 339
          },
          {
            "id": 1801,
            "type": "LineElementType",
            "description": "FOUTCODE (03)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0497",
            "startPosition": 343
          },
          {
            "id": 1802,
            "type": "LineElementType",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0498",
            "startPosition": 346
          },
          {
            "id": 1803,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 34,
            "lineElementId": "0499",
            "startPosition": 347
          }
        ]
      },
      {
        "id": 85,
        "type": "LineType",
        "length": 380,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "id": 1804,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "id": 1805,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "id": 1806,
            "type": "LineElementType",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "id": 1807,
            "type": "LineElementType",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "id": 1808,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          },
          {
            "id": 1809,
            "type": "LineElementType",
            "description": "CODE VERWERKING",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "9889",
            "startPosition": 311
          },
          {
            "id": 1810,
            "type": "LineElementType",
            "description": "FOUT RUBRIEKNUMMER (01)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9890",
            "startPosition": 314
          },
          {
            "id": 1811,
            "type": "LineElementType",
            "description": "FOUTCODE (01)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "9891",
            "startPosition": 318
          },
          {
            "id": 1812,
            "type": "LineElementType",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9892",
            "startPosition": 321
          },
          {
            "id": 1813,
            "type": "LineElementType",
            "description": "FOUT RUBRIEKNUMMER (02)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9893",
            "startPosition": 322
          },
          {
            "id": 1814,
            "type": "LineElementType",
            "description": "FOUTCODE (02)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "9894",
            "startPosition": 326
          },
          {
            "id": 1815,
            "type": "LineElementType",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9895",
            "startPosition": 329
          },
          {
            "id": 1816,
            "type": "LineElementType",
            "description": "FOUT RUBRIEKNUMMER (03)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9896",
            "startPosition": 330
          },
          {
            "id": 1817,
            "type": "LineElementType",
            "description": "FOUTCODE (03)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "9897",
            "startPosition": 334
          },
          {
            "id": 1818,
            "type": "LineElementType",
            "description": "INDICATIE RUBRIEK GEWIJZIGD (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9898",
            "startPosition": 337
          },
          {
            "id": 1819,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 43,
            "lineElementId": "9899",
            "startPosition": 338
          }
        ]
      },
      {
        "id": 86,
        "type": "LineType",
        "length": 380,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "id": 1820,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "id": 1821,
            "type": "LineElementType",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "id": 1822,
            "type": "LineElementType",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "id": 1823,
            "type": "LineElementType",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "id": 1824,
            "type": "LineElementType",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "id": 1825,
            "type": "LineElementType",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "id": 1826,
            "type": "LineElementType",
            "description": "TOTAAL INGEDIEND DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "id": 1827,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "id": 1828,
            "type": "LineElementType",
            "description": "TOTAAL TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9909",
            "startPosition": 46
          },
          {
            "id": 1829,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9910",
            "startPosition": 57
          },
          {
            "id": 1830,
            "type": "LineElementType",
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
    "id": 5,
    "type": "DocumentType",
    "description": "DECLARATIE HULPMIDDELEN",
    "formatSubVersion": 2,
    "formatVersion": 5,
    "name": "LH307",
    "vektisEICode": 110,
    "lineTypes": [
      {
        "id": 25,
        "type": "LineType",
        "length": 310,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "id": 457,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "id": 458,
            "type": "LineElementType",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "id": 459,
            "type": "LineElementType",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "id": 460,
            "type": "LineElementType",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "id": 461,
            "type": "LineElementType",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "id": 462,
            "type": "LineElementType",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "id": 463,
            "type": "LineElementType",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "id": 464,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "id": 465,
            "type": "LineElementType",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "id": 466,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "id": 467,
            "type": "LineElementType",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "id": 468,
            "type": "LineElementType",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "id": 469,
            "type": "LineElementType",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "id": 470,
            "type": "LineElementType",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "id": 471,
            "type": "LineElementType",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "id": 472,
            "type": "LineElementType",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "id": 473,
            "type": "LineElementType",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "id": 474,
            "type": "LineElementType",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "id": 475,
            "type": "LineElementType",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "id": 476,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          }
        ]
      },
      {
        "id": 26,
        "type": "LineType",
        "length": 310,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "id": 477,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "id": 478,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "id": 479,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "id": 480,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "id": 481,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "id": 482,
            "type": "LineElementType",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "id": 483,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "id": 484,
            "type": "LineElementType",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "id": 485,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "id": 486,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "id": 487,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "id": 488,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "id": 489,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "id": 490,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "id": 491,
            "type": "LineElementType",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "id": 492,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "id": 493,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "id": 494,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "id": 495,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "id": 496,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "id": 497,
            "type": "LineElementType",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "id": 498,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "id": 499,
            "type": "LineElementType",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "id": 500,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 129,
            "lineElementId": "0280",
            "startPosition": 182
          }
        ]
      },
      {
        "id": 27,
        "type": "LineType",
        "length": 310,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "id": 501,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "id": 502,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "id": 503,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "id": 504,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "id": 505,
            "type": "LineElementType",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "id": 506,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "id": 507,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "id": 508,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "id": 509,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "id": 510,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "id": 511,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "id": 512,
            "type": "LineElementType",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "id": 513,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "id": 514,
            "type": "LineElementType",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "id": 515,
            "type": "LineElementType",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "id": 516,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "id": 517,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "id": 518,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "id": 519,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "id": 520,
            "type": "LineElementType",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "id": 521,
            "type": "LineElementType",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "id": 522,
            "type": "LineElementType",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "id": 523,
            "type": "LineElementType",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "id": 524,
            "type": "LineElementType",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "id": 525,
            "type": "LineElementType",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "id": 526,
            "type": "LineElementType",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "id": 527,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          }
        ]
      },
      {
        "id": 28,
        "type": "LineType",
        "length": 310,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "id": 528,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "id": 529,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "id": 530,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "id": 531,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "id": 532,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "id": 533,
            "type": "LineElementType",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "id": 534,
            "type": "LineElementType",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "id": 535,
            "type": "LineElementType",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "id": 536,
            "type": "LineElementType",
            "description": "EINDDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "id": 537,
            "type": "LineElementType",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0410",
            "startPosition": 75
          },
          {
            "id": 538,
            "type": "LineElementType",
            "description": "PRESTATIECODE (GPH)",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0411",
            "startPosition": 78
          },
          {
            "id": 539,
            "type": "LineElementType",
            "description": "A-GPH-1 AANVULLENDE GENERIEKE PRODUCTCODE HULPMIDDELEN 1",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0412",
            "startPosition": 90
          },
          {
            "id": 540,
            "type": "LineElementType",
            "description": "A-GPH-2 AANVULLENDE GENERIEKE PRODUCTCODE HULPMIDDELEN 2",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0413",
            "startPosition": 96
          },
          {
            "id": 541,
            "type": "LineElementType",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0414",
            "startPosition": 102
          },
          {
            "id": 542,
            "type": "LineElementType",
            "description": "ARTIKELCODE HULPMIDDEL",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0415",
            "startPosition": 105
          },
          {
            "id": 543,
            "type": "LineElementType",
            "description": "MERKNAAM",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0416",
            "startPosition": 117
          },
          {
            "id": 544,
            "type": "LineElementType",
            "description": "TYPE HULPMIDDEL",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0417",
            "startPosition": 137
          },
          {
            "id": 545,
            "type": "LineElementType",
            "description": "DATUM AFLEVERING VOORGAAND HULPMIDDEL",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0418",
            "startPosition": 157
          },
          {
            "id": 546,
            "type": "LineElementType",
            "description": "INDICATIE MEDISCH VOORSCHRIFT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0419",
            "startPosition": 165
          },
          {
            "id": 547,
            "type": "LineElementType",
            "description": "DATUM AFGIFTE MEDISCH VOORSCHRIFT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 166
          },
          {
            "id": 548,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0421",
            "startPosition": 174
          },
          {
            "id": 549,
            "type": "LineElementType",
            "description": "SPECIALISME BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0422",
            "startPosition": 182
          },
          {
            "id": 550,
            "type": "LineElementType",
            "description": "INDICATIE SAMENGESTELD MIDDEL (TOTAAL, BESTANDDEEL/DETAILINFORMATIE)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0423",
            "startPosition": 186
          },
          {
            "id": 551,
            "type": "LineElementType",
            "description": "INDICATIE POSITIE HULPMIDDEL",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0424",
            "startPosition": 187
          },
          {
            "id": 552,
            "type": "LineElementType",
            "description": "AFLEVERINGSEENHEID",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0425",
            "startPosition": 189
          },
          {
            "id": 553,
            "type": "LineElementType",
            "description": "HOEVEELHEID AFGELEVERD IN AANGEGEVEN AFLEVEREENHEID",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0426",
            "startPosition": 191
          },
          {
            "id": 554,
            "type": "LineElementType",
            "description": "HOEVEELHEID AFGELEVERD IN STUKS",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0427",
            "startPosition": 196
          },
          {
            "id": 555,
            "type": "LineElementType",
            "description": "SOORT KOSTEN HULPMIDDEL",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0428",
            "startPosition": 201
          },
          {
            "id": 556,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0429",
            "startPosition": 203
          },
          {
            "id": 557,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0430",
            "startPosition": 211
          },
          {
            "id": 558,
            "type": "LineElementType",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0431",
            "startPosition": 212
          },
          {
            "id": 559,
            "type": "LineElementType",
            "description": "BEDRAG ONTVANGEN EIGEN BIJDRAGE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0432",
            "startPosition": 216
          },
          {
            "id": 560,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0433",
            "startPosition": 224
          },
          {
            "id": 561,
            "type": "LineElementType",
            "description": "DECLARATIEBEDRAG BASISVERZEKERING",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0434",
            "startPosition": 225
          },
          {
            "id": 562,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0435",
            "startPosition": 233
          },
          {
            "id": 563,
            "type": "LineElementType",
            "description": "DECLARATIEBEDRAG AANVULLENDE VERZEKERING",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0436",
            "startPosition": 234
          },
          {
            "id": 564,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (04)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0437",
            "startPosition": 242
          },
          {
            "id": 565,
            "type": "LineElementType",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0438",
            "startPosition": 243
          },
          {
            "id": 566,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (05)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0439",
            "startPosition": 251
          },
          {
            "id": 567,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0440",
            "startPosition": 252
          },
          {
            "id": 568,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0441",
            "startPosition": 272
          },
          {
            "id": 569,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 19,
            "lineElementId": "0480",
            "startPosition": 292
          }
        ]
      },
      {
        "id": 29,
        "type": "LineType",
        "length": 310,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "id": 570,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "id": 571,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "id": 572,
            "type": "LineElementType",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "id": 573,
            "type": "LineElementType",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "id": 574,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          }
        ]
      },
      {
        "id": 30,
        "type": "LineType",
        "length": 310,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "id": 575,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "id": 576,
            "type": "LineElementType",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "id": 577,
            "type": "LineElementType",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "id": 578,
            "type": "LineElementType",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "id": 579,
            "type": "LineElementType",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "id": 580,
            "type": "LineElementType",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "id": 581,
            "type": "LineElementType",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "id": 582,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "id": 583,
            "type": "LineElementType",
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
    "id": 15,
    "type": "DocumentType",
    "description": "RETOURINFORMATIE DECLARATIE HULPMIDDELEN",
    "formatSubVersion": 2,
    "formatVersion": 5,
    "name": "LH308",
    "vektisEICode": 111,
    "lineTypes": [
      {
        "id": 87,
        "type": "LineType",
        "length": 370,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "id": 1831,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "id": 1832,
            "type": "LineElementType",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "id": 1833,
            "type": "LineElementType",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "id": 1834,
            "type": "LineElementType",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "id": 1835,
            "type": "LineElementType",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "id": 1836,
            "type": "LineElementType",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "id": 1837,
            "type": "LineElementType",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "id": 1838,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "id": 1839,
            "type": "LineElementType",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "id": 1840,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "id": 1841,
            "type": "LineElementType",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "id": 1842,
            "type": "LineElementType",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "id": 1843,
            "type": "LineElementType",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "id": 1844,
            "type": "LineElementType",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "id": 1845,
            "type": "LineElementType",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "id": 1846,
            "type": "LineElementType",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "id": 1847,
            "type": "LineElementType",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "id": 1848,
            "type": "LineElementType",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "id": 1849,
            "type": "LineElementType",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "id": 1850,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          },
          {
            "id": 1851,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER ZORGVERZEKERAAR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0181",
            "startPosition": 311
          },
          {
            "id": 1852,
            "type": "LineElementType",
            "description": "DAGTEKENING RETOURBERICHT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0182",
            "startPosition": 335
          },
          {
            "id": 1853,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0196",
            "startPosition": 343
          },
          {
            "id": 1854,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0197",
            "startPosition": 347
          },
          {
            "id": 1855,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0198",
            "startPosition": 351
          },
          {
            "id": 1856,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 16,
            "lineElementId": "0199",
            "startPosition": 355
          }
        ]
      },
      {
        "id": 88,
        "type": "LineType",
        "length": 370,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "id": 1857,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "id": 1858,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "id": 1859,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "id": 1860,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "id": 1861,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "id": 1862,
            "type": "LineElementType",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "id": 1863,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "id": 1864,
            "type": "LineElementType",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "id": 1865,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "id": 1866,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "id": 1867,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "id": 1868,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "id": 1869,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "id": 1870,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "id": 1871,
            "type": "LineElementType",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "id": 1872,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "id": 1873,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "id": 1874,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "id": 1875,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "id": 1876,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "id": 1877,
            "type": "LineElementType",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "id": 1878,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "id": 1879,
            "type": "LineElementType",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "id": 1880,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 129,
            "lineElementId": "0280",
            "startPosition": 182
          },
          {
            "id": 1881,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0296",
            "startPosition": 311
          },
          {
            "id": 1882,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0297",
            "startPosition": 315
          },
          {
            "id": 1883,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0298",
            "startPosition": 319
          },
          {
            "id": 1884,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0299",
            "startPosition": 323
          }
        ]
      },
      {
        "id": 89,
        "type": "LineType",
        "length": 370,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "id": 1885,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "id": 1886,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "id": 1887,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "id": 1888,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "id": 1889,
            "type": "LineElementType",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "id": 1890,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "id": 1891,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "id": 1892,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "id": 1893,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "id": 1894,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "id": 1895,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "id": 1896,
            "type": "LineElementType",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "id": 1897,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "id": 1898,
            "type": "LineElementType",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "id": 1899,
            "type": "LineElementType",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "id": 1900,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "id": 1901,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "id": 1902,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "id": 1903,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "id": 1904,
            "type": "LineElementType",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "id": 1905,
            "type": "LineElementType",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "id": 1906,
            "type": "LineElementType",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "id": 1907,
            "type": "LineElementType",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "id": 1908,
            "type": "LineElementType",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "id": 1909,
            "type": "LineElementType",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "id": 1910,
            "type": "LineElementType",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "id": 1911,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          },
          {
            "id": 1912,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0396",
            "startPosition": 311
          },
          {
            "id": 1913,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0397",
            "startPosition": 315
          },
          {
            "id": 1914,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0398",
            "startPosition": 319
          },
          {
            "id": 1915,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0399",
            "startPosition": 323
          }
        ]
      },
      {
        "id": 90,
        "type": "LineType",
        "length": 370,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "id": 1916,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "id": 1917,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "id": 1918,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "id": 1919,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "id": 1920,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "id": 1921,
            "type": "LineElementType",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "id": 1922,
            "type": "LineElementType",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "id": 1923,
            "type": "LineElementType",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "id": 1924,
            "type": "LineElementType",
            "description": "EINDDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "id": 1925,
            "type": "LineElementType",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0410",
            "startPosition": 75
          },
          {
            "id": 1926,
            "type": "LineElementType",
            "description": "PRESTATIECODE (GPH)",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0411",
            "startPosition": 78
          },
          {
            "id": 1927,
            "type": "LineElementType",
            "description": "A-GPH-1 AANVULLENDE GENERIEKE PRODUCTCODE HULPMIDDELEN 1",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0412",
            "startPosition": 90
          },
          {
            "id": 1928,
            "type": "LineElementType",
            "description": "A-GPH-2 AANVULLENDE GENERIEKE PRODUCTCODE HULPMIDDELEN 2",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0413",
            "startPosition": 96
          },
          {
            "id": 1929,
            "type": "LineElementType",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0414",
            "startPosition": 102
          },
          {
            "id": 1930,
            "type": "LineElementType",
            "description": "ARTIKELCODE HULPMIDDEL",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0415",
            "startPosition": 105
          },
          {
            "id": 1931,
            "type": "LineElementType",
            "description": "MERKNAAM",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0416",
            "startPosition": 117
          },
          {
            "id": 1932,
            "type": "LineElementType",
            "description": "TYPE HULPMIDDEL",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0417",
            "startPosition": 137
          },
          {
            "id": 1933,
            "type": "LineElementType",
            "description": "DATUM AFLEVERING VOORGAAND HULPMIDDEL",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0418",
            "startPosition": 157
          },
          {
            "id": 1934,
            "type": "LineElementType",
            "description": "INDICATIE MEDISCH VOORSCHRIFT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0419",
            "startPosition": 165
          },
          {
            "id": 1935,
            "type": "LineElementType",
            "description": "DATUM AFGIFTE MEDISCH VOORSCHRIFT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 166
          },
          {
            "id": 1936,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0421",
            "startPosition": 174
          },
          {
            "id": 1937,
            "type": "LineElementType",
            "description": "SPECIALISME BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0422",
            "startPosition": 182
          },
          {
            "id": 1938,
            "type": "LineElementType",
            "description": "INDICATIE SAMENGESTELD MIDDEL (TOTAAL, BESTANDDEEL/DETAILINFORMATIE)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0423",
            "startPosition": 186
          },
          {
            "id": 1939,
            "type": "LineElementType",
            "description": "INDICATIE POSITIE HULPMIDDEL",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0424",
            "startPosition": 187
          },
          {
            "id": 1940,
            "type": "LineElementType",
            "description": "AFLEVERINGSEENHEID",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0425",
            "startPosition": 189
          },
          {
            "id": 1941,
            "type": "LineElementType",
            "description": "HOEVEELHEID AFGELEVERD IN AANGEGEVEN AFLEVEREENHEID",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0426",
            "startPosition": 191
          },
          {
            "id": 1942,
            "type": "LineElementType",
            "description": "HOEVEELHEID AFGELEVERD IN STUKS",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0427",
            "startPosition": 196
          },
          {
            "id": 1943,
            "type": "LineElementType",
            "description": "SOORT KOSTEN HULPMIDDEL",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0428",
            "startPosition": 201
          },
          {
            "id": 1944,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0429",
            "startPosition": 203
          },
          {
            "id": 1945,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0430",
            "startPosition": 211
          },
          {
            "id": 1946,
            "type": "LineElementType",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0431",
            "startPosition": 212
          },
          {
            "id": 1947,
            "type": "LineElementType",
            "description": "BEDRAG ONTVANGEN EIGEN BIJDRAGE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0432",
            "startPosition": 216
          },
          {
            "id": 1948,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0433",
            "startPosition": 224
          },
          {
            "id": 1949,
            "type": "LineElementType",
            "description": "DECLARATIEBEDRAG BASISVERZEKERING",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0434",
            "startPosition": 225
          },
          {
            "id": 1950,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0435",
            "startPosition": 233
          },
          {
            "id": 1951,
            "type": "LineElementType",
            "description": "DECLARATIEBEDRAG AANVULLENDE VERZEKERING",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0436",
            "startPosition": 234
          },
          {
            "id": 1952,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (04)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0437",
            "startPosition": 242
          },
          {
            "id": 1953,
            "type": "LineElementType",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0438",
            "startPosition": 243
          },
          {
            "id": 1954,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (05)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0439",
            "startPosition": 251
          },
          {
            "id": 1955,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0440",
            "startPosition": 252
          },
          {
            "id": 1956,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0441",
            "startPosition": 272
          },
          {
            "id": 1957,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 19,
            "lineElementId": "0480",
            "startPosition": 292
          },
          {
            "id": 1958,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG ZORGVERZEKERAAR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0481",
            "startPosition": 311
          },
          {
            "id": 1959,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (06)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0482",
            "startPosition": 319
          },
          {
            "id": 1960,
            "type": "LineElementType",
            "description": "TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0483",
            "startPosition": 320
          },
          {
            "id": 1961,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (07)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0484",
            "startPosition": 328
          },
          {
            "id": 1962,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0496",
            "startPosition": 329
          },
          {
            "id": 1963,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0497",
            "startPosition": 333
          },
          {
            "id": 1964,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0498",
            "startPosition": 337
          },
          {
            "id": 1965,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 30,
            "lineElementId": "0499",
            "startPosition": 341
          }
        ]
      },
      {
        "id": 91,
        "type": "LineType",
        "length": 370,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "id": 1966,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "id": 1967,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "id": 1968,
            "type": "LineElementType",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "id": 1969,
            "type": "LineElementType",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "id": 1970,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          },
          {
            "id": 1971,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9896",
            "startPosition": 311
          },
          {
            "id": 1972,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9897",
            "startPosition": 315
          },
          {
            "id": 1973,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9898",
            "startPosition": 319
          },
          {
            "id": 1974,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "9899",
            "startPosition": 323
          }
        ]
      },
      {
        "id": 92,
        "type": "LineType",
        "length": 370,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "id": 1975,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "id": 1976,
            "type": "LineElementType",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "id": 1977,
            "type": "LineElementType",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "id": 1978,
            "type": "LineElementType",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "id": 1979,
            "type": "LineElementType",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "id": 1980,
            "type": "LineElementType",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "id": 1981,
            "type": "LineElementType",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "id": 1982,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "id": 1983,
            "type": "LineElementType",
            "description": "TOTAAL TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9909",
            "startPosition": 46
          },
          {
            "id": 1984,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9910",
            "startPosition": 57
          },
          {
            "id": 1985,
            "type": "LineElementType",
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
    "id": 6,
    "type": "DocumentType",
    "description": "DECLARATIE MONDZORG",
    "formatSubVersion": 3,
    "formatVersion": 1,
    "name": "MZ301",
    "vektisEICode": 176,
    "lineTypes": [
      {
        "id": 31,
        "type": "LineType",
        "length": 310,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "id": 584,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "id": 585,
            "type": "LineElementType",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "id": 586,
            "type": "LineElementType",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "id": 587,
            "type": "LineElementType",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "id": 588,
            "type": "LineElementType",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "id": 589,
            "type": "LineElementType",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "id": 590,
            "type": "LineElementType",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "id": 591,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "id": 592,
            "type": "LineElementType",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "id": 593,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "id": 594,
            "type": "LineElementType",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "id": 595,
            "type": "LineElementType",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "id": 596,
            "type": "LineElementType",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "id": 597,
            "type": "LineElementType",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "id": 598,
            "type": "LineElementType",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "id": 599,
            "type": "LineElementType",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "id": 600,
            "type": "LineElementType",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "id": 601,
            "type": "LineElementType",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "id": 602,
            "type": "LineElementType",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "id": 603,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          }
        ]
      },
      {
        "id": 32,
        "type": "LineType",
        "length": 310,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "id": 604,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "id": 605,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "id": 606,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "id": 607,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "id": 608,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "id": 609,
            "type": "LineElementType",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "id": 610,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "id": 611,
            "type": "LineElementType",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "id": 612,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "id": 613,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "id": 614,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "id": 615,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "id": 616,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "id": 617,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "id": 618,
            "type": "LineElementType",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "id": 619,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "id": 620,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "id": 621,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "id": 622,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "id": 623,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "id": 624,
            "type": "LineElementType",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "id": 625,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "id": 626,
            "type": "LineElementType",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "id": 627,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 129,
            "lineElementId": "0280",
            "startPosition": 182
          }
        ]
      },
      {
        "id": 33,
        "type": "LineType",
        "length": 310,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "id": 628,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "id": 629,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "id": 630,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "id": 631,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "id": 632,
            "type": "LineElementType",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "id": 633,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "id": 634,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "id": 635,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "id": 636,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "id": 637,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "id": 638,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "id": 639,
            "type": "LineElementType",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "id": 640,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "id": 641,
            "type": "LineElementType",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "id": 642,
            "type": "LineElementType",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "id": 643,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "id": 644,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "id": 645,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "id": 646,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "id": 647,
            "type": "LineElementType",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "id": 648,
            "type": "LineElementType",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "id": 649,
            "type": "LineElementType",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "id": 650,
            "type": "LineElementType",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "id": 651,
            "type": "LineElementType",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "id": 652,
            "type": "LineElementType",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "id": 653,
            "type": "LineElementType",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "id": 654,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          }
        ]
      },
      {
        "id": 34,
        "type": "LineType",
        "length": 310,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "id": 655,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "id": 656,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "id": 657,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "id": 658,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "id": 659,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "id": 660,
            "type": "LineElementType",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "id": 661,
            "type": "LineElementType",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "id": 662,
            "type": "LineElementType",
            "description": "DATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "id": 663,
            "type": "LineElementType",
            "description": "INDICATIE SOORT PRESTATIERECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "id": 664,
            "type": "LineElementType",
            "description": "INDICATIE BIJZONDERE TANDHEELKUNDE",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0410",
            "startPosition": 69
          },
          {
            "id": 665,
            "type": "LineElementType",
            "description": "SOORT BIJZONDERE TANDHEELKUNDE",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0411",
            "startPosition": 70
          },
          {
            "id": 666,
            "type": "LineElementType",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0412",
            "startPosition": 73
          },
          {
            "id": 667,
            "type": "LineElementType",
            "description": "PRESTATIECODE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0413",
            "startPosition": 76
          },
          {
            "id": 668,
            "type": "LineElementType",
            "description": "INDICATIE BOVEN/ONDER TANDHEELKUNDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0414",
            "startPosition": 82
          },
          {
            "id": 669,
            "type": "LineElementType",
            "description": "GEBITSELEMENTCODE",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0415",
            "startPosition": 83
          },
          {
            "id": 670,
            "type": "LineElementType",
            "description": "VLAKCODE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0416",
            "startPosition": 85
          },
          {
            "id": 671,
            "type": "LineElementType",
            "description": "AANDUIDING DIAGNOSECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0417",
            "startPosition": 91
          },
          {
            "id": 672,
            "type": "LineElementType",
            "description": "DIAGNOSECODE BIJZONDERE TANDHEELKUNDE",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0418",
            "startPosition": 94
          },
          {
            "id": 673,
            "type": "LineElementType",
            "description": "INDICATIE ONGEVAL (ONGEVALSGEVOLG)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0419",
            "startPosition": 98
          },
          {
            "id": 674,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 99
          },
          {
            "id": 675,
            "type": "LineElementType",
            "description": "SPECIALISME BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0421",
            "startPosition": 107
          },
          {
            "id": 676,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0422",
            "startPosition": 111
          },
          {
            "id": 677,
            "type": "LineElementType",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0423",
            "startPosition": 119
          },
          {
            "id": 678,
            "type": "LineElementType",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0424",
            "startPosition": 123
          },
          {
            "id": 679,
            "type": "LineElementType",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0425",
            "startPosition": 131
          },
          {
            "id": 680,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0426",
            "startPosition": 135
          },
          {
            "id": 681,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0427",
            "startPosition": 143
          },
          {
            "id": 682,
            "type": "LineElementType",
            "description": "BEDRAG VERMINDERING BIJZONDERE TANDHEELKUNDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0428",
            "startPosition": 144
          },
          {
            "id": 683,
            "type": "LineElementType",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0429",
            "startPosition": 152
          },
          {
            "id": 684,
            "type": "LineElementType",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0430",
            "startPosition": 156
          },
          {
            "id": 685,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0431",
            "startPosition": 164
          },
          {
            "id": 686,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0432",
            "startPosition": 165
          },
          {
            "id": 687,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0433",
            "startPosition": 185
          },
          {
            "id": 688,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 106,
            "lineElementId": "0480",
            "startPosition": 205
          }
        ]
      },
      {
        "id": 35,
        "type": "LineType",
        "length": 310,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "id": 689,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "id": 690,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "id": 691,
            "type": "LineElementType",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "id": 692,
            "type": "LineElementType",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "id": 693,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          }
        ]
      },
      {
        "id": 36,
        "type": "LineType",
        "length": 310,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "id": 694,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "id": 695,
            "type": "LineElementType",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "id": 696,
            "type": "LineElementType",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "id": 697,
            "type": "LineElementType",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "id": 698,
            "type": "LineElementType",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "id": 699,
            "type": "LineElementType",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "id": 700,
            "type": "LineElementType",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "id": 701,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "id": 702,
            "type": "LineElementType",
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
    "id": 16,
    "type": "DocumentType",
    "description": "RETOURINFORMATIE DECLARATIE MONDZORG",
    "formatSubVersion": 3,
    "formatVersion": 1,
    "name": "MZ302",
    "vektisEICode": 177,
    "lineTypes": [
      {
        "id": 93,
        "type": "LineType",
        "length": 370,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "id": 1986,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "id": 1987,
            "type": "LineElementType",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "id": 1988,
            "type": "LineElementType",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "id": 1989,
            "type": "LineElementType",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "id": 1990,
            "type": "LineElementType",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "id": 1991,
            "type": "LineElementType",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "id": 1992,
            "type": "LineElementType",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "id": 1993,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "id": 1994,
            "type": "LineElementType",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "id": 1995,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "id": 1996,
            "type": "LineElementType",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "id": 1997,
            "type": "LineElementType",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "id": 1998,
            "type": "LineElementType",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "id": 1999,
            "type": "LineElementType",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "id": 2000,
            "type": "LineElementType",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "id": 2001,
            "type": "LineElementType",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "id": 2002,
            "type": "LineElementType",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "id": 2003,
            "type": "LineElementType",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "id": 2004,
            "type": "LineElementType",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "id": 2005,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          },
          {
            "id": 2006,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER ZORGVERZEKERAAR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0181",
            "startPosition": 311
          },
          {
            "id": 2007,
            "type": "LineElementType",
            "description": "DAGTEKENING RETOURBERICHT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0182",
            "startPosition": 335
          },
          {
            "id": 2008,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0196",
            "startPosition": 343
          },
          {
            "id": 2009,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0197",
            "startPosition": 347
          },
          {
            "id": 2010,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0198",
            "startPosition": 351
          },
          {
            "id": 2011,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 16,
            "lineElementId": "0199",
            "startPosition": 355
          }
        ]
      },
      {
        "id": 94,
        "type": "LineType",
        "length": 370,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "id": 2012,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "id": 2013,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "id": 2014,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "id": 2015,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "id": 2016,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "id": 2017,
            "type": "LineElementType",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "id": 2018,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "id": 2019,
            "type": "LineElementType",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "id": 2020,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "id": 2021,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "id": 2022,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "id": 2023,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "id": 2024,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "id": 2025,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "id": 2026,
            "type": "LineElementType",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "id": 2027,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "id": 2028,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "id": 2029,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "id": 2030,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "id": 2031,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "id": 2032,
            "type": "LineElementType",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "id": 2033,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "id": 2034,
            "type": "LineElementType",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "id": 2035,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 129,
            "lineElementId": "0280",
            "startPosition": 182
          },
          {
            "id": 2036,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0296",
            "startPosition": 311
          },
          {
            "id": 2037,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0297",
            "startPosition": 315
          },
          {
            "id": 2038,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0298",
            "startPosition": 319
          },
          {
            "id": 2039,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0299",
            "startPosition": 323
          }
        ]
      },
      {
        "id": 95,
        "type": "LineType",
        "length": 370,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "id": 2040,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "id": 2041,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "id": 2042,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "id": 2043,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "id": 2044,
            "type": "LineElementType",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "id": 2045,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "id": 2046,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "id": 2047,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "id": 2048,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "id": 2049,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "id": 2050,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "id": 2051,
            "type": "LineElementType",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "id": 2052,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "id": 2053,
            "type": "LineElementType",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "id": 2054,
            "type": "LineElementType",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "id": 2055,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "id": 2056,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "id": 2057,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "id": 2058,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "id": 2059,
            "type": "LineElementType",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "id": 2060,
            "type": "LineElementType",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "id": 2061,
            "type": "LineElementType",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "id": 2062,
            "type": "LineElementType",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "id": 2063,
            "type": "LineElementType",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "id": 2064,
            "type": "LineElementType",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "id": 2065,
            "type": "LineElementType",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "id": 2066,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          },
          {
            "id": 2067,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0396",
            "startPosition": 311
          },
          {
            "id": 2068,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0397",
            "startPosition": 315
          },
          {
            "id": 2069,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0398",
            "startPosition": 319
          },
          {
            "id": 2070,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0399",
            "startPosition": 323
          }
        ]
      },
      {
        "id": 96,
        "type": "LineType",
        "length": 370,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "id": 2071,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "id": 2072,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "id": 2073,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "id": 2074,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "id": 2075,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "id": 2076,
            "type": "LineElementType",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "id": 2077,
            "type": "LineElementType",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "id": 2078,
            "type": "LineElementType",
            "description": "DATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "id": 2079,
            "type": "LineElementType",
            "description": "INDICATIE SOORT PRESTATIERECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "id": 2080,
            "type": "LineElementType",
            "description": "INDICATIE BIJZONDERE TANDHEELKUNDE",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0410",
            "startPosition": 69
          },
          {
            "id": 2081,
            "type": "LineElementType",
            "description": "SOORT BIJZONDERE TANDHEELKUNDE",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0411",
            "startPosition": 70
          },
          {
            "id": 2082,
            "type": "LineElementType",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0412",
            "startPosition": 73
          },
          {
            "id": 2083,
            "type": "LineElementType",
            "description": "PRESTATIECODE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0413",
            "startPosition": 76
          },
          {
            "id": 2084,
            "type": "LineElementType",
            "description": "INDICATIE BOVEN/ONDER TANDHEELKUNDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0414",
            "startPosition": 82
          },
          {
            "id": 2085,
            "type": "LineElementType",
            "description": "GEBITSELEMENTCODE",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0415",
            "startPosition": 83
          },
          {
            "id": 2086,
            "type": "LineElementType",
            "description": "VLAKCODE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0416",
            "startPosition": 85
          },
          {
            "id": 2087,
            "type": "LineElementType",
            "description": "AANDUIDING DIAGNOSECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0417",
            "startPosition": 91
          },
          {
            "id": 2088,
            "type": "LineElementType",
            "description": "DIAGNOSECODE BIJZONDERE TANDHEELKUNDE",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0418",
            "startPosition": 94
          },
          {
            "id": 2089,
            "type": "LineElementType",
            "description": "INDICATIE ONGEVAL (ONGEVALSGEVOLG)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0419",
            "startPosition": 98
          },
          {
            "id": 2090,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 99
          },
          {
            "id": 2091,
            "type": "LineElementType",
            "description": "SPECIALISME BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0421",
            "startPosition": 107
          },
          {
            "id": 2092,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0422",
            "startPosition": 111
          },
          {
            "id": 2093,
            "type": "LineElementType",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0423",
            "startPosition": 119
          },
          {
            "id": 2094,
            "type": "LineElementType",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0424",
            "startPosition": 123
          },
          {
            "id": 2095,
            "type": "LineElementType",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0425",
            "startPosition": 131
          },
          {
            "id": 2096,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0426",
            "startPosition": 135
          },
          {
            "id": 2097,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0427",
            "startPosition": 143
          },
          {
            "id": 2098,
            "type": "LineElementType",
            "description": "BEDRAG VERMINDERING BIJZONDERE TANDHEELKUNDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0428",
            "startPosition": 144
          },
          {
            "id": 2099,
            "type": "LineElementType",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0429",
            "startPosition": 152
          },
          {
            "id": 2100,
            "type": "LineElementType",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0430",
            "startPosition": 156
          },
          {
            "id": 2101,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0431",
            "startPosition": 164
          },
          {
            "id": 2102,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0432",
            "startPosition": 165
          },
          {
            "id": 2103,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0433",
            "startPosition": 185
          },
          {
            "id": 2104,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 106,
            "lineElementId": "0480",
            "startPosition": 205
          },
          {
            "id": 2105,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG ZORGVERZEKERAAR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0481",
            "startPosition": 311
          },
          {
            "id": 2106,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0482",
            "startPosition": 319
          },
          {
            "id": 2107,
            "type": "LineElementType",
            "description": "TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0483",
            "startPosition": 320
          },
          {
            "id": 2108,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (04)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0484",
            "startPosition": 328
          },
          {
            "id": 2109,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0496",
            "startPosition": 329
          },
          {
            "id": 2110,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0497",
            "startPosition": 333
          },
          {
            "id": 2111,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0498",
            "startPosition": 337
          },
          {
            "id": 2112,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 30,
            "lineElementId": "0499",
            "startPosition": 341
          }
        ]
      },
      {
        "id": 97,
        "type": "LineType",
        "length": 370,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "id": 2113,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "id": 2114,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "id": 2115,
            "type": "LineElementType",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "id": 2116,
            "type": "LineElementType",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "id": 2117,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          },
          {
            "id": 2118,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9896",
            "startPosition": 311
          },
          {
            "id": 2119,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9897",
            "startPosition": 315
          },
          {
            "id": 2120,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9898",
            "startPosition": 319
          },
          {
            "id": 2121,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "9899",
            "startPosition": 323
          }
        ]
      },
      {
        "id": 98,
        "type": "LineType",
        "length": 370,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "id": 2122,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "id": 2123,
            "type": "LineElementType",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "id": 2124,
            "type": "LineElementType",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "id": 2125,
            "type": "LineElementType",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "id": 2126,
            "type": "LineElementType",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "id": 2127,
            "type": "LineElementType",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "id": 2128,
            "type": "LineElementType",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "id": 2129,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "id": 2130,
            "type": "LineElementType",
            "description": "TOTAAL TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9909",
            "startPosition": 46
          },
          {
            "id": 2131,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9910",
            "startPosition": 57
          },
          {
            "id": 2132,
            "type": "LineElementType",
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
    "id": 21,
    "type": "DocumentType",
    "description": "DECLARATIE ZORG OVERIGE SECTOREN",
    "formatSubVersion": 0,
    "formatVersion": 1,
    "name": "OS301",
    "vektisEICode": 185,
    "lineTypes": [
      {
        "id": 123,
        "type": "LineType",
        "length": 310,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "id": 2657,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "id": 2658,
            "type": "LineElementType",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "id": 2659,
            "type": "LineElementType",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "id": 2660,
            "type": "LineElementType",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "id": 2661,
            "type": "LineElementType",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "id": 2662,
            "type": "LineElementType",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "id": 2663,
            "type": "LineElementType",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "id": 2664,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "id": 2665,
            "type": "LineElementType",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "id": 2666,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "id": 2667,
            "type": "LineElementType",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "id": 2668,
            "type": "LineElementType",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "id": 2669,
            "type": "LineElementType",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "id": 2670,
            "type": "LineElementType",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "id": 2671,
            "type": "LineElementType",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "id": 2672,
            "type": "LineElementType",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "id": 2673,
            "type": "LineElementType",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "id": 2674,
            "type": "LineElementType",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "id": 2675,
            "type": "LineElementType",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "id": 2676,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          }
        ]
      },
      {
        "id": 124,
        "type": "LineType",
        "length": 310,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "id": 2677,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "id": 2678,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "id": 2679,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "id": 2680,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "id": 2681,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "id": 2682,
            "type": "LineElementType",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "id": 2683,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "id": 2684,
            "type": "LineElementType",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "id": 2685,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "id": 2686,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "id": 2687,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "id": 2688,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "id": 2689,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "id": 2690,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "id": 2691,
            "type": "LineElementType",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "id": 2692,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "id": 2693,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "id": 2694,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "id": 2695,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "id": 2696,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "id": 2697,
            "type": "LineElementType",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "id": 2698,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "id": 2699,
            "type": "LineElementType",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "id": 2700,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 129,
            "lineElementId": "0280",
            "startPosition": 182
          }
        ]
      },
      {
        "id": 125,
        "type": "LineType",
        "length": 310,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "id": 2701,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "id": 2702,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "id": 2703,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "id": 2704,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "id": 2705,
            "type": "LineElementType",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "id": 2706,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "id": 2707,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "id": 2708,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "id": 2709,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "id": 2710,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "id": 2711,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "id": 2712,
            "type": "LineElementType",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "id": 2713,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "id": 2714,
            "type": "LineElementType",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "id": 2715,
            "type": "LineElementType",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "id": 2716,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "id": 2717,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "id": 2718,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "id": 2719,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "id": 2720,
            "type": "LineElementType",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "id": 2721,
            "type": "LineElementType",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "id": 2722,
            "type": "LineElementType",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "id": 2723,
            "type": "LineElementType",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "id": 2724,
            "type": "LineElementType",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "id": 2725,
            "type": "LineElementType",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "id": 2726,
            "type": "LineElementType",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "id": 2727,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          }
        ]
      },
      {
        "id": 126,
        "type": "LineType",
        "length": 310,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "id": 2728,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "id": 2729,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "id": 2730,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "id": 2731,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "id": 2732,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "id": 2733,
            "type": "LineElementType",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "id": 2734,
            "type": "LineElementType",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "id": 2735,
            "type": "LineElementType",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "id": 2736,
            "type": "LineElementType",
            "description": "EINDDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "id": 2737,
            "type": "LineElementType",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0410",
            "startPosition": 75
          },
          {
            "id": 2738,
            "type": "LineElementType",
            "description": "PRESTATIECODE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0411",
            "startPosition": 78
          },
          {
            "id": 2739,
            "type": "LineElementType",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0412",
            "startPosition": 83
          },
          {
            "id": 2740,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0413",
            "startPosition": 87
          },
          {
            "id": 2741,
            "type": "LineElementType",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0414",
            "startPosition": 95
          },
          {
            "id": 2742,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0415",
            "startPosition": 103
          },
          {
            "id": 2743,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0416",
            "startPosition": 111
          },
          {
            "id": 2744,
            "type": "LineElementType",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0417",
            "startPosition": 112
          },
          {
            "id": 2745,
            "type": "LineElementType",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0418",
            "startPosition": 116
          },
          {
            "id": 2746,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0419",
            "startPosition": 124
          },
          {
            "id": 2747,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0420",
            "startPosition": 125
          },
          {
            "id": 2748,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0421",
            "startPosition": 145
          },
          {
            "id": 2749,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 146,
            "lineElementId": "0480",
            "startPosition": 165
          }
        ]
      },
      {
        "id": 127,
        "type": "LineType",
        "length": 310,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "id": 2750,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "id": 2751,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "id": 2752,
            "type": "LineElementType",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "id": 2753,
            "type": "LineElementType",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "id": 2754,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          }
        ]
      },
      {
        "id": 128,
        "type": "LineType",
        "length": 310,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "id": 2755,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "id": 2756,
            "type": "LineElementType",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "id": 2757,
            "type": "LineElementType",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "id": 2758,
            "type": "LineElementType",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "id": 2759,
            "type": "LineElementType",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "id": 2760,
            "type": "LineElementType",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "id": 2761,
            "type": "LineElementType",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "id": 2762,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "id": 2763,
            "type": "LineElementType",
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
    "id": 22,
    "type": "DocumentType",
    "description": "RETOURINFORMATIE DECLARATIE ZORG OVERIGE SECTOREN",
    "formatSubVersion": 0,
    "formatVersion": 1,
    "name": "OS302",
    "vektisEICode": 186,
    "lineTypes": [
      {
        "id": 129,
        "type": "LineType",
        "length": 370,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "id": 2764,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "id": 2765,
            "type": "LineElementType",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "id": 2766,
            "type": "LineElementType",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "id": 2767,
            "type": "LineElementType",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "id": 2768,
            "type": "LineElementType",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "id": 2769,
            "type": "LineElementType",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "id": 2770,
            "type": "LineElementType",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "id": 2771,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "id": 2772,
            "type": "LineElementType",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "id": 2773,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "id": 2774,
            "type": "LineElementType",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "id": 2775,
            "type": "LineElementType",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "id": 2776,
            "type": "LineElementType",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "id": 2777,
            "type": "LineElementType",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "id": 2778,
            "type": "LineElementType",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "id": 2779,
            "type": "LineElementType",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "id": 2780,
            "type": "LineElementType",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "id": 2781,
            "type": "LineElementType",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "id": 2782,
            "type": "LineElementType",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "id": 2783,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          },
          {
            "id": 2784,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER ZORGVERZEKERAAR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0181",
            "startPosition": 311
          },
          {
            "id": 2785,
            "type": "LineElementType",
            "description": "DAGTEKENING RETOURBERICHT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0182",
            "startPosition": 335
          },
          {
            "id": 2786,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0196",
            "startPosition": 343
          },
          {
            "id": 2787,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0197",
            "startPosition": 347
          },
          {
            "id": 2788,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0198",
            "startPosition": 351
          },
          {
            "id": 2789,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 16,
            "lineElementId": "0199",
            "startPosition": 355
          }
        ]
      },
      {
        "id": 130,
        "type": "LineType",
        "length": 370,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "id": 2790,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "id": 2791,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "id": 2792,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "id": 2793,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "id": 2794,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "id": 2795,
            "type": "LineElementType",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "id": 2796,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "id": 2797,
            "type": "LineElementType",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "id": 2798,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "id": 2799,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "id": 2800,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "id": 2801,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "id": 2802,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "id": 2803,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "id": 2804,
            "type": "LineElementType",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "id": 2805,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "id": 2806,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "id": 2807,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "id": 2808,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "id": 2809,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "id": 2810,
            "type": "LineElementType",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "id": 2811,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "id": 2812,
            "type": "LineElementType",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "id": 2813,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 129,
            "lineElementId": "0280",
            "startPosition": 182
          },
          {
            "id": 2814,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0296",
            "startPosition": 311
          },
          {
            "id": 2815,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0297",
            "startPosition": 315
          },
          {
            "id": 2816,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0298",
            "startPosition": 319
          },
          {
            "id": 2817,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0299",
            "startPosition": 323
          }
        ]
      },
      {
        "id": 131,
        "type": "LineType",
        "length": 370,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "id": 2818,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "id": 2819,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "id": 2820,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "id": 2821,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "id": 2822,
            "type": "LineElementType",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "id": 2823,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "id": 2824,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "id": 2825,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "id": 2826,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "id": 2827,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "id": 2828,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "id": 2829,
            "type": "LineElementType",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "id": 2830,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "id": 2831,
            "type": "LineElementType",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "id": 2832,
            "type": "LineElementType",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "id": 2833,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "id": 2834,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "id": 2835,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "id": 2836,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "id": 2837,
            "type": "LineElementType",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "id": 2838,
            "type": "LineElementType",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "id": 2839,
            "type": "LineElementType",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "id": 2840,
            "type": "LineElementType",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "id": 2841,
            "type": "LineElementType",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "id": 2842,
            "type": "LineElementType",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "id": 2843,
            "type": "LineElementType",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "id": 2844,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          },
          {
            "id": 2845,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0396",
            "startPosition": 311
          },
          {
            "id": 2846,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0397",
            "startPosition": 315
          },
          {
            "id": 2847,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0398",
            "startPosition": 319
          },
          {
            "id": 2848,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0399",
            "startPosition": 323
          }
        ]
      },
      {
        "id": 132,
        "type": "LineType",
        "length": 370,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "id": 2849,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "id": 2850,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "id": 2851,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "id": 2852,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "id": 2853,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "id": 2854,
            "type": "LineElementType",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "id": 2855,
            "type": "LineElementType",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "id": 2856,
            "type": "LineElementType",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "id": 2857,
            "type": "LineElementType",
            "description": "EINDDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "id": 2858,
            "type": "LineElementType",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0410",
            "startPosition": 75
          },
          {
            "id": 2859,
            "type": "LineElementType",
            "description": "PRESTATIECODE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0411",
            "startPosition": 78
          },
          {
            "id": 2860,
            "type": "LineElementType",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0412",
            "startPosition": 83
          },
          {
            "id": 2861,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0413",
            "startPosition": 87
          },
          {
            "id": 2862,
            "type": "LineElementType",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0414",
            "startPosition": 95
          },
          {
            "id": 2863,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0415",
            "startPosition": 103
          },
          {
            "id": 2864,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0416",
            "startPosition": 111
          },
          {
            "id": 2865,
            "type": "LineElementType",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0417",
            "startPosition": 112
          },
          {
            "id": 2866,
            "type": "LineElementType",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0418",
            "startPosition": 116
          },
          {
            "id": 2867,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0419",
            "startPosition": 124
          },
          {
            "id": 2868,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0420",
            "startPosition": 125
          },
          {
            "id": 2869,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0421",
            "startPosition": 145
          },
          {
            "id": 2870,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 146,
            "lineElementId": "0480",
            "startPosition": 165
          },
          {
            "id": 2871,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG ZORGVERZEKERAAR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0481",
            "startPosition": 311
          },
          {
            "id": 2872,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0482",
            "startPosition": 319
          },
          {
            "id": 2873,
            "type": "LineElementType",
            "description": "TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0483",
            "startPosition": 320
          },
          {
            "id": 2874,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (04)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0484",
            "startPosition": 328
          },
          {
            "id": 2875,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0496",
            "startPosition": 329
          },
          {
            "id": 2876,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0497",
            "startPosition": 333
          },
          {
            "id": 2877,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0498",
            "startPosition": 337
          },
          {
            "id": 2878,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 30,
            "lineElementId": "0499",
            "startPosition": 341
          }
        ]
      },
      {
        "id": 133,
        "type": "LineType",
        "length": 370,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "id": 2879,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "id": 2880,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "id": 2881,
            "type": "LineElementType",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "id": 2882,
            "type": "LineElementType",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "id": 2883,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          },
          {
            "id": 2884,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9896",
            "startPosition": 311
          },
          {
            "id": 2885,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9897",
            "startPosition": 315
          },
          {
            "id": 2886,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9898",
            "startPosition": 319
          },
          {
            "id": 2887,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "9899",
            "startPosition": 323
          }
        ]
      },
      {
        "id": 134,
        "type": "LineType",
        "length": 370,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "id": 2888,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "id": 2889,
            "type": "LineElementType",
            "description": "AANTAL VERZEKERDENRECORDS RETOUR",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "id": 2890,
            "type": "LineElementType",
            "description": "AANTAL DEBITEURRECORDS RETOUR",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "id": 2891,
            "type": "LineElementType",
            "description": "AANTAL PRESTATIERECORDS RETOUR",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "id": 2892,
            "type": "LineElementType",
            "description": "AANTAL COMMENTAARRECORDS RETOUR",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "id": 2893,
            "type": "LineElementType",
            "description": "TOTAAL AANTAL DETAILRECORDS RETOUR",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "id": 2894,
            "type": "LineElementType",
            "description": "TOTAAL INGEDIEND DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "id": 2895,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "id": 2896,
            "type": "LineElementType",
            "description": "TOTAAL TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9909",
            "startPosition": 46
          },
          {
            "id": 2897,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9910",
            "startPosition": 57
          },
          {
            "id": 2898,
            "type": "LineElementType",
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
    "id": 9,
    "type": "DocumentType",
    "description": "DECLARATIE PARAMEDISCHE HULP",
    "formatSubVersion": 2,
    "formatVersion": 3,
    "name": "PM304",
    "vektisEICode": 107,
    "lineTypes": [
      {
        "id": 50,
        "type": "LineType",
        "length": 310,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "id": 965,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "id": 966,
            "type": "LineElementType",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "id": 967,
            "type": "LineElementType",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "id": 968,
            "type": "LineElementType",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "id": 969,
            "type": "LineElementType",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "id": 970,
            "type": "LineElementType",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "id": 971,
            "type": "LineElementType",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "id": 972,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "id": 973,
            "type": "LineElementType",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "id": 974,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "id": 975,
            "type": "LineElementType",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "id": 976,
            "type": "LineElementType",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "id": 977,
            "type": "LineElementType",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "id": 978,
            "type": "LineElementType",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "id": 979,
            "type": "LineElementType",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "id": 980,
            "type": "LineElementType",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "id": 981,
            "type": "LineElementType",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "id": 982,
            "type": "LineElementType",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "id": 983,
            "type": "LineElementType",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "id": 984,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          }
        ]
      },
      {
        "id": 51,
        "type": "LineType",
        "length": 310,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "id": 985,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "id": 986,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "id": 987,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "id": 988,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "id": 989,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "id": 990,
            "type": "LineElementType",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "id": 991,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "id": 992,
            "type": "LineElementType",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "id": 993,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "id": 994,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "id": 995,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "id": 996,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "id": 997,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "id": 998,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "id": 999,
            "type": "LineElementType",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "id": 1000,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "id": 1001,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "id": 1002,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "id": 1003,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "id": 1004,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "id": 1005,
            "type": "LineElementType",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "id": 1006,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "id": 1007,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 130,
            "lineElementId": "0280",
            "startPosition": 181
          }
        ]
      },
      {
        "id": 52,
        "type": "LineType",
        "length": 310,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "id": 1008,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "id": 1009,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "id": 1010,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "id": 1011,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "id": 1012,
            "type": "LineElementType",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "id": 1013,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "id": 1014,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "id": 1015,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "id": 1016,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "id": 1017,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "id": 1018,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "id": 1019,
            "type": "LineElementType",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "id": 1020,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "id": 1021,
            "type": "LineElementType",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "id": 1022,
            "type": "LineElementType",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "id": 1023,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "id": 1024,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "id": 1025,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "id": 1026,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "id": 1027,
            "type": "LineElementType",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "id": 1028,
            "type": "LineElementType",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "id": 1029,
            "type": "LineElementType",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "id": 1030,
            "type": "LineElementType",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "id": 1031,
            "type": "LineElementType",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "id": 1032,
            "type": "LineElementType",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "id": 1033,
            "type": "LineElementType",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "id": 1034,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          }
        ]
      },
      {
        "id": 53,
        "type": "LineType",
        "length": 310,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "id": 1035,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "id": 1036,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "id": 1037,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "id": 1038,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "id": 1039,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "id": 1040,
            "type": "LineElementType",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "id": 1041,
            "type": "LineElementType",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "id": 1042,
            "type": "LineElementType",
            "description": "DATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "id": 1043,
            "type": "LineElementType",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "id": 1044,
            "type": "LineElementType",
            "description": "PRESTATIECODE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0410",
            "startPosition": 70
          },
          {
            "id": 1045,
            "type": "LineElementType",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0411",
            "startPosition": 76
          },
          {
            "id": 1046,
            "type": "LineElementType",
            "description": "INDICATIE ONGEVAL (ONGEVALSGEVOLG)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0412",
            "startPosition": 80
          },
          {
            "id": 1047,
            "type": "LineElementType",
            "description": "AANDUIDING DIAGNOSECODELIJST (01)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0413",
            "startPosition": 81
          },
          {
            "id": 1048,
            "type": "LineElementType",
            "description": "VERWIJSDIAGNOSECODE PARAMEDISCHE HULP (01)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0414",
            "startPosition": 84
          },
          {
            "id": 1049,
            "type": "LineElementType",
            "description": "AANDUIDING DIAGNOSECODELIJST (02)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0415",
            "startPosition": 92
          },
          {
            "id": 1050,
            "type": "LineElementType",
            "description": "VERWIJSDIAGNOSECODE PARAMEDISCHE HULP (02)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0416",
            "startPosition": 95
          },
          {
            "id": 1051,
            "type": "LineElementType",
            "description": "AANDUIDING DIAGNOSECODELIJST (03)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0417",
            "startPosition": 103
          },
          {
            "id": 1052,
            "type": "LineElementType",
            "description": "PARAMEDISCHE DIAGNOSECODE (01)",
            "fieldType": "AN",
            "length": 8,
            "lineElementId": "0418",
            "startPosition": 106
          },
          {
            "id": 1053,
            "type": "LineElementType",
            "description": "AANDUIDING DIAGNOSECODELIJST (04)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0419",
            "startPosition": 114
          },
          {
            "id": 1054,
            "type": "LineElementType",
            "description": "PARAMEDISCHE DIAGNOSECODE (02)",
            "fieldType": "AN",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 117
          },
          {
            "id": 1055,
            "type": "LineElementType",
            "description": "CODE SOORT INDICATIE PARAMEDISCHE HULP",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0421",
            "startPosition": 125
          },
          {
            "id": 1056,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0422",
            "startPosition": 128
          },
          {
            "id": 1057,
            "type": "LineElementType",
            "description": "SPECIALISME BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0423",
            "startPosition": 136
          },
          {
            "id": 1058,
            "type": "LineElementType",
            "description": "VERWIJSDATUM",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0424",
            "startPosition": 140
          },
          {
            "id": 1059,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0425",
            "startPosition": 148
          },
          {
            "id": 1060,
            "type": "LineElementType",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0426",
            "startPosition": 156
          },
          {
            "id": 1061,
            "type": "LineElementType",
            "description": "REDEN EINDE ZORG",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0427",
            "startPosition": 160
          },
          {
            "id": 1062,
            "type": "LineElementType",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0428",
            "startPosition": 162
          },
          {
            "id": 1063,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0429",
            "startPosition": 170
          },
          {
            "id": 1064,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0430",
            "startPosition": 178
          },
          {
            "id": 1065,
            "type": "LineElementType",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0431",
            "startPosition": 179
          },
          {
            "id": 1066,
            "type": "LineElementType",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0432",
            "startPosition": 183
          },
          {
            "id": 1067,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0433",
            "startPosition": 191
          },
          {
            "id": 1068,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0434",
            "startPosition": 192
          },
          {
            "id": 1069,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0435",
            "startPosition": 212
          },
          {
            "id": 1070,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 79,
            "lineElementId": "0480",
            "startPosition": 232
          }
        ]
      },
      {
        "id": 54,
        "type": "LineType",
        "length": 310,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "id": 1071,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "id": 1072,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "id": 1073,
            "type": "LineElementType",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "id": 1074,
            "type": "LineElementType",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "id": 1075,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          }
        ]
      },
      {
        "id": 55,
        "type": "LineType",
        "length": 310,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "id": 1076,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "id": 1077,
            "type": "LineElementType",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "id": 1078,
            "type": "LineElementType",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "id": 1079,
            "type": "LineElementType",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "id": 1080,
            "type": "LineElementType",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "id": 1081,
            "type": "LineElementType",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "id": 1082,
            "type": "LineElementType",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "id": 1083,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "id": 1084,
            "type": "LineElementType",
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
    "id": 17,
    "type": "DocumentType",
    "description": "RETOURINFORMATIE DECLARATIE PARAMEDISCHE HULP",
    "formatSubVersion": 2,
    "formatVersion": 3,
    "name": "PM305",
    "vektisEICode": 108,
    "lineTypes": [
      {
        "id": 99,
        "type": "LineType",
        "length": 370,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "id": 2133,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "id": 2134,
            "type": "LineElementType",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "id": 2135,
            "type": "LineElementType",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "id": 2136,
            "type": "LineElementType",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "id": 2137,
            "type": "LineElementType",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "id": 2138,
            "type": "LineElementType",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "id": 2139,
            "type": "LineElementType",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "id": 2140,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "id": 2141,
            "type": "LineElementType",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "id": 2142,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "id": 2143,
            "type": "LineElementType",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "id": 2144,
            "type": "LineElementType",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "id": 2145,
            "type": "LineElementType",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "id": 2146,
            "type": "LineElementType",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "id": 2147,
            "type": "LineElementType",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "id": 2148,
            "type": "LineElementType",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "id": 2149,
            "type": "LineElementType",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "id": 2150,
            "type": "LineElementType",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "id": 2151,
            "type": "LineElementType",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "id": 2152,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          },
          {
            "id": 2153,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER ZORGVERZEKERAAR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0181",
            "startPosition": 311
          },
          {
            "id": 2154,
            "type": "LineElementType",
            "description": "DAGTEKENING RETOURBERICHT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0182",
            "startPosition": 335
          },
          {
            "id": 2155,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0196",
            "startPosition": 343
          },
          {
            "id": 2156,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0197",
            "startPosition": 347
          },
          {
            "id": 2157,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0198",
            "startPosition": 351
          },
          {
            "id": 2158,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 16,
            "lineElementId": "0199",
            "startPosition": 355
          }
        ]
      },
      {
        "id": 100,
        "type": "LineType",
        "length": 370,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "id": 2159,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "id": 2160,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "id": 2161,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "id": 2162,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "id": 2163,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "id": 2164,
            "type": "LineElementType",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "id": 2165,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "id": 2166,
            "type": "LineElementType",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "id": 2167,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "id": 2168,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "id": 2169,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "id": 2170,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "id": 2171,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "id": 2172,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "id": 2173,
            "type": "LineElementType",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "id": 2174,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "id": 2175,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "id": 2176,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "id": 2177,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "id": 2178,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "id": 2179,
            "type": "LineElementType",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "id": 2180,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "id": 2181,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 130,
            "lineElementId": "0280",
            "startPosition": 181
          },
          {
            "id": 2182,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0296",
            "startPosition": 311
          },
          {
            "id": 2183,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0297",
            "startPosition": 315
          },
          {
            "id": 2184,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0298",
            "startPosition": 319
          },
          {
            "id": 2185,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0299",
            "startPosition": 323
          }
        ]
      },
      {
        "id": 101,
        "type": "LineType",
        "length": 370,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "id": 2186,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "id": 2187,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "id": 2188,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "id": 2189,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "id": 2190,
            "type": "LineElementType",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "id": 2191,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "id": 2192,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "id": 2193,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "id": 2194,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "id": 2195,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "id": 2196,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "id": 2197,
            "type": "LineElementType",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "id": 2198,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "id": 2199,
            "type": "LineElementType",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "id": 2200,
            "type": "LineElementType",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "id": 2201,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "id": 2202,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "id": 2203,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "id": 2204,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "id": 2205,
            "type": "LineElementType",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "id": 2206,
            "type": "LineElementType",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "id": 2207,
            "type": "LineElementType",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "id": 2208,
            "type": "LineElementType",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "id": 2209,
            "type": "LineElementType",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "id": 2210,
            "type": "LineElementType",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "id": 2211,
            "type": "LineElementType",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "id": 2212,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          },
          {
            "id": 2213,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 311
          },
          {
            "id": 2214,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0396",
            "startPosition": 324
          },
          {
            "id": 2215,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0397",
            "startPosition": 328
          },
          {
            "id": 2216,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0398",
            "startPosition": 332
          },
          {
            "id": 2217,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0399",
            "startPosition": 336
          }
        ]
      },
      {
        "id": 102,
        "type": "LineType",
        "length": 370,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "id": 2218,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "id": 2219,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "id": 2220,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "id": 2221,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "id": 2222,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "id": 2223,
            "type": "LineElementType",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "id": 2224,
            "type": "LineElementType",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "id": 2225,
            "type": "LineElementType",
            "description": "DATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "id": 2226,
            "type": "LineElementType",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0409",
            "startPosition": 67
          },
          {
            "id": 2227,
            "type": "LineElementType",
            "description": "PRESTATIECODE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0410",
            "startPosition": 70
          },
          {
            "id": 2228,
            "type": "LineElementType",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0411",
            "startPosition": 76
          },
          {
            "id": 2229,
            "type": "LineElementType",
            "description": "INDICATIE ONGEVAL (ONGEVALSGEVOLG)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0412",
            "startPosition": 80
          },
          {
            "id": 2230,
            "type": "LineElementType",
            "description": "AANDUIDING DIAGNOSECODELIJST (01)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0413",
            "startPosition": 81
          },
          {
            "id": 2231,
            "type": "LineElementType",
            "description": "VERWIJSDIAGNOSECODE PARAMEDISCHE HULP (01)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0414",
            "startPosition": 84
          },
          {
            "id": 2232,
            "type": "LineElementType",
            "description": "AANDUIDING DIAGNOSECODELIJST (02)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0415",
            "startPosition": 92
          },
          {
            "id": 2233,
            "type": "LineElementType",
            "description": "VERWIJSDIAGNOSECODE PARAMEDISCHE HULP (02)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0416",
            "startPosition": 95
          },
          {
            "id": 2234,
            "type": "LineElementType",
            "description": "AANDUIDING DIAGNOSECODELIJST (03)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0417",
            "startPosition": 103
          },
          {
            "id": 2235,
            "type": "LineElementType",
            "description": "PARAMEDISCHE DIAGNOSECODE (01)",
            "fieldType": "AN",
            "length": 8,
            "lineElementId": "0418",
            "startPosition": 106
          },
          {
            "id": 2236,
            "type": "LineElementType",
            "description": "AANDUIDING DIAGNOSECODELIJST (04)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0419",
            "startPosition": 114
          },
          {
            "id": 2237,
            "type": "LineElementType",
            "description": "PARAMEDISCHE DIAGNOSECODE (02)",
            "fieldType": "AN",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 117
          },
          {
            "id": 2238,
            "type": "LineElementType",
            "description": "CODE SOORT INDICATIE PARAMEDISCHE HULP",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0421",
            "startPosition": 125
          },
          {
            "id": 2239,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0422",
            "startPosition": 128
          },
          {
            "id": 2240,
            "type": "LineElementType",
            "description": "SPECIALISME BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0423",
            "startPosition": 136
          },
          {
            "id": 2241,
            "type": "LineElementType",
            "description": "VERWIJSDATUM",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0424",
            "startPosition": 140
          },
          {
            "id": 2242,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0425",
            "startPosition": 148
          },
          {
            "id": 2243,
            "type": "LineElementType",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0426",
            "startPosition": 156
          },
          {
            "id": 2244,
            "type": "LineElementType",
            "description": "REDEN EINDE ZORG",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0427",
            "startPosition": 160
          },
          {
            "id": 2245,
            "type": "LineElementType",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0428",
            "startPosition": 162
          },
          {
            "id": 2246,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0429",
            "startPosition": 170
          },
          {
            "id": 2247,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0430",
            "startPosition": 178
          },
          {
            "id": 2248,
            "type": "LineElementType",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0431",
            "startPosition": 179
          },
          {
            "id": 2249,
            "type": "LineElementType",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0432",
            "startPosition": 183
          },
          {
            "id": 2250,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0433",
            "startPosition": 191
          },
          {
            "id": 2251,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0434",
            "startPosition": 192
          },
          {
            "id": 2252,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0435",
            "startPosition": 212
          },
          {
            "id": 2253,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 79,
            "lineElementId": "0480",
            "startPosition": 232
          },
          {
            "id": 2254,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG ZORGVERZEKERAAR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0481",
            "startPosition": 311
          },
          {
            "id": 2255,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0482",
            "startPosition": 319
          },
          {
            "id": 2256,
            "type": "LineElementType",
            "description": "TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0483",
            "startPosition": 320
          },
          {
            "id": 2257,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (04)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0484",
            "startPosition": 328
          },
          {
            "id": 2258,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0496",
            "startPosition": 329
          },
          {
            "id": 2259,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0497",
            "startPosition": 333
          },
          {
            "id": 2260,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0498",
            "startPosition": 337
          },
          {
            "id": 2261,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 30,
            "lineElementId": "0499",
            "startPosition": 341
          }
        ]
      },
      {
        "id": 103,
        "type": "LineType",
        "length": 370,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "id": 2262,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "id": 2263,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "id": 2264,
            "type": "LineElementType",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "id": 2265,
            "type": "LineElementType",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "id": 2266,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          },
          {
            "id": 2267,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9896",
            "startPosition": 311
          },
          {
            "id": 2268,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9897",
            "startPosition": 315
          },
          {
            "id": 2269,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9898",
            "startPosition": 319
          },
          {
            "id": 2270,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "9899",
            "startPosition": 323
          }
        ]
      },
      {
        "id": 104,
        "type": "LineType",
        "length": 370,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "id": 2271,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "id": 2272,
            "type": "LineElementType",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "id": 2273,
            "type": "LineElementType",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "id": 2274,
            "type": "LineElementType",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "id": 2275,
            "type": "LineElementType",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "id": 2276,
            "type": "LineElementType",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "id": 2277,
            "type": "LineElementType",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "id": 2278,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "id": 2279,
            "type": "LineElementType",
            "description": "TOTAAL TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9909",
            "startPosition": 46
          },
          {
            "id": 2280,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9910",
            "startPosition": 57
          },
          {
            "id": 2281,
            "type": "LineElementType",
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
    "id": 7,
    "type": "DocumentType",
    "description": "DECLARATIE VERLOSKUNDIGE HULP",
    "formatSubVersion": 2,
    "formatVersion": 2,
    "name": "VK301",
    "vektisEICode": 141,
    "lineTypes": [
      {
        "id": 37,
        "type": "LineType",
        "length": 310,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "id": 703,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "id": 704,
            "type": "LineElementType",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "id": 705,
            "type": "LineElementType",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "id": 706,
            "type": "LineElementType",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "id": 707,
            "type": "LineElementType",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "id": 708,
            "type": "LineElementType",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "id": 709,
            "type": "LineElementType",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "id": 710,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "id": 711,
            "type": "LineElementType",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "id": 712,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "id": 713,
            "type": "LineElementType",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "id": 714,
            "type": "LineElementType",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "id": 715,
            "type": "LineElementType",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "id": 716,
            "type": "LineElementType",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "id": 717,
            "type": "LineElementType",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "id": 718,
            "type": "LineElementType",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "id": 719,
            "type": "LineElementType",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "id": 720,
            "type": "LineElementType",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "id": 721,
            "type": "LineElementType",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "id": 722,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          }
        ]
      },
      {
        "id": 38,
        "type": "LineType",
        "length": 310,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "id": 723,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "id": 724,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "id": 725,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "id": 726,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "id": 727,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "id": 728,
            "type": "LineElementType",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "id": 729,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "id": 730,
            "type": "LineElementType",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "id": 731,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "id": 732,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "id": 733,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "id": 734,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "id": 735,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "id": 736,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "id": 737,
            "type": "LineElementType",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "id": 738,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "id": 739,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "id": 740,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "id": 741,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "id": 742,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "id": 743,
            "type": "LineElementType",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "id": 744,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "id": 745,
            "type": "LineElementType",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "id": 746,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 129,
            "lineElementId": "0280",
            "startPosition": 182
          }
        ]
      },
      {
        "id": 39,
        "type": "LineType",
        "length": 310,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "id": 747,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "id": 748,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "id": 749,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "id": 750,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "id": 751,
            "type": "LineElementType",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "id": 752,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "id": 753,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "id": 754,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "id": 755,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "id": 756,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "id": 757,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "id": 758,
            "type": "LineElementType",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "id": 759,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "id": 760,
            "type": "LineElementType",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "id": 761,
            "type": "LineElementType",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "id": 762,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "id": 763,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "id": 764,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "id": 765,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "id": 766,
            "type": "LineElementType",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "id": 767,
            "type": "LineElementType",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "id": 768,
            "type": "LineElementType",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "id": 769,
            "type": "LineElementType",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "id": 770,
            "type": "LineElementType",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "id": 771,
            "type": "LineElementType",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "id": 772,
            "type": "LineElementType",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "id": 773,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          }
        ]
      },
      {
        "id": 40,
        "type": "LineType",
        "length": 310,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "id": 774,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "id": 775,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "id": 776,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "id": 777,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "id": 778,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "id": 779,
            "type": "LineElementType",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "id": 780,
            "type": "LineElementType",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "id": 781,
            "type": "LineElementType",
            "description": "INDICATIE MEDIUM RISK VERLOSKUNDIGE ZORG",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "id": 782,
            "type": "LineElementType",
            "description": "INDICATIE OVERNAME VERLOSKUNDIGE ZORG",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0409",
            "startPosition": 60
          },
          {
            "id": 783,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE VORIGE ZORGVERLENER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0410",
            "startPosition": 61
          },
          {
            "id": 784,
            "type": "LineElementType",
            "description": "ZORGVERLENERSSPECIFICATIE VORIGE ZORGVERLENER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0411",
            "startPosition": 69
          },
          {
            "id": 785,
            "type": "LineElementType",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0412",
            "startPosition": 73
          },
          {
            "id": 786,
            "type": "LineElementType",
            "description": "EINDDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0413",
            "startPosition": 81
          },
          {
            "id": 787,
            "type": "LineElementType",
            "description": "DATUM PARTUS (BEVALLINGSDATUM)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0414",
            "startPosition": 89
          },
          {
            "id": 788,
            "type": "LineElementType",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0415",
            "startPosition": 97
          },
          {
            "id": 789,
            "type": "LineElementType",
            "description": "PRESTATIECODE",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0416",
            "startPosition": 100
          },
          {
            "id": 790,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0417",
            "startPosition": 104
          },
          {
            "id": 791,
            "type": "LineElementType",
            "description": "SPECIALISME BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0418",
            "startPosition": 112
          },
          {
            "id": 792,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0419",
            "startPosition": 116
          },
          {
            "id": 793,
            "type": "LineElementType",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0420",
            "startPosition": 124
          },
          {
            "id": 794,
            "type": "LineElementType",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0421",
            "startPosition": 128
          },
          {
            "id": 795,
            "type": "LineElementType",
            "description": "TIJDSEENHEID ZORGPERIODE",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0422",
            "startPosition": 132
          },
          {
            "id": 796,
            "type": "LineElementType",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0423",
            "startPosition": 134
          },
          {
            "id": 797,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0424",
            "startPosition": 142
          },
          {
            "id": 798,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0425",
            "startPosition": 150
          },
          {
            "id": 799,
            "type": "LineElementType",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0426",
            "startPosition": 151
          },
          {
            "id": 800,
            "type": "LineElementType",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0427",
            "startPosition": 155
          },
          {
            "id": 801,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0428",
            "startPosition": 163
          },
          {
            "id": 802,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0429",
            "startPosition": 164
          },
          {
            "id": 803,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0430",
            "startPosition": 184
          },
          {
            "id": 804,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 107,
            "lineElementId": "0480",
            "startPosition": 204
          }
        ]
      },
      {
        "id": 41,
        "type": "LineType",
        "length": 310,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "id": 805,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "id": 806,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "id": 807,
            "type": "LineElementType",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "id": 808,
            "type": "LineElementType",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "id": 809,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          }
        ]
      },
      {
        "id": 42,
        "type": "LineType",
        "length": 310,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "id": 810,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "id": 811,
            "type": "LineElementType",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "id": 812,
            "type": "LineElementType",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "id": 813,
            "type": "LineElementType",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "id": 814,
            "type": "LineElementType",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "id": 815,
            "type": "LineElementType",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "id": 816,
            "type": "LineElementType",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "id": 817,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "id": 818,
            "type": "LineElementType",
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
    "id": 18,
    "type": "DocumentType",
    "description": "RETOURINFORMATIE DECLARATIE VERLOSKUNDIGE HULP",
    "formatSubVersion": 2,
    "formatVersion": 2,
    "name": "VK302",
    "vektisEICode": 142,
    "lineTypes": [
      {
        "id": 105,
        "type": "LineType",
        "length": 370,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "id": 2282,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "id": 2283,
            "type": "LineElementType",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "id": 2284,
            "type": "LineElementType",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "id": 2285,
            "type": "LineElementType",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "id": 2286,
            "type": "LineElementType",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "id": 2287,
            "type": "LineElementType",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "id": 2288,
            "type": "LineElementType",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "id": 2289,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "id": 2290,
            "type": "LineElementType",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "id": 2291,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "id": 2292,
            "type": "LineElementType",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "id": 2293,
            "type": "LineElementType",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "id": 2294,
            "type": "LineElementType",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "id": 2295,
            "type": "LineElementType",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "id": 2296,
            "type": "LineElementType",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "id": 2297,
            "type": "LineElementType",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "id": 2298,
            "type": "LineElementType",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "id": 2299,
            "type": "LineElementType",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "id": 2300,
            "type": "LineElementType",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "id": 2301,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 193,
            "lineElementId": "0180",
            "startPosition": 118
          },
          {
            "id": 2302,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER ZORGVERZEKERAAR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0181",
            "startPosition": 311
          },
          {
            "id": 2303,
            "type": "LineElementType",
            "description": "DAGTEKENING RETOURBERICHT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0182",
            "startPosition": 335
          },
          {
            "id": 2304,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0196",
            "startPosition": 343
          },
          {
            "id": 2305,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0197",
            "startPosition": 347
          },
          {
            "id": 2306,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0198",
            "startPosition": 351
          },
          {
            "id": 2307,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 16,
            "lineElementId": "0199",
            "startPosition": 355
          }
        ]
      },
      {
        "id": 106,
        "type": "LineType",
        "length": 370,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "id": 2308,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "id": 2309,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "id": 2310,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "id": 2311,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "id": 2312,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "id": 2313,
            "type": "LineElementType",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "id": 2314,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "id": 2315,
            "type": "LineElementType",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "id": 2316,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "id": 2317,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "id": 2318,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "id": 2319,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "id": 2320,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "id": 2321,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "id": 2322,
            "type": "LineElementType",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "id": 2323,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "id": 2324,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "id": 2325,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "id": 2326,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "id": 2327,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "id": 2328,
            "type": "LineElementType",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "id": 2329,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "id": 2330,
            "type": "LineElementType",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "id": 2331,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 129,
            "lineElementId": "0280",
            "startPosition": 182
          },
          {
            "id": 2332,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0296",
            "startPosition": 311
          },
          {
            "id": 2333,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0297",
            "startPosition": 315
          },
          {
            "id": 2334,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0298",
            "startPosition": 319
          },
          {
            "id": 2335,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0299",
            "startPosition": 323
          }
        ]
      },
      {
        "id": 107,
        "type": "LineType",
        "length": 370,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "id": 2336,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "id": 2337,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "id": 2338,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "id": 2339,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "id": 2340,
            "type": "LineElementType",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "id": 2341,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "id": 2342,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "id": 2343,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "id": 2344,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "id": 2345,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "id": 2346,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "id": 2347,
            "type": "LineElementType",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "id": 2348,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "id": 2349,
            "type": "LineElementType",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "id": 2350,
            "type": "LineElementType",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "id": 2351,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "id": 2352,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "id": 2353,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "id": 2354,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "id": 2355,
            "type": "LineElementType",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "id": 2356,
            "type": "LineElementType",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "id": 2357,
            "type": "LineElementType",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "id": 2358,
            "type": "LineElementType",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "id": 2359,
            "type": "LineElementType",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "id": 2360,
            "type": "LineElementType",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "id": 2361,
            "type": "LineElementType",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "id": 2362,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 13,
            "lineElementId": "0380",
            "startPosition": 298
          },
          {
            "id": 2363,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0396",
            "startPosition": 311
          },
          {
            "id": 2364,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0397",
            "startPosition": 315
          },
          {
            "id": 2365,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0398",
            "startPosition": 319
          },
          {
            "id": 2366,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0399",
            "startPosition": 323
          }
        ]
      },
      {
        "id": 108,
        "type": "LineType",
        "length": 370,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "id": 2367,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "id": 2368,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "id": 2369,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "id": 2370,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "id": 2371,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "id": 2372,
            "type": "LineElementType",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "id": 2373,
            "type": "LineElementType",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "id": 2374,
            "type": "LineElementType",
            "description": "INDICATIE MEDIUM RISK VERLOSKUNDIGE ZORG",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "id": 2375,
            "type": "LineElementType",
            "description": "INDICATIE OVERNAME VERLOSKUNDIGE ZORG",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0409",
            "startPosition": 60
          },
          {
            "id": 2376,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE VORIGE ZORGVERLENER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0410",
            "startPosition": 61
          },
          {
            "id": 2377,
            "type": "LineElementType",
            "description": "ZORGVERLENERSSPECIFICATIE VORIGE ZORGVERLENER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0411",
            "startPosition": 69
          },
          {
            "id": 2378,
            "type": "LineElementType",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0412",
            "startPosition": 73
          },
          {
            "id": 2379,
            "type": "LineElementType",
            "description": "EINDDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0413",
            "startPosition": 81
          },
          {
            "id": 2380,
            "type": "LineElementType",
            "description": "DATUM PARTUS (BEVALLINGSDATUM)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0414",
            "startPosition": 89
          },
          {
            "id": 2381,
            "type": "LineElementType",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0415",
            "startPosition": 97
          },
          {
            "id": 2382,
            "type": "LineElementType",
            "description": "PRESTATIECODE",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0416",
            "startPosition": 100
          },
          {
            "id": 2383,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0417",
            "startPosition": 104
          },
          {
            "id": 2384,
            "type": "LineElementType",
            "description": "SPECIALISME BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0418",
            "startPosition": 112
          },
          {
            "id": 2385,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0419",
            "startPosition": 116
          },
          {
            "id": 2386,
            "type": "LineElementType",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0420",
            "startPosition": 124
          },
          {
            "id": 2387,
            "type": "LineElementType",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0421",
            "startPosition": 128
          },
          {
            "id": 2388,
            "type": "LineElementType",
            "description": "TIJDSEENHEID ZORGPERIODE",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0422",
            "startPosition": 132
          },
          {
            "id": 2389,
            "type": "LineElementType",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0423",
            "startPosition": 134
          },
          {
            "id": 2390,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0424",
            "startPosition": 142
          },
          {
            "id": 2391,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0425",
            "startPosition": 150
          },
          {
            "id": 2392,
            "type": "LineElementType",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0426",
            "startPosition": 151
          },
          {
            "id": 2393,
            "type": "LineElementType",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0427",
            "startPosition": 155
          },
          {
            "id": 2394,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0428",
            "startPosition": 163
          },
          {
            "id": 2395,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0429",
            "startPosition": 164
          },
          {
            "id": 2396,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0430",
            "startPosition": 184
          },
          {
            "id": 2397,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 107,
            "lineElementId": "0480",
            "startPosition": 204
          },
          {
            "id": 2398,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG ZORGVERZEKERAAR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0481",
            "startPosition": 311
          },
          {
            "id": 2399,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0482",
            "startPosition": 319
          },
          {
            "id": 2400,
            "type": "LineElementType",
            "description": "TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0483",
            "startPosition": 320
          },
          {
            "id": 2401,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (04)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0484",
            "startPosition": 328
          },
          {
            "id": 2402,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0496",
            "startPosition": 329
          },
          {
            "id": 2403,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0497",
            "startPosition": 333
          },
          {
            "id": 2404,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0498",
            "startPosition": 337
          },
          {
            "id": 2405,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 30,
            "lineElementId": "0499",
            "startPosition": 341
          }
        ]
      },
      {
        "id": 109,
        "type": "LineType",
        "length": 370,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "id": 2406,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "id": 2407,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "id": 2408,
            "type": "LineElementType",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "id": 2409,
            "type": "LineElementType",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "id": 2410,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 152,
            "lineElementId": "9880",
            "startPosition": 159
          },
          {
            "id": 2411,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9896",
            "startPosition": 311
          },
          {
            "id": 2412,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9897",
            "startPosition": 315
          },
          {
            "id": 2413,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9898",
            "startPosition": 319
          },
          {
            "id": 2414,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "9899",
            "startPosition": 323
          }
        ]
      },
      {
        "id": 110,
        "type": "LineType",
        "length": 370,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "id": 2415,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "id": 2416,
            "type": "LineElementType",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "id": 2417,
            "type": "LineElementType",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "id": 2418,
            "type": "LineElementType",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "id": 2419,
            "type": "LineElementType",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "id": 2420,
            "type": "LineElementType",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "id": 2421,
            "type": "LineElementType",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9907",
            "startPosition": 34
          },
          {
            "id": 2422,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9908",
            "startPosition": 45
          },
          {
            "id": 2423,
            "type": "LineElementType",
            "description": "TOTAAL TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9909",
            "startPosition": 46
          },
          {
            "id": 2424,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9910",
            "startPosition": 57
          },
          {
            "id": 2425,
            "type": "LineElementType",
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
    "id": 28,
    "type": "DocumentType",
    "description": "DECLARATIE DBC/ZIEKENHUISZORG",
    "formatSubVersion": 0,
    "formatVersion": 8,
    "name": "ZH308_8_0",
    "vektisEICode": 101,
    "lineTypes": [
      {
        "id": 161,
        "type": "LineType",
        "length": 570,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "id": 3410,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "id": 3411,
            "type": "LineElementType",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "id": 3412,
            "type": "LineElementType",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "id": 3413,
            "type": "LineElementType",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "id": 3414,
            "type": "LineElementType",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "id": 3415,
            "type": "LineElementType",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "id": 3416,
            "type": "LineElementType",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "id": 3417,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "id": 3418,
            "type": "LineElementType",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "id": 3419,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "id": 3420,
            "type": "LineElementType",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "id": 3421,
            "type": "LineElementType",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "id": 3422,
            "type": "LineElementType",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "id": 3423,
            "type": "LineElementType",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "id": 3424,
            "type": "LineElementType",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "id": 3425,
            "type": "LineElementType",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "id": 3426,
            "type": "LineElementType",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "id": 3427,
            "type": "LineElementType",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "id": 3428,
            "type": "LineElementType",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "id": 3429,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 453,
            "lineElementId": "0180",
            "startPosition": 118
          }
        ]
      },
      {
        "id": 162,
        "type": "LineType",
        "length": 570,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "id": 3430,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "id": 3431,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "id": 3432,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "id": 3433,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "id": 3434,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "id": 3435,
            "type": "LineElementType",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "id": 3436,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "id": 3437,
            "type": "LineElementType",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "id": 3438,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "id": 3439,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "id": 3440,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "id": 3441,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "id": 3442,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "id": 3443,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "id": 3444,
            "type": "LineElementType",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "id": 3445,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "id": 3446,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "id": 3447,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "id": 3448,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "id": 3449,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "id": 3450,
            "type": "LineElementType",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "id": 3451,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "id": 3452,
            "type": "LineElementType",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "id": 3453,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 389,
            "lineElementId": "0280",
            "startPosition": 182
          }
        ]
      },
      {
        "id": 163,
        "type": "LineType",
        "length": 570,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "id": 3454,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "id": 3455,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "id": 3456,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "id": 3457,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "id": 3458,
            "type": "LineElementType",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "id": 3459,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "id": 3460,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "id": 3461,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "id": 3462,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "id": 3463,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "id": 3464,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "id": 3465,
            "type": "LineElementType",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "id": 3466,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "id": 3467,
            "type": "LineElementType",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "id": 3468,
            "type": "LineElementType",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "id": 3469,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "id": 3470,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "id": 3471,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "id": 3472,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "id": 3473,
            "type": "LineElementType",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "id": 3474,
            "type": "LineElementType",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "id": 3475,
            "type": "LineElementType",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "id": 3476,
            "type": "LineElementType",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "id": 3477,
            "type": "LineElementType",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "id": 3478,
            "type": "LineElementType",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "id": 3479,
            "type": "LineElementType",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "id": 3480,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 273,
            "lineElementId": "0380",
            "startPosition": 298
          }
        ]
      },
      {
        "id": 164,
        "type": "LineType",
        "length": 570,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "id": 3481,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "id": 3482,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "id": 3483,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "id": 3484,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "id": 3485,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "id": 3486,
            "type": "LineElementType",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "id": 3487,
            "type": "LineElementType",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "id": 3488,
            "type": "LineElementType",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "id": 3489,
            "type": "LineElementType",
            "description": "PRESTATIECODE/DBC DECLARATIECODE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0409",
            "startPosition": 62
          },
          {
            "id": 3490,
            "type": "LineElementType",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0410",
            "startPosition": 68
          },
          {
            "id": 3491,
            "type": "LineElementType",
            "description": "EINDDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0411",
            "startPosition": 76
          },
          {
            "id": 3492,
            "type": "LineElementType",
            "description": "PRESTATIEVOLGNUMMER",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0412",
            "startPosition": 84
          },
          {
            "id": 3493,
            "type": "LineElementType",
            "description": "ZORGPRODUCTCODE",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0413",
            "startPosition": 86
          },
          {
            "id": 3494,
            "type": "LineElementType",
            "description": "ZORGTRAJECTNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0414",
            "startPosition": 95
          },
          {
            "id": 3495,
            "type": "LineElementType",
            "description": "BEGINDATUM ZORGTRAJECT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0415",
            "startPosition": 110
          },
          {
            "id": 3496,
            "type": "LineElementType",
            "description": "EINDDATUM ZORGTRAJECT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0416",
            "startPosition": 118
          },
          {
            "id": 3497,
            "type": "LineElementType",
            "description": "AFSLUITREDEN ZORGTRAJECT/SUBTRAJECT",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0417",
            "startPosition": 126
          },
          {
            "id": 3498,
            "type": "LineElementType",
            "description": "SUBTRAJECTNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0418",
            "startPosition": 128
          },
          {
            "id": 3499,
            "type": "LineElementType",
            "description": "CODE (ZELF)VERWIJZER",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0419",
            "startPosition": 143
          },
          {
            "id": 3500,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 145
          },
          {
            "id": 3501,
            "type": "LineElementType",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0421",
            "startPosition": 153
          },
          {
            "id": 3502,
            "type": "LineElementType",
            "description": "VERWIJZEND ZORGTRAJECTNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0422",
            "startPosition": 157
          },
          {
            "id": 3503,
            "type": "LineElementType",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0423",
            "startPosition": 172
          },
          {
            "id": 3504,
            "type": "LineElementType",
            "description": "ZORGTYPECODE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0424",
            "startPosition": 176
          },
          {
            "id": 3505,
            "type": "LineElementType",
            "description": "SOORT ZORGVRAAG",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0425",
            "startPosition": 182
          },
          {
            "id": 3506,
            "type": "LineElementType",
            "description": "ZORGVRAAGCODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0426",
            "startPosition": 183
          },
          {
            "id": 3507,
            "type": "LineElementType",
            "description": "SOORT DIAGNOSE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0427",
            "startPosition": 186
          },
          {
            "id": 3508,
            "type": "LineElementType",
            "description": "DIAGNOSECODE",
            "fieldType": "AN",
            "length": 7,
            "lineElementId": "0428",
            "startPosition": 187
          },
          {
            "id": 3509,
            "type": "LineElementType",
            "description": "INDICATIE AANSPRAAK ZORGVERZEKERINGSWET TOEGEPAST",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0429",
            "startPosition": 194
          },
          {
            "id": 3510,
            "type": "LineElementType",
            "description": "TOELICHTING PRESTATIE",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0430",
            "startPosition": 195
          },
          {
            "id": 3511,
            "type": "LineElementType",
            "description": "ACCEPTATIE TERMIJNOVERSCHRIJDING HERDECLARATIE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0431",
            "startPosition": 198
          },
          {
            "id": 3512,
            "type": "LineElementType",
            "description": "INDICATIE MACHTIGING",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0432",
            "startPosition": 199
          },
          {
            "id": 3513,
            "type": "LineElementType",
            "description": "INDICATIE PRODUCTTYPERENDE ORANJE VERRICHTING IN HET PROFIEL",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0433",
            "startPosition": 200
          },
          {
            "id": 3514,
            "type": "LineElementType",
            "description": "ZORGVERLENERSSPECIFICATIE BEHANDELAAR/UITVOERDER (SUBBEROEPSGROEP)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0434",
            "startPosition": 201
          },
          {
            "id": 3515,
            "type": "LineElementType",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0435",
            "startPosition": 205
          },
          {
            "id": 3516,
            "type": "LineElementType",
            "description": "HASHTOTAAL ZV",
            "fieldType": "AN",
            "length": 200,
            "lineElementId": "0436",
            "startPosition": 213
          },
          {
            "id": 3517,
            "type": "LineElementType",
            "description": "HASHVERSIE ZV",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0437",
            "startPosition": 413
          },
          {
            "id": 3518,
            "type": "LineElementType",
            "description": "CERTIFICAATVERSIE HASH",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0438",
            "startPosition": 425
          },
          {
            "id": 3519,
            "type": "LineElementType",
            "description": "GROUPERIDENTIFICATIE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0439",
            "startPosition": 437
          },
          {
            "id": 3520,
            "type": "LineElementType",
            "description": "GROUPERVERSIE",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0440",
            "startPosition": 440
          },
          {
            "id": 3521,
            "type": "LineElementType",
            "description": "TABELSETVERSIE GROUPER",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0441",
            "startPosition": 452
          },
          {
            "id": 3522,
            "type": "LineElementType",
            "description": "GROUPERWERKOMGEVING",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0442",
            "startPosition": 472
          },
          {
            "id": 3523,
            "type": "LineElementType",
            "description": "ZORGACTIVITEITCODE",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0443",
            "startPosition": 473
          },
          {
            "id": 3524,
            "type": "LineElementType",
            "description": "ZORGACTIVITEITNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0444",
            "startPosition": 483
          },
          {
            "id": 3525,
            "type": "LineElementType",
            "description": "ZORGPADCODE",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0445",
            "startPosition": 498
          },
          {
            "id": 3526,
            "type": "LineElementType",
            "description": "AANDUIDING DIAGNOSECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0446",
            "startPosition": 500
          },
          {
            "id": 3527,
            "type": "LineElementType",
            "description": "VERWIJSDIAGNOSECODE PARAMEDISCHE HULP",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0447",
            "startPosition": 503
          },
          {
            "id": 3528,
            "type": "LineElementType",
            "description": "CODE SOORT INDICATIE PARAMEDISCHE HULP",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0448",
            "startPosition": 511
          },
          {
            "id": 3529,
            "type": "LineElementType",
            "description": "INDICATIE TWEEDE OPERATIE ZELFDE AANDOENING PARAMEDISCHE HULP",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0449",
            "startPosition": 514
          },
          {
            "id": 3530,
            "type": "LineElementType",
            "description": "REDEN EINDE ZORG",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0450",
            "startPosition": 515
          },
          {
            "id": 3531,
            "type": "LineElementType",
            "description": "INDICATIE ONGEVAL (ONGEVALSGEVOLG)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0451",
            "startPosition": 517
          },
          {
            "id": 3532,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0452",
            "startPosition": 518
          },
          {
            "id": 3533,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0453",
            "startPosition": 519
          },
          {
            "id": 3534,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0454",
            "startPosition": 539
          },
          {
            "id": 3535,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0480",
            "startPosition": 559
          }
        ]
      },
      {
        "id": 165,
        "type": "LineType",
        "length": 570,
        "lineId": "06",
        "name": "TariefRecord",
        "lineElementTypes": [
          {
            "id": 3536,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0601",
            "startPosition": 1
          },
          {
            "id": 3537,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0602",
            "startPosition": 3
          },
          {
            "id": 3538,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0603",
            "startPosition": 15
          },
          {
            "id": 3539,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0604",
            "startPosition": 24
          },
          {
            "id": 3540,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0605",
            "startPosition": 28
          },
          {
            "id": 3541,
            "type": "LineElementType",
            "description": "AANDUIDING PRESTATIECODELIJST (01)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0606",
            "startPosition": 43
          },
          {
            "id": 3542,
            "type": "LineElementType",
            "description": "AANDUIDING PRESTATIECODELIJST (02)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0607",
            "startPosition": 46
          },
          {
            "id": 3543,
            "type": "LineElementType",
            "description": "PRESTATIECODE/DBC DECLARATIECODE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0608",
            "startPosition": 49
          },
          {
            "id": 3544,
            "type": "LineElementType",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0609",
            "startPosition": 55
          },
          {
            "id": 3545,
            "type": "LineElementType",
            "description": "PRESTATIEVOLGNUMMER",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0610",
            "startPosition": 63
          },
          {
            "id": 3546,
            "type": "LineElementType",
            "description": "SOORT PRESTATIE/TARIEF",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0611",
            "startPosition": 65
          },
          {
            "id": 3547,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0612",
            "startPosition": 67
          },
          {
            "id": 3548,
            "type": "LineElementType",
            "description": "ZORGVERLENERSSPECIFICATIE BEHANDELAAR/UITVOERDER (SUBBEROEPSGROEP)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0613",
            "startPosition": 75
          },
          {
            "id": 3549,
            "type": "LineElementType",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0614",
            "startPosition": 79
          },
          {
            "id": 3550,
            "type": "LineElementType",
            "description": "VERREKENPERCENTAGE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0615",
            "startPosition": 87
          },
          {
            "id": 3551,
            "type": "LineElementType",
            "description": "SOORT TOESLAG",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0616",
            "startPosition": 92
          },
          {
            "id": 3552,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0617",
            "startPosition": 94
          },
          {
            "id": 3553,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0618",
            "startPosition": 102
          },
          {
            "id": 3554,
            "type": "LineElementType",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0619",
            "startPosition": 103
          },
          {
            "id": 3555,
            "type": "LineElementType",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0620",
            "startPosition": 107
          },
          {
            "id": 3556,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0621",
            "startPosition": 115
          },
          {
            "id": 3557,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER DIT TARIEFRECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0622",
            "startPosition": 116
          },
          {
            "id": 3558,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE TARIEFRECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0623",
            "startPosition": 136
          },
          {
            "id": 3559,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 415,
            "lineElementId": "0680",
            "startPosition": 156
          }
        ]
      },
      {
        "id": 166,
        "type": "LineType",
        "length": 570,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "id": 3560,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "id": 3561,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "id": 3562,
            "type": "LineElementType",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "id": 3563,
            "type": "LineElementType",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "id": 3564,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 412,
            "lineElementId": "9880",
            "startPosition": 159
          }
        ]
      },
      {
        "id": 167,
        "type": "LineType",
        "length": 570,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "id": 3565,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "id": 3566,
            "type": "LineElementType",
            "description": "AANTAL VERZEKERDENRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "id": 3567,
            "type": "LineElementType",
            "description": "AANTAL DEBITEURRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "id": 3568,
            "type": "LineElementType",
            "description": "AANTAL PRESTATIERECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "id": 3569,
            "type": "LineElementType",
            "description": "AANTAL TARIEFRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "id": 3570,
            "type": "LineElementType",
            "description": "AANTAL COMMENTAARRECORDS",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "id": 3571,
            "type": "LineElementType",
            "description": "TOTAAL AANTAL DETAILRECORDS",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9907",
            "startPosition": 33
          },
          {
            "id": 3572,
            "type": "LineElementType",
            "description": "TOTAAL DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9908",
            "startPosition": 40
          },
          {
            "id": 3573,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9909",
            "startPosition": 51
          },
          {
            "id": 3574,
            "type": "LineElementType",
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
    "id": 29,
    "type": "DocumentType",
    "description": "RETOURINFORMATIE DECLARATIE DBC/ZIEKENHUISZORG",
    "formatSubVersion": 0,
    "formatVersion": 8,
    "name": "ZH309_8_0",
    "vektisEICode": 102,
    "lineTypes": [
      {
        "id": 168,
        "type": "LineType",
        "length": 630,
        "lineId": "01",
        "name": "VoorloopRecord",
        "lineElementTypes": [
          {
            "id": 3575,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0101",
            "startPosition": 1
          },
          {
            "id": 3576,
            "type": "LineElementType",
            "description": "CODE EXTERNE-INTEGRATIEBERICHT",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0102",
            "startPosition": 3
          },
          {
            "id": 3577,
            "type": "LineElementType",
            "description": "VERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0103",
            "startPosition": 6
          },
          {
            "id": 3578,
            "type": "LineElementType",
            "description": "SUBVERSIENUMMER BERICHTSTANDAARD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0104",
            "startPosition": 8
          },
          {
            "id": 3579,
            "type": "LineElementType",
            "description": "SOORT BERICHT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0105",
            "startPosition": 10
          },
          {
            "id": 3580,
            "type": "LineElementType",
            "description": "CODE INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "0106",
            "startPosition": 11
          },
          {
            "id": 3581,
            "type": "LineElementType",
            "description": "VERSIEAANDUIDING INFORMATIESYSTEEM SOFTWARELEVERANCIER",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0107",
            "startPosition": 17
          },
          {
            "id": 3582,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0108",
            "startPosition": 27
          },
          {
            "id": 3583,
            "type": "LineElementType",
            "description": "CODE SERVICEBUREAU",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0109",
            "startPosition": 31
          },
          {
            "id": 3584,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0110",
            "startPosition": 39
          },
          {
            "id": 3585,
            "type": "LineElementType",
            "description": "PRAKTIJKCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0111",
            "startPosition": 47
          },
          {
            "id": 3586,
            "type": "LineElementType",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0112",
            "startPosition": 55
          },
          {
            "id": 3587,
            "type": "LineElementType",
            "description": "IDENTIFICATIECODE BETALING AAN",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0113",
            "startPosition": 63
          },
          {
            "id": 3588,
            "type": "LineElementType",
            "description": "BEGINDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0114",
            "startPosition": 65
          },
          {
            "id": 3589,
            "type": "LineElementType",
            "description": "EINDDATUM DECLARATIEPERIODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0115",
            "startPosition": 73
          },
          {
            "id": 3590,
            "type": "LineElementType",
            "description": "FACTUURNUMMER DECLARANT",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0116",
            "startPosition": 81
          },
          {
            "id": 3591,
            "type": "LineElementType",
            "description": "DAGTEKENING FACTUUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0117",
            "startPosition": 93
          },
          {
            "id": 3592,
            "type": "LineElementType",
            "description": "BTW-IDENTIFICATIENUMMER",
            "fieldType": "AN",
            "length": 14,
            "lineElementId": "0118",
            "startPosition": 101
          },
          {
            "id": 3593,
            "type": "LineElementType",
            "description": "VALUTACODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0119",
            "startPosition": 115
          },
          {
            "id": 3594,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 453,
            "lineElementId": "0180",
            "startPosition": 118
          },
          {
            "id": 3595,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER ZORGVERZEKERAAR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0181",
            "startPosition": 571
          },
          {
            "id": 3596,
            "type": "LineElementType",
            "description": "DAGTEKENING RETOURBERICHT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0182",
            "startPosition": 595
          },
          {
            "id": 3597,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0196",
            "startPosition": 603
          },
          {
            "id": 3598,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0197",
            "startPosition": 607
          },
          {
            "id": 3599,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0198",
            "startPosition": 611
          },
          {
            "id": 3600,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 16,
            "lineElementId": "0199",
            "startPosition": 615
          }
        ]
      },
      {
        "id": 169,
        "type": "LineType",
        "length": 630,
        "lineId": "02",
        "name": "VerzekerdenRecord",
        "lineElementTypes": [
          {
            "id": 3601,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0201",
            "startPosition": 1
          },
          {
            "id": 3602,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0202",
            "startPosition": 3
          },
          {
            "id": 3603,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0203",
            "startPosition": 15
          },
          {
            "id": 3604,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0204",
            "startPosition": 24
          },
          {
            "id": 3605,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0205",
            "startPosition": 28
          },
          {
            "id": 3606,
            "type": "LineElementType",
            "description": "PATIENT(IDENTIFICATIE)NUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0206",
            "startPosition": 43
          },
          {
            "id": 3607,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE VERZEKERDE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0207",
            "startPosition": 54
          },
          {
            "id": 3608,
            "type": "LineElementType",
            "description": "CODE GESLACHT VERZEKERDE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0208",
            "startPosition": 62
          },
          {
            "id": 3609,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0209",
            "startPosition": 63
          },
          {
            "id": 3610,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0210",
            "startPosition": 64
          },
          {
            "id": 3611,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0211",
            "startPosition": 89
          },
          {
            "id": 3612,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0212",
            "startPosition": 99
          },
          {
            "id": 3613,
            "type": "LineElementType",
            "description": "NAAM VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0213",
            "startPosition": 100
          },
          {
            "id": 3614,
            "type": "LineElementType",
            "description": "VOORVOEGSEL VERZEKERDE (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0214",
            "startPosition": 125
          },
          {
            "id": 3615,
            "type": "LineElementType",
            "description": "VOORLETTERS VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0215",
            "startPosition": 135
          },
          {
            "id": 3616,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0216",
            "startPosition": 141
          },
          {
            "id": 3617,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0217",
            "startPosition": 142
          },
          {
            "id": 3618,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0218",
            "startPosition": 148
          },
          {
            "id": 3619,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) VERZEKERDE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0219",
            "startPosition": 157
          },
          {
            "id": 3620,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) VERZEKERDE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0220",
            "startPosition": 162
          },
          {
            "id": 3621,
            "type": "LineElementType",
            "description": "CODE LAND VERZEKERDE",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0221",
            "startPosition": 168
          },
          {
            "id": 3622,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0222",
            "startPosition": 170
          },
          {
            "id": 3623,
            "type": "LineElementType",
            "description": "INDICATIE CLIENT OVERLEDEN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0223",
            "startPosition": 181
          },
          {
            "id": 3624,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 389,
            "lineElementId": "0280",
            "startPosition": 182
          },
          {
            "id": 3625,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0296",
            "startPosition": 571
          },
          {
            "id": 3626,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0297",
            "startPosition": 575
          },
          {
            "id": 3627,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0298",
            "startPosition": 579
          },
          {
            "id": 3628,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0299",
            "startPosition": 583
          }
        ]
      },
      {
        "id": 170,
        "type": "LineType",
        "length": 630,
        "lineId": "03",
        "name": "DebiteurRecord",
        "lineElementTypes": [
          {
            "id": 3629,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0301",
            "startPosition": 1
          },
          {
            "id": 3630,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0302",
            "startPosition": 3
          },
          {
            "id": 3631,
            "type": "LineElementType",
            "description": "DEBITEURNUMMER",
            "fieldType": "AN",
            "length": 11,
            "lineElementId": "0303",
            "startPosition": 15
          },
          {
            "id": 3632,
            "type": "LineElementType",
            "description": "DATUM GEBOORTE DEBITEUR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0304",
            "startPosition": 26
          },
          {
            "id": 3633,
            "type": "LineElementType",
            "description": "CODE GESLACHT DEBITEUR",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0305",
            "startPosition": 34
          },
          {
            "id": 3634,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (01)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0306",
            "startPosition": 35
          },
          {
            "id": 3635,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (01)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0307",
            "startPosition": 36
          },
          {
            "id": 3636,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (01)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0308",
            "startPosition": 61
          },
          {
            "id": 3637,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (02)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0309",
            "startPosition": 71
          },
          {
            "id": 3638,
            "type": "LineElementType",
            "description": "NAAM DEBITEUR (02)",
            "fieldType": "AN",
            "length": 25,
            "lineElementId": "0310",
            "startPosition": 72
          },
          {
            "id": 3639,
            "type": "LineElementType",
            "description": "VOORVOEGSEL DEBITEUR (02)",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0311",
            "startPosition": 97
          },
          {
            "id": 3640,
            "type": "LineElementType",
            "description": "VOORLETTERS DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0312",
            "startPosition": 107
          },
          {
            "id": 3641,
            "type": "LineElementType",
            "description": "NAAMCODE/NAAMGEBRUIK (03)",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0313",
            "startPosition": 113
          },
          {
            "id": 3642,
            "type": "LineElementType",
            "description": "TITULATUUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0314",
            "startPosition": 114
          },
          {
            "id": 3643,
            "type": "LineElementType",
            "description": "STRAATNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0315",
            "startPosition": 116
          },
          {
            "id": 3644,
            "type": "LineElementType",
            "description": "HUISNUMMER (HUISADRES) DEBITEUR",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0316",
            "startPosition": 140
          },
          {
            "id": 3645,
            "type": "LineElementType",
            "description": "HUISNUMMERTOEVOEGING (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0317",
            "startPosition": 145
          },
          {
            "id": 3646,
            "type": "LineElementType",
            "description": "POSTCODE (HUISADRES) DEBITEUR",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0318",
            "startPosition": 151
          },
          {
            "id": 3647,
            "type": "LineElementType",
            "description": "POSTCODE BUITENLAND",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0319",
            "startPosition": 157
          },
          {
            "id": 3648,
            "type": "LineElementType",
            "description": "WOONPLAATSNAAM DEBITEUR",
            "fieldType": "AN",
            "length": 24,
            "lineElementId": "0320",
            "startPosition": 166
          },
          {
            "id": 3649,
            "type": "LineElementType",
            "description": "CODE LAND DEBITEUR",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0321",
            "startPosition": 190
          },
          {
            "id": 3650,
            "type": "LineElementType",
            "description": "TELEFOONNUMMER DEBITEUR",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0322",
            "startPosition": 192
          },
          {
            "id": 3651,
            "type": "LineElementType",
            "description": "LANDNUMMER TELEFOON (CODE LAND)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0323",
            "startPosition": 207
          },
          {
            "id": 3652,
            "type": "LineElementType",
            "description": "E-MAILADRES DEBITEUR",
            "fieldType": "AN",
            "length": 70,
            "lineElementId": "0324",
            "startPosition": 210
          },
          {
            "id": 3653,
            "type": "LineElementType",
            "description": "BANKREKENINGNUMMER",
            "fieldType": "N",
            "length": 16,
            "lineElementId": "0325",
            "startPosition": 280
          },
          {
            "id": 3654,
            "type": "LineElementType",
            "description": "SOORT RELATIE DEBITEUR",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0326",
            "startPosition": 296
          },
          {
            "id": 3655,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 273,
            "lineElementId": "0380",
            "startPosition": 298
          },
          {
            "id": 3656,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0396",
            "startPosition": 571
          },
          {
            "id": 3657,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0397",
            "startPosition": 575
          },
          {
            "id": 3658,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0398",
            "startPosition": 579
          },
          {
            "id": 3659,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0399",
            "startPosition": 583
          }
        ]
      },
      {
        "id": 171,
        "type": "LineType",
        "length": 630,
        "lineId": "04",
        "name": "PrestatieRecord",
        "lineElementTypes": [
          {
            "id": 3660,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0401",
            "startPosition": 1
          },
          {
            "id": 3661,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0402",
            "startPosition": 3
          },
          {
            "id": 3662,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0403",
            "startPosition": 15
          },
          {
            "id": 3663,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0404",
            "startPosition": 24
          },
          {
            "id": 3664,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0405",
            "startPosition": 28
          },
          {
            "id": 3665,
            "type": "LineElementType",
            "description": "MACHTIGINGSNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0406",
            "startPosition": 43
          },
          {
            "id": 3666,
            "type": "LineElementType",
            "description": "DOORSTUREN TOEGESTAAN",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0407",
            "startPosition": 58
          },
          {
            "id": 3667,
            "type": "LineElementType",
            "description": "AANDUIDING PRESTATIECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0408",
            "startPosition": 59
          },
          {
            "id": 3668,
            "type": "LineElementType",
            "description": "PRESTATIECODE/DBC DECLARATIECODE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0409",
            "startPosition": 62
          },
          {
            "id": 3669,
            "type": "LineElementType",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0410",
            "startPosition": 68
          },
          {
            "id": 3670,
            "type": "LineElementType",
            "description": "EINDDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0411",
            "startPosition": 76
          },
          {
            "id": 3671,
            "type": "LineElementType",
            "description": "PRESTATIEVOLGNUMMER",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0412",
            "startPosition": 84
          },
          {
            "id": 3672,
            "type": "LineElementType",
            "description": "ZORGPRODUCTCODE",
            "fieldType": "AN",
            "length": 9,
            "lineElementId": "0413",
            "startPosition": 86
          },
          {
            "id": 3673,
            "type": "LineElementType",
            "description": "ZORGTRAJECTNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0414",
            "startPosition": 95
          },
          {
            "id": 3674,
            "type": "LineElementType",
            "description": "BEGINDATUM ZORGTRAJECT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0415",
            "startPosition": 110
          },
          {
            "id": 3675,
            "type": "LineElementType",
            "description": "EINDDATUM ZORGTRAJECT",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0416",
            "startPosition": 118
          },
          {
            "id": 3676,
            "type": "LineElementType",
            "description": "AFSLUITREDEN ZORGTRAJECT/SUBTRAJECT",
            "fieldType": "AN",
            "length": 2,
            "lineElementId": "0417",
            "startPosition": 126
          },
          {
            "id": 3677,
            "type": "LineElementType",
            "description": "SUBTRAJECTNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0418",
            "startPosition": 128
          },
          {
            "id": 3678,
            "type": "LineElementType",
            "description": "CODE (ZELF)VERWIJZER",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0419",
            "startPosition": 143
          },
          {
            "id": 3679,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0420",
            "startPosition": 145
          },
          {
            "id": 3680,
            "type": "LineElementType",
            "description": "SPECIALISME VOORSCHRIJVER/VERWIJZER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0421",
            "startPosition": 153
          },
          {
            "id": 3681,
            "type": "LineElementType",
            "description": "VERWIJZEND ZORGTRAJECTNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0422",
            "startPosition": 157
          },
          {
            "id": 3682,
            "type": "LineElementType",
            "description": "AANTAL UITGEVOERDE PRESTATIES",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0423",
            "startPosition": 172
          },
          {
            "id": 3683,
            "type": "LineElementType",
            "description": "ZORGTYPECODE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0424",
            "startPosition": 176
          },
          {
            "id": 3684,
            "type": "LineElementType",
            "description": "SOORT ZORGVRAAG",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0425",
            "startPosition": 182
          },
          {
            "id": 3685,
            "type": "LineElementType",
            "description": "ZORGVRAAGCODE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0426",
            "startPosition": 183
          },
          {
            "id": 3686,
            "type": "LineElementType",
            "description": "SOORT DIAGNOSE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0427",
            "startPosition": 186
          },
          {
            "id": 3687,
            "type": "LineElementType",
            "description": "DIAGNOSECODE",
            "fieldType": "AN",
            "length": 7,
            "lineElementId": "0428",
            "startPosition": 187
          },
          {
            "id": 3688,
            "type": "LineElementType",
            "description": "INDICATIE AANSPRAAK ZORGVERZEKERINGSWET TOEGEPAST",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0429",
            "startPosition": 194
          },
          {
            "id": 3689,
            "type": "LineElementType",
            "description": "TOELICHTING PRESTATIE",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0430",
            "startPosition": 195
          },
          {
            "id": 3690,
            "type": "LineElementType",
            "description": "ACCEPTATIE TERMIJNOVERSCHRIJDING HERDECLARATIE",
            "fieldType": "N",
            "length": 1,
            "lineElementId": "0431",
            "startPosition": 198
          },
          {
            "id": 3691,
            "type": "LineElementType",
            "description": "INDICATIE MACHTIGING",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0432",
            "startPosition": 199
          },
          {
            "id": 3692,
            "type": "LineElementType",
            "description": "INDICATIE PRODUCTTYPERENDE ORANJE VERRICHTING IN HET PROFIEL",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0433",
            "startPosition": 200
          },
          {
            "id": 3693,
            "type": "LineElementType",
            "description": "ZORGVERLENERSSPECIFICATIE BEHANDELAAR/UITVOERDER (SUBBEROEPSGROEP)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0434",
            "startPosition": 201
          },
          {
            "id": 3694,
            "type": "LineElementType",
            "description": "INSTELLINGSCODE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0435",
            "startPosition": 205
          },
          {
            "id": 3695,
            "type": "LineElementType",
            "description": "HASHTOTAAL ZV",
            "fieldType": "AN",
            "length": 200,
            "lineElementId": "0436",
            "startPosition": 213
          },
          {
            "id": 3696,
            "type": "LineElementType",
            "description": "HASHVERSIE ZV",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0437",
            "startPosition": 413
          },
          {
            "id": 3697,
            "type": "LineElementType",
            "description": "CERTIFICAATVERSIE HASH",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0438",
            "startPosition": 425
          },
          {
            "id": 3698,
            "type": "LineElementType",
            "description": "GROUPERIDENTIFICATIE",
            "fieldType": "AN",
            "length": 3,
            "lineElementId": "0439",
            "startPosition": 437
          },
          {
            "id": 3699,
            "type": "LineElementType",
            "description": "GROUPERVERSIE",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0440",
            "startPosition": 440
          },
          {
            "id": 3700,
            "type": "LineElementType",
            "description": "TABELSETVERSIE GROUPER",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0441",
            "startPosition": 452
          },
          {
            "id": 3701,
            "type": "LineElementType",
            "description": "GROUPERWERKOMGEVING",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0442",
            "startPosition": 472
          },
          {
            "id": 3702,
            "type": "LineElementType",
            "description": "ZORGACTIVITEITCODE",
            "fieldType": "AN",
            "length": 10,
            "lineElementId": "0443",
            "startPosition": 473
          },
          {
            "id": 3703,
            "type": "LineElementType",
            "description": "ZORGACTIVITEITNUMMER",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0444",
            "startPosition": 483
          },
          {
            "id": 3704,
            "type": "LineElementType",
            "description": "ZORGPADCODE",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0445",
            "startPosition": 498
          },
          {
            "id": 3705,
            "type": "LineElementType",
            "description": "AANDUIDING DIAGNOSECODELIJST",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0446",
            "startPosition": 500
          },
          {
            "id": 3706,
            "type": "LineElementType",
            "description": "VERWIJSDIAGNOSECODE PARAMEDISCHE HULP",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0447",
            "startPosition": 503
          },
          {
            "id": 3707,
            "type": "LineElementType",
            "description": "CODE SOORT INDICATIE PARAMEDISCHE HULP",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0448",
            "startPosition": 511
          },
          {
            "id": 3708,
            "type": "LineElementType",
            "description": "INDICATIE TWEEDE OPERATIE ZELFDE AANDOENING PARAMEDISCHE HULP",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0449",
            "startPosition": 514
          },
          {
            "id": 3709,
            "type": "LineElementType",
            "description": "REDEN EINDE ZORG",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0450",
            "startPosition": 515
          },
          {
            "id": 3710,
            "type": "LineElementType",
            "description": "INDICATIE ONGEVAL (ONGEVALSGEVOLG)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0451",
            "startPosition": 517
          },
          {
            "id": 3711,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0452",
            "startPosition": 518
          },
          {
            "id": 3712,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER DIT PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0453",
            "startPosition": 519
          },
          {
            "id": 3713,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE PRESTATIERECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0454",
            "startPosition": 539
          },
          {
            "id": 3714,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 12,
            "lineElementId": "0480",
            "startPosition": 559
          },
          {
            "id": 3715,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0496",
            "startPosition": 571
          },
          {
            "id": 3716,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0497",
            "startPosition": 575
          },
          {
            "id": 3717,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0498",
            "startPosition": 579
          },
          {
            "id": 3718,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "0499",
            "startPosition": 583
          }
        ]
      },
      {
        "id": 172,
        "type": "LineType",
        "length": 630,
        "lineId": "06",
        "name": "TariefRecord",
        "lineElementTypes": [
          {
            "id": 3719,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0601",
            "startPosition": 1
          },
          {
            "id": 3720,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "0602",
            "startPosition": 3
          },
          {
            "id": 3721,
            "type": "LineElementType",
            "description": "BURGERSERVICENUMMER (BSN) VERZEKERDE",
            "fieldType": "N",
            "length": 9,
            "lineElementId": "0603",
            "startPosition": 15
          },
          {
            "id": 3722,
            "type": "LineElementType",
            "description": "UZOVI-NUMMER",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0604",
            "startPosition": 24
          },
          {
            "id": 3723,
            "type": "LineElementType",
            "description": "VERZEKERDENNUMMER (INSCHRIJVINGSNUMMER, RELATIENUMMER)",
            "fieldType": "AN",
            "length": 15,
            "lineElementId": "0605",
            "startPosition": 28
          },
          {
            "id": 3724,
            "type": "LineElementType",
            "description": "AANDUIDING PRESTATIECODELIJST (01)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0606",
            "startPosition": 43
          },
          {
            "id": 3725,
            "type": "LineElementType",
            "description": "AANDUIDING PRESTATIECODELIJST (02)",
            "fieldType": "N",
            "length": 3,
            "lineElementId": "0607",
            "startPosition": 46
          },
          {
            "id": 3726,
            "type": "LineElementType",
            "description": "PRESTATIECODE/DBC DECLARATIECODE",
            "fieldType": "AN",
            "length": 6,
            "lineElementId": "0608",
            "startPosition": 49
          },
          {
            "id": 3727,
            "type": "LineElementType",
            "description": "BEGINDATUM PRESTATIE",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0609",
            "startPosition": 55
          },
          {
            "id": 3728,
            "type": "LineElementType",
            "description": "PRESTATIEVOLGNUMMER",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0610",
            "startPosition": 63
          },
          {
            "id": 3729,
            "type": "LineElementType",
            "description": "SOORT PRESTATIE/TARIEF",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0611",
            "startPosition": 65
          },
          {
            "id": 3730,
            "type": "LineElementType",
            "description": "ZORGVERLENERSCODE BEHANDELAAR/UITVOERDER",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0612",
            "startPosition": 67
          },
          {
            "id": 3731,
            "type": "LineElementType",
            "description": "ZORGVERLENERSSPECIFICATIE BEHANDELAAR/UITVOERDER (SUBBEROEPSGROEP)",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0613",
            "startPosition": 75
          },
          {
            "id": 3732,
            "type": "LineElementType",
            "description": "TARIEF PRESTATIE (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0614",
            "startPosition": 79
          },
          {
            "id": 3733,
            "type": "LineElementType",
            "description": "VERREKENPERCENTAGE",
            "fieldType": "N",
            "length": 5,
            "lineElementId": "0615",
            "startPosition": 87
          },
          {
            "id": 3734,
            "type": "LineElementType",
            "description": "SOORT TOESLAG",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "0616",
            "startPosition": 92
          },
          {
            "id": 3735,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0617",
            "startPosition": 94
          },
          {
            "id": 3736,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0618",
            "startPosition": 102
          },
          {
            "id": 3737,
            "type": "LineElementType",
            "description": "BTW-PERCENTAGE DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "0619",
            "startPosition": 103
          },
          {
            "id": 3738,
            "type": "LineElementType",
            "description": "DECLARATIEBEDRAG (INCL. BTW)",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0620",
            "startPosition": 107
          },
          {
            "id": 3739,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0621",
            "startPosition": 115
          },
          {
            "id": 3740,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER DIT TARIEFRECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0622",
            "startPosition": 116
          },
          {
            "id": 3741,
            "type": "LineElementType",
            "description": "REFERENTIENUMMER VOORGAANDE GERELATEERDE TARIEFRECORD",
            "fieldType": "AN",
            "length": 20,
            "lineElementId": "0623",
            "startPosition": 136
          },
          {
            "id": 3742,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 415,
            "lineElementId": "0680",
            "startPosition": 156
          },
          {
            "id": 3743,
            "type": "LineElementType",
            "description": "BEREKEND BEDRAG ZORGVERZEKERAAR",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0681",
            "startPosition": 571
          },
          {
            "id": 3744,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (03)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0682",
            "startPosition": 579
          },
          {
            "id": 3745,
            "type": "LineElementType",
            "description": "TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 8,
            "lineElementId": "0683",
            "startPosition": 580
          },
          {
            "id": 3746,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (04)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "0684",
            "startPosition": 588
          },
          {
            "id": 3747,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0696",
            "startPosition": 589
          },
          {
            "id": 3748,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0697",
            "startPosition": 593
          },
          {
            "id": 3749,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "0698",
            "startPosition": 597
          },
          {
            "id": 3750,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 30,
            "lineElementId": "0699",
            "startPosition": 601
          }
        ]
      },
      {
        "id": 173,
        "type": "LineType",
        "length": 630,
        "lineId": "98",
        "name": "CommentaarRecord",
        "lineElementTypes": [
          {
            "id": 3751,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9801",
            "startPosition": 1
          },
          {
            "id": 3752,
            "type": "LineElementType",
            "description": "IDENTIFICATIE DETAILRECORD",
            "fieldType": "N",
            "length": 12,
            "lineElementId": "9802",
            "startPosition": 3
          },
          {
            "id": 3753,
            "type": "LineElementType",
            "description": "REGELNUMMER VRIJE TEKST",
            "fieldType": "N",
            "length": 4,
            "lineElementId": "9803",
            "startPosition": 15
          },
          {
            "id": 3754,
            "type": "LineElementType",
            "description": "VRIJE TEKST",
            "fieldType": "AN",
            "length": 140,
            "lineElementId": "9804",
            "startPosition": 19
          },
          {
            "id": 3755,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 412,
            "lineElementId": "9880",
            "startPosition": 159
          },
          {
            "id": 3756,
            "type": "LineElementType",
            "description": "RETOURCODE (01)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9896",
            "startPosition": 571
          },
          {
            "id": 3757,
            "type": "LineElementType",
            "description": "RETOURCODE (02)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9897",
            "startPosition": 575
          },
          {
            "id": 3758,
            "type": "LineElementType",
            "description": "RETOURCODE (03)",
            "fieldType": "AN",
            "length": 4,
            "lineElementId": "9898",
            "startPosition": 579
          },
          {
            "id": 3759,
            "type": "LineElementType",
            "description": "RESERVE",
            "fieldType": "AN",
            "length": 48,
            "lineElementId": "9899",
            "startPosition": 583
          }
        ]
      },
      {
        "id": 174,
        "type": "LineType",
        "length": 630,
        "lineId": "99",
        "name": "SluitRecord",
        "lineElementTypes": [
          {
            "id": 3760,
            "type": "LineElementType",
            "description": "KENMERK RECORD",
            "fieldType": "N",
            "length": 2,
            "lineElementId": "9901",
            "startPosition": 1
          },
          {
            "id": 3761,
            "type": "LineElementType",
            "description": "AANTAL VERZEKERDENRECORDS RETOUR",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9902",
            "startPosition": 3
          },
          {
            "id": 3762,
            "type": "LineElementType",
            "description": "AANTAL DEBITEURRECORDS RETOUR",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9903",
            "startPosition": 9
          },
          {
            "id": 3763,
            "type": "LineElementType",
            "description": "AANTAL PRESTATIERECORDS RETOUR",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9904",
            "startPosition": 15
          },
          {
            "id": 3764,
            "type": "LineElementType",
            "description": "AANTAL TARIEFRECORDS RETOUR",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9905",
            "startPosition": 21
          },
          {
            "id": 3765,
            "type": "LineElementType",
            "description": "AANTAL COMMENTAARRECORDS RETOUR",
            "fieldType": "N",
            "length": 6,
            "lineElementId": "9906",
            "startPosition": 27
          },
          {
            "id": 3766,
            "type": "LineElementType",
            "description": "TOTAAL AANTAL DETAILRECORDS RETOUR",
            "fieldType": "N",
            "length": 7,
            "lineElementId": "9907",
            "startPosition": 33
          },
          {
            "id": 3767,
            "type": "LineElementType",
            "description": "TOTAAL INGEDIEND DECLARATIEBEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9908",
            "startPosition": 40
          },
          {
            "id": 3768,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (01)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9909",
            "startPosition": 51
          },
          {
            "id": 3769,
            "type": "LineElementType",
            "description": "TOTAAL TOEGEKEND BEDRAG",
            "fieldType": "N",
            "length": 11,
            "lineElementId": "9910",
            "startPosition": 52
          },
          {
            "id": 3770,
            "type": "LineElementType",
            "description": "INDICATIE DEBET/CREDIT (02)",
            "fieldType": "AN",
            "length": 1,
            "lineElementId": "9911",
            "startPosition": 63
          },
          {
            "id": 3771,
            "type": "LineElementType",
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
   types[0]
import json, future, sequtils, strutils, logging, tables
import "common"

let 
   debtorRecordLineId* = "03"
   debtorRecordVersionStartIndex = 298
   debtorRecordVersionEndIndex = 299


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
        "parentLineId": null,
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
        "parentLineId": "01",
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
        "parentLineId": "02",
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
        "parentLineId": "02",
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
        "parentLineId": "01",
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
        "parentLineId": "01",
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
        "parentLineId": null,
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
        "parentLineId": "01",
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
        "parentLineId": "02",
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
        "parentLineId": "01",
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
        "parentLineId": "01",
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
        "parentLineId": "02",
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
        "parentLineId": null,
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
        "parentLineId": "01",
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
        "parentLineId": "02",
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
        "parentLineId": "02",
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
        "parentLineId": "01",
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
        "parentLineId": "01",
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
  }
]
"""

let debtorRecordTypesString = """
[
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
        "parentLineId": "02",
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
        "parentLineId": "02",
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
  }
]
"""
let typesJson = parseJson(doctypes_json_string)
let types = lc[to(node, DocumentType) | (node <- typesJson), DocumentType]

let debtorRecordTypesJson = parseJson(debtorRecordTypesString)
let debtorRecordTypes = lc[to(node, DocumentType) | (node <- debtorRecordTypesJson), DocumentType]
let debtorRecordTypeName = "SB311"
let blanksSet: set[char] = { ' ' }

proc isDate*(leType: LineElementType): bool =
   leType.length == 8 and leType.code.startsWith("DAT")

proc stripBlanks(source: string): string =
   strip(source, true, true, blanksSet)

proc get_doctype*(typeId: int, version: int, subversion: int): DocumentType = 
   let matches = filter(types, proc(t: DocumentType): bool = t.vektisEICode == typeId and t.formatVersion == version and t.formatSubVersion == subversion)
   if matches.len == 0:
      raise newException(DocumentTypeError, "Unknown declatation format: Vektis EI code: '$#', version: $#, subversion: $#" % [intToStr(typeId), intToStr(version), intToStr(subversion)])
   else:
      result = matches[0]

proc allDocumentTypes*(): seq[DocumentType] = 
   concat(types, debtorRecordTypes)

proc documentTypeMatching*(name: string, version: int, subversion: int): DocumentType = 
   let matches = filter(allDocumentTypes(), proc(t: DocumentType): bool = t.name == name and t.formatVersion == version and t.formatSubVersion == subversion)
   if matches.len == 0:
      raise newException(DocumentTypeError, "Unknown declaration format: name: '$#', version: $#, subversion: $#" % [name, intToStr(version), intToStr(subversion)])
   else:
      result = matches[0]

proc getLineTypeForLineId*(doctype: DocumentType, lineId: string): LineType =
   let lineTypes = doctype.lineTypes.filter(proc (lt: LineType): bool = lt.lineId == lineId)
   if lineTypes.len == 0:
      raise newException(ValueError, "Document $# does not have a line type with ID $#" % [doctype.name, lineId])
   else:
      result = lineTypes[0]

proc getLineTypeForFullLine*(defaultDocType: DocumentType, line: string): LineType =
   let lineId = line[0..1]
   result = getLineTypeForLineId(defaultDocType, lineId)
   if lineId == debtorRecordLineId:
      if line.len > debtorRecordVersionEndIndex:
         var doctype = defaultDocType
         case line[debtorRecordVersionStartIndex..debtorRecordVersionEndIndex]
         of "01":
            doctype = debtorRecordTypes[0]
         of "02":
            doctype = debtorRecordTypes[1]
         else: discard
         result = getLineTypeForLineId(doctype, lineId)
      else:
         raise newException(VektisFormatError, "Invalid line length for debtor record: $#" % [intToStr(line.len)])

proc contextWithLineId*(context: Context, lineId: string): Context =
   assert(not isNil(lineId))
   debug( "contextWithLineId: $#" % [lineId])
   if context.lineType.lineId == lineId:
      result = context
   elif len(context.subContexts) == 0:
      raise newException(NotFoundError, "No context found with line id $#" % [lineId])
   else:
      for sub in context.subContexts.values:
         let found = contextWithLineId(sub, lineId)
         if not isNil(found):
            result = found
            break
         else: discard


proc getLineId*(line: string): string = 
   if isNil(line) or line.len < 4:
      raise newException(ValueError, "Cannot get line id from '$#'" % [line])
   else:
      result = line[0 .. 1]

proc getLineElementType*(lineType: LineType, leId: string): LineElementType =
   debug("getLineElementType: lt: $#, leId: $#" % [lineType.lineId, leId])
   #assert(leId.startsWith(lineType.lineId))
   let results = lineType.lineElementTypes.filter(proc(et: LineElementType): bool = et.lineElementId == leId)
   if results.len == 0:
      raise newException(ValueError, "LineType '$#' does not have an element with id '$#'." % [lineType.lineId, leId])
   else:
      result = results[0]


proc getLineElementType*(docType: DocumentType, leId: string): LineElementType =
   debug("getLineType: d: $#, leId: $#" % [docType.name, leId])
   let lineType = getLineTypeForLineId(docType, getLineId(leId))
   result = lineType.getLineElementType(leId)

proc getElementValueFullString(line: string, leType: LineElementType): string =
   let start = leType.startPosition-1
   let fin = start + leType.length-1
   result = line[start..fin]

proc getElementValueFullString*(rootContext: Context, lineElementId: string): string =
   let lineId = lineElementId[0..1]
   let context = rootContext.contextWithLineId(lineId)
   debug("getElementValueFullString: rootctx: $#, leId: $#, subctx: $#" % [rootContext.lineType.lineId, lineId, context.lineType.lineId])
   assert(context.line.startsWith(lineId))
   let leType = context.lineType.getLineElementType(lineElementId)
   let start = leType.startPosition-1
   let fin = start + leType.length-1
   result = context.line[start..fin]

proc getElementValueString*(context: Context, leId: string): string =
   stripBlanks(getElementValueFullString(context, leId))

proc getElementValueFullString*(docType: DocumentType, line: string, lineElementId: string): string =
   assert line[0..1] == lineElementId[0..1]
   let lineType = docType.getLineTypeForFullLine(line)
   let leType = lineType.getLineElementType(lineElementId)

proc getElementValueString*(docType: DocumentType, line: string, lineElementId: string): string =
   result = stripBlanks(getElementValueFullString(docType, line, lineElementId))

proc getElementValueString*(line: string, leType: LineElementType): string =
   result = stripBlanks(getElementValueFullString(line, leType))

# Inhalte anlegen und ändern

## Ablage

`items/<id>.json`: Gegenstandstyp und Einheit.
`recipes/<category>/<id>.json`: genau ein Herstellungsverfahren je Datei.
`workflows/<id>.json`: geordnete Arbeitsvorlage.
`knowledge/<id>.json`: individuell erlernbare Verfahrenskenntnis.
`stations/<id>.json`: Arbeitsplatztyp und parallele Kapazität.
`environment/<id>.json`: Prozessbedingungen.
`crops/<id>.json`: Wachstumsdefinition, kein Craftingrezept.
`operations.json`: Registry der Workflow-Operationen; zunächst alle unimplementiert.
`scenarios/`: Testausstattung, ausdrücklich kein globaler Gratisbestand.

IDs bleiben unabhängig vom Dateipfad stabil, beispielsweise `recipe.boil_water`.
Dateien sind UTF-8 und nutzen JSON ohne Kommentare. Erklärungen stehen in
`notes_de` oder der zugehörigen Dokumentation. Dezimalpunkt, keine lokalisierten
Zahlstrings. Anzeigenamen sind nicht als Fremdschlüssel zulässig.

## Neues Rezept

1. Prüfen, ob überhaupt ein Rezept oder ein zustandsbehaftetes System nötig ist.
2. Vorhandene Itemtypen und Fähigkeiten wiederverwenden; neue Items separat anlegen.
3. Genau eine Wissensdefinition ergänzen oder bewusst gemeinsame Kenntnis referenzieren.
4. Rezept in passender Kategorie mit Mengen, Werkzeugen, Station und Phasen anlegen.
5. Materialquellen und verfügbare Werkzeuge prüfen. Ein Rezept ist nicht erreichbar,
   nur weil sein JSON korrekt ist. Handel/Szenarioimporte ausdrücklich dokumentieren.
6. `python3 tools/validate_content.py` ausführen.
7. Rezeptkatalog regenerieren: `python3 tools/validate_content.py --catalog`.
8. STATUS/CHANGELOG aktualisieren; Spielbarkeit erst nach Laufzeittest behaupten.

Beispiel zum Lesen: `recipes/food/boil_water.json`; passiver Prozess:
`recipes/pottery/dry_pot.json`; mehrstufige Lieferkette: Flachs → Faser → Garn → Gewebe.

## Schemata und Prüfer

`schemas/*.schema.json` sind geschlossene JSON-Schema-Dokumente (Draft 2020-12).
Der mitgelieferte Standardbibliotheksprüfer implementiert nur die hier genutzten
Keywords: type, properties, required, additionalProperties, items, minItems,
minimum, maximum, exclusiveMinimum, enum, const, pattern. Unbekannte Schema-Keywords
werden als Fehler behandelt, nicht ignoriert. Kein allgemeiner JSON-Schema-Ersatz.
Zusätzlich geprüft: eindeutige IDs, Referenzen, Fähigkeiten, Phasen, diskrete Mengen,
positive Dauern und grundlegende Versorgungspfade. Diese Pfadprüfung ist eine
optimistische Erreichbarkeitsanalyse aus Szenario- und Importquellen, kein Spieltest.

## Spätere Erweiterungen

Schemas bewusst weiterentwickeln statt neue Sonderfälle in Namen zu verstecken.
Optionale Materialfilter, phasenbezogene Werkzeuge, Pflegeintervalle und reale
Gefäßkapazitäten brauchen Vertrag, Validator und Laufzeitcode zusammen.
Datendefinitionen selbst verändern keine Mechanik. Save-Schemaversion und
Content-Schemaversion sind getrennte Zähler.

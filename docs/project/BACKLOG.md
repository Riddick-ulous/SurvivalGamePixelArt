# Backlog und Abnahme

Alle Einträge offen. In Reihenfolge bearbeiten; nicht alle Inhaltsketten parallel
implementieren. Nach jeder Stufe einen überprüfbaren Commit erzeugen.

| ID | Aufgabe | Abhängigkeit | Fertig, wenn … |
|---|---|---|---|
| T01 | .NET-Solution, Core, Headless, Tests und Godot-Hülle | keine | versionierte Toolchain; Core/Headless bauen; leeres Fenster startet |
| T02 | Contentloader und typisierte Definitionen in C# | T01 | alle vorhandenen Definitionen laden; ungültige Referenz verständlich abgewiesen |
| T03 | Identitäten, Inventar, Eigentum, Behälter und Reservierungen | T02 | Split/Merge erhält Menge und Besitzer; keine doppelte Reservierung; Überfüllung abgewiesen |
| T04 | Uhr, Scheduler, Rezeptjob, Werkstück und Feuer-Minimalmodell | T03 | Abkochen verbraucht echtes Wasser/Brennstoff, bindet Topf und erzeugt Ergebnis einmal; Pause/Abbruch korrekt |
| T05 | Zwei Personen, Bedürfnisse, Wege und kleine Autonomie | T04 | Wasser/Holz/Schlaf selbstständig, keine Endlosschleifen; unterschiedliche Präferenzen erkennbar |
| T06 | Darstellung und Inspektor | T05 | Tätigkeiten, Bestände und Blockaden sichtbar; Eingaben gehen durch Core-Regeln |
| T07 | Save/Load und Migration v1 | T04 | Speichern mitten in aktiver/passiver Arbeit; Fortsetzen ohne Mengensprung oder verlorene Reservierung |
| T08 | Stabiler Haushalt, soziale Hilfe und Langlauf | T05,T06,T07 | zehn Spieltage in mehreren Seeds, Wetter-/Werkzeugstörungen, eine selbst initiierte soziale Handlung |
| T09 | Landwirtschaft mit Weizen/Flachs | T08 | Saatverbrauch, Wachstum unter Umweltbedingungen und begrenzte Ernte nachgewiesen |
| T10 | Haushalte, Rechte, Markt und Reisen | T08 | atomarer Tausch, Verpflichtungen und echte Transportzeit |
| T11 | Entfernte Fortschreibung und Skalierung | T10 | Mengen/Identitäten über Detailwechsel erhalten, vergleichbare Versorgung innerhalb definierter Toleranz |
| T12 | Optionales Gesprächsmodell | T10 | ausgeschaltet voll spielbar; widersprüchlicher Vorschlag ohne Zustandsänderung abgewiesen |

## Kritische fachliche Tests

- Zwei Akteure reservieren denselben Topf: genau einer bekommt ihn.
- Abbruch vor Beginn: Eingaben zurück. Abbruch nach Transformation: Werkstück bleibt.
- Laden kurz vor Abschluss: Ergebnis wird insgesamt genau einmal erstellt.
- Regen unterbricht Trocknung; erneutes Betrachten beschleunigt sie nicht.
- Brennstoff wird nie gleichzeitig von Rezept und Feuer doppelt abgebucht.
- Gesalzene Haut kann eingeweicht werden, erzeugt aber kein kostenloses Leder.
- Planer findet Material nur aus bekanntem, erlaubtem und erreichbarem Bestand.
- Feld kann ohne Saatkohorte nicht geerntet werden; wiederholte Ernte dupliziert nichts.
- Defekte oder fehlende Definitionen blockieren Laden mit Dateipfad/ID und Ursache.

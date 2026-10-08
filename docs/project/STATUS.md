# Implementierungsstand

Stand: 2026-10-08. **Design- und Datenbasis; noch kein Spiel.**

| Bereich | Stand | Nachweis / nächster Schritt |
|---|---|---|
| Ursprüngliches Spielkonzept | übernommen | docs/game-concept-v02.md |
| Technische Architektur | spezifiziert | docs/architecture/technical-design.md |
| Rezepte, Items, Workflows, Pflanzen | definiert | content/core; Validatorausgabe |
| Schemata / Inhaltsprüfer | implementiert | tools/validate_content.py |
| Prüfer-Regressionstests | implementiert | tests/content/test_validator.py |
| Git | initialisiert, initialer Commit | git log; kein Remote |
| Godot-/C#-Projekt | offen | T01 |
| Inventar, Eigentum, Reservierung | spezifiziert | T03 |
| Produktionslaufzeit | spezifiziert | T04 |
| Survival und autonome Figuren | Zielbild | T05 |
| UI, Grafik, Audio | offen | T06 |
| Speichern/Laden | spezifiziert | T07 |
| Entfernte Welt, Markt, Farming, LLM | geplant | T09–T12 |

Testergebnisse dieses Standes: siehe VALIDATION.md. Keine Aussage über Spiel-FPS,
Simulationsleistung, zehn überlebte Spieltage oder C#-Kompilierbarkeit vorhanden.

Statusvokabular: `defined` = Daten/Vertrag vorhanden, `implemented` = Code vorhanden,
`verified` = benanntes Abnahmeszenario bestanden. Nicht gleichsetzen.

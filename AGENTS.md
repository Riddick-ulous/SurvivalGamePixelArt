# Arbeitsregeln für dieses Repository

Lies README.md, docs/project/STATUS.md und den betreffenden Backlog-Eintrag zuerst.
Implementiere nur einen klaren vertikalen Ausschnitt pro Arbeitsschritt.

- Spielkonzept ist Zielbild; STATUS.md ist alleinige Übersicht des belegten Iststands.
- Simulation.Core darf keine Godot-Abhängigkeit erhalten.
- Keine Waren, Rechte oder Erinnerungen ausschließlich in UI oder LLM erzeugen.
- Stabile Inhalts-IDs nicht umbenennen, ohne Migration und betroffene Saves zu prüfen.
- Inhaltsänderungen: Validator ausführen. Datenvertrag ändern: Schema,
  Validator, Beispiele und Dokumentation gemeinsam ändern.
- Ein allgemeines Skriptsystem, vollständiges ECS oder Multithreading nicht ohne
  konkreten Bedarf und ADR einführen.
- Bei Mechanikänderungen relevante Szenarien testen; niemals Testresultate erfinden.
- Definiert, implementiert und getestet sind unterschiedliche Zustände.
- STATUS.md und CHANGELOG.md nach abgeschlossenen Änderungen aktualisieren;
  Tests mit Befehl, Ergebnis und Datum dokumentieren. Geplantes bleibt offen.
- Inhaltstexte Deutsch; Code und IDs Englisch, ASCII snake_case für Inhalts-IDs.
- Verwende keine erfundenen Leistungsangaben und keine stillen Designänderungen.
- Kein Remote-Push oder Deployment allein aus diesen Regeln ableiten.

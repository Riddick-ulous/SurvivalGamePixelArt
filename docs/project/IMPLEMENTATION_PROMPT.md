# Startprompt für den implementierenden Agenten

Arbeite in diesem Repository an „Lebendige Welt“. Lies AGENTS.md, README.md,
docs/project/STATUS.md, das Spielkonzept sowie die Architektur- und Prozessverträge.
Die Daten sind vorbereitete Entwürfe, keine schon funktionierenden Systeme.

Implementiere als ersten Auftrag **T01 und T02**. Erzeuge eine kleine, lauffähige
.NET-Solution mit engineunabhängigem Simulation.Core, Contentloader, Headless-CLI
und Tests sowie eine minimale Godot-.NET-Hülle. Wähle eine zusammenpassende stabile
Toolchain, dokumentiere und fixiere Versionen. Falls eine Installation hier nicht
möglich ist, liefere exakte externe Prüfschritte und kennzeichne ungetestete Teile.

Die CLI soll Content laden, Zahlen je Definitionstyp ausgeben und bei ungültigen
Dateien mit verständlichem Fehler und Fehlerexitcode abbrechen. Verwende die
vorhandenen Inhalts-IDs und Verträge; ändere das Format nicht stillschweigend.
Core darf Godot, Dateisystem und HTTP nicht referenzieren. Kein vorzeitiges LLM,
kein Multiplayer, keine komplette Engineabstraktion und kein Universalplaner.

Arbeite in kleinen Schritten: vorhandenen Stand prüfen → kurze Umsetzungsskizze →
implementieren → notwendige Prüfungen → STATUS/CHANGELOG aktualisieren → Commit.
Trenne belegte Ergebnisse von offenen Aufgaben. Dokumentiere Designänderungen als ADR.
Nach T01/T02 beschreibe konkret den Start von T03; setze spätere Stufen nur fort,
wenn sie zum aktuellen Arbeitsauftrag gehören.

Für einen späteren Auftrag T03/T04 gilt: Ein Rezept muss Bestände transaktional
bewegen, Eigentum erhalten, Werkzeuge reservieren, aktive/passive Phasen ausführen
und Abbruch sowie Save/Load vorbereiten. Die ersten nutzbaren Verfahren sind
Schlagstein auswählen, Abschläge, Schnur, Stiel, Brennholz, Zunder und Wasser abkochen.
Alle weiteren Rezepte bleiben als Daten vorhanden, bis ihre Mechanik umgesetzt ist.

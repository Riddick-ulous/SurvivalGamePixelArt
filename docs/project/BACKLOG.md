# Backlog und Abnahme

## Vorrangiges technisches Grafik-Risiko

| ID | Aufgabe | Fertig, wenn ... |
|---|---|---|
| V00 | Vollstaendige unveraenderte Wald-Referenz-PNG in `game/assets/style_reference/current/` ablegen und SHA-256 dokumentieren | Referenz ist als echte Binaerdatei im Git-Branch vorhanden, kein Tileatlas |
| V01 | Minimalen 16x16-m-Godot-Grafikspike aufsetzen | reproduzierbare 65x65 Vertexhoehen, orthografische Kamera, Dummy-Materialien, editierbare Grube/Huegel |
| V02 | R1 / R2 Terrainmaterial-Verfahren und unabhängige kleine Dekor-Overlays | originale Bilddetails soweit moeglich erhalten, keine 32x32-Kachelpflicht |
| V03 | R0/R1/R2 gegen referenzierten Bildausschnitt und A/B/C-Hoehenzustand vergleichen | Gates G1-G6 des Spike-Dokuments mit echten 1x/4x Screenshots und explizitem Go/No-Go |

**Entscheidung:** Ohne bestandene visuelle Pruefung keine grossflaechige Wasser-/Höhlenimplementierung. Ein schoenes AI-Gesamtbild allein ist nicht ausreichend.

## Spielsimulations-Backlog (bestehende Reihenfolge, vorerst geparkt)

| ID | Aufgabe |
|---|---|
| T01 | .NET-Solution, Core, Headless, Tests und Godot-Huelle |
| T02 | Contentloader und typisierte Definitionen in C# |
| T03 | Inventar, Eigentum, Reservierungen und Behaelter |
| T04 | Uhr, Scheduler, Rezeptjob und Feuer |
| T05 | Personen, Beduerfnisse, Navigation, kleine Autonomie |
| T06 | Darstellung und Inspektor |
| T07 | Save/Load und Migration |
| T08 | Haushalt, soziale Hilfe und Langlauf |
| T09 | Landwirtschaft |
| T10 | Haushalte, Rechte, Markt und Reisen |
| T11 | Entfernte Fortschreibung und Skalierung |
| T12 | Optionales Gespraechsmodell |

Detaillierte Funktionsvertraege in docs/architecture/technical-design.md und docs/architecture/process-contract.md bleiben gueltig, soweit ADR 0003 sie nicht ersetzt.

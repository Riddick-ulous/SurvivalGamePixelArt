# Implementierungsstand — 2026-10-09

**Branch:** experiment/heightfield-pixelart-renderer. Design-/Datenbasis, keine lauffaehige Welt oder fertige 2,5D-Grafik.

| Bereich | Stand | Nachweis / naechster Schritt |
|---|---|---|
| Spielkonzept, Inhaltsdefinitionen | vorhanden | docs/game-concept-v02.md, content/core |
| Inhaltsvalidator / Python-Tests | im Repo implementiert | tools/validate_content.py; tests/content/; in diesem Aenderungslauf nicht erneut ausgefuehrt |
| Hybrides Heightfield + Untergrund-Architektur | als ADR definiert | docs/decisions/0003-hybrid-terrain-renderer.md |
| Material- und Pixel-Art-Renderer | **nicht implementiert** | docs/design/terrain-rendering-spike-v0.1.md |
| Aktuelle freigegebene Referenzgrafik | Transfer offen | game/assets/style_reference/current/README.md; keine behauptete PNG-Binaerintegration |
| Verworfene Tilesets / alte Kalibrierung | aus diesem Branch entfernt | History auf main |
| Godot-/C#-Projekt | nicht implementiert | T01 |
| Terrain-Editing / Wasser / Underground | geplant, nicht implementiert | ADR 0003 |
| Weitere Simulation / Inventar / Agents | geplant | docs/project/BACKLOG.md |

Statusbezeichnungen: definiert != implementiert != getestet. Ein Architekturtext ist kein Render-/Performance-Nachweis.

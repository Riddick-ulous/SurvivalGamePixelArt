# Lebendige Welt — Architektur-Experiment Heightfield / Pixel Art

**Branch:** `experiment/heightfield-pixelart-renderer` (Stand 2026-10-09). Eigenstaendig lebende Welt, Survival und Sozial-Simulation bleiben die Spielvision. **Hier existiert noch kein spielbares Godot-Projekt und kein nachgewiesener Rendering-Prototyp.**

## Aktueller Fokus
Nicht mehr aus fertigen Bildern 32x32-Tiles ableiten. Der Weltzustand beschreibt Hoehe, Bodenmaterial, Wasser und Objekte; die Grafik stellt diesen Zustand mit einem hybriden 2,5D-Renderer dar. Die Atmosphaere der zusammenhaengenden Pixel-Art-Waldszene ist die Art-Direction-Referenz, kein bereits verwendbarer Assetatlas.

1. [Spielkonzept](docs/game-concept-v02.md)
2. [Architekturentscheidung ADR 0003](docs/decisions/0003-hybrid-terrain-renderer.md)
3. [Minimales Grafikexperiment und Abnahmekriterien](docs/design/terrain-rendering-spike-v0.1.md)
4. [Referenzstatus](game/assets/style_reference/current/README.md)
5. [Technischer Gesamtentwurf](docs/architecture/technical-design.md)
6. [Status](docs/project/STATUS.md) / [Backlog](docs/project/BACKLOG.md)
7. [Prozessvertrag](docs/architecture/process-contract.md) / [Contentpflege](docs/content/authoring.md)

## Bereits ausfuehrbar
Nur Inhaltsvalidierung und die vorhandenen Python-Unittests; keine Gameplay- oder Grafikausfuehrung:

```sh
python3 tools/validate_content.py
python3 -m unittest discover -s tests/content -v
```

## Bewusst nicht im Branch
Fruehere Tile-Extraktionen, Sprite-Kalibrierungen und Produktionsplaene, die ein Atlas-System als Architekturgrundlage voraussetzen. Die Originalhistorie bleibt auf `main` erhalten. Die bereits im Chat vorhandene freigegebene vollstaendige Landschafts-PNG wurde noch **nicht** binaer nach GitHub uebertragen; vor einer formalen visuellen Abnahme nachholen. Neue Photoshop-/KI-Bilder gelten nicht als Renderbeweise.

## Lizenz
Keine Open-Source-Lizenz festgelegt; eine oeffentliche Repo-Sichtbarkeit begruendet keine freie Wiederverwendung.

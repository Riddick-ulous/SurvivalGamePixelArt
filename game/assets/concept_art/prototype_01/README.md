# Grafikdesign-Prototyp 01 – Lebendige Welt

Stand: 2026-10-09. Neun unveränderte PNG-Originale der ersten Pixel-Art-Konzeptstudie.

Der Stil orientiert sich am bodenständigen, gemäßigt-mitteleuropäischen Spielkonzept:
mittelalterliche Alltagsfiguren, naturnahe gedeckte Farben, Gras-/Waldboden,
Binnengewässer, Lagerfeuer und Laubbäume.

**Status:** reines Grafik-/Stilkonzept, noch **kein** spielfertiges Tileset.
Weder 16-Pixel-pro-Meter-Skalierung, nahtlose Kachelbarkeit, feste Grid-Ausrichtung,
Godot-Import noch Animationen oder Richtungsvarianten sind geprüft.
Die Originalauflösung bleibt bewusst erhalten; spätere Verarbeitung ist eine
eigenständige Iteration. Eine Godot-Spielimplementierung existiert noch nicht.

## Originaldateien

| Motiv | Datei | Pixelmaß | Hintergrund |
|---|---|---|---|
| Person, männlich | [characters/villager_male.png](characters/villager_male.png) | 1024 × 1536 | Alpha |
| Person, weiblich | [characters/villager_female.png](characters/villager_female.png) | 1024 × 1536 | Alpha |
| Grasboden | [terrain/grass.png](terrain/grass.png) | 1254 × 1254 | Undurchsichtig |
| Waldboden, Laub/Moos | [terrain/forest_floor.png](terrain/forest_floor.png) | 1254 × 1254 | Undurchsichtig |
| Teichwasser | [terrain/water.png](terrain/water.png) | 1278 × 1230 | Undurchsichtig |
| Gras-/Wasser-Ufer | [terrain/grass_water_shore.png](terrain/grass_water_shore.png) | 1254 × 1254 | Undurchsichtig |
| Lagerfeuer | [props/campfire.png](props/campfire.png) | 1312 × 1199 | Alpha |
| Junger Laubbaum | [vegetation/tree_young.png](vegetation/tree_young.png) | 1024 × 1536 | Alpha |
| Große Eiche | [vegetation/tree_oak_large.png](vegetation/tree_oak_large.png) | 1122 × 1402 | Alpha |

## Nächste Grafikiteration

- Bildmaßstab der 1-m-Weltzellen (nominell 16 px) und Sprite-Größen abstimmen.
- Terrain-Flächen tatsächlich auf nahtlose Wiederholung sowie Übergänge prüfen.
- Transparenz, freie Sprite-Ränder, Schatten und Bodenanker definieren.
- Für Spielfiguren Ansichten/Laufrichtungen und Animationsphasen erarbeiten.
- Erst nach Stilfreigabe Godot-Import- und Atlasstrategie festlegen.

Alle neun Dateien wurden binär übertragen und mittels Git-Blob-SHA gegenüber
den wiederhergestellten Originalen abgeglichen.

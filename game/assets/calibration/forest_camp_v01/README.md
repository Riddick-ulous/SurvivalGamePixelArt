# Waldcamp – technisches Kalibrierset v0.1

**Status: unfreigegebener technischer Pixeltest**, keine Art-Direction-Freigabe. Die Bilder sind einzelne native PNGs, nicht aus der freigegebenen Konzepttafel ausgeschnitten. Erzeugt zur Prüfung des 32×32-Rasters, der verschiedenen Bildmaße und der Layer-/Fußanker-Konvention.

## Enthalten
- `assets/terrain_grass_01.png` — 32×32 RGBA, Gras.
- `assets/terrain_forest_floor_01.png` — 32×32 RGBA, Waldboden.
- `assets/char_villager_a_front_idle_f00.png` — 32×32 RGBA, vollständige frontale Figur.
- `assets/tree_oak_large_01.png` — 128×144 RGBA, mehrzelliges Baumobjekt.
- `assets/campfire_on_01.png` — 48×48 RGBA, Standbild Lagerfeuer.

Die beiden Terrain-Tiles wurden mit aneinander angeglichenen Außenkanten konstruiert. Das garantiert noch **keinen** natürlich wirkenden großflächigen Terrainmix; Variante, Pixelästhetik, perspektivische Größenverhältnisse und Wiederholungsmuster müssen am tatsächlichen Szenenaufbau geprüft werden. Die Bilder sind bewusst einfach und besitzen noch **nicht** die Bildqualität der freigegebenen Waldcamp-Studie.

## Nächste Schritte
1. Freigegebene Masterreferenzen originalgetreu ins Git übertragen und per SHA-256 verifizieren.
2. Kalibrierblatt/Mosaike in nativer Auflösung aus diesen PNGs aufbauen.
3. Perspektive, Figurenhöhe und vegetative Detaildichte vergleichen und überarbeiten.
4. Erst nach Stilabnahme weitere 69 P0-Assets gemäß [Assetliste](../../../../docs/design/forest-camp-asset-list-v0.1.md) erstellen.

**Kein** Godot-Projekt, keine Kollision, keine Steuerung, keine Simulation, keine Animationsimplementierung.

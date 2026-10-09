# ADR 0003 — Hybride Heightfield-Welt und Pixel-Art-Renderer

Status: angenommen fuer experimentellen Branch, 2026-10-09. Ersetzt die rein tilebasierte Terrain-Produktionsannahme, **nicht** das Spielkonzept oder die Wahl Godot 4 .NET/C# aus ADR 0001.

## Trennung
- Autoritativ ist ein engineunabhaengiger Weltzustand in Simulation.Core; Renderer duerfen ihn nicht veraendern.
- Weltkoordinaten sind metrisch. Ein 1-m-Gameplayraster kann bestehen bleiben; Terrain verwendet zunaechst 0,25 m Raster, optional spaeter adaptiv. **32 px/m ist lediglich ein noch nicht validierter visueller Orientierungswert**, kein Speicherformat.
- SurfaceChunk: 32 x 32 m, 128 x 128 Zellen, Integerhoehen relativ zum Chunk, Substrat und Deckschicht. Chunk-Grenzen teilen sich konsistente Hoehen-Samples (129 x 129 Vertices), keine duplizierten auseinanderlaufenden Randwerte.
- Oberflaechengelaende als 2,5D-Heightfield; Material ist kein Bild-Tile. Untergrund als getrennte Hoehen-/Raumregionen mit Portalen; spaeter optional lokale volumetrische Zellen fuer frei gegrabene Tunnel. Keine Behauptung beliebiger 3D-Tunnel mit blossem Heightfield.
- Wasser als separates konservatives Zellvolumen mit gerichteten Randfluessen; nie Wasser als Teil des Terrain-Heightfields behandeln. Trockene/ruhende Chunks koennen pausieren; Grenzfluss bilanziert beim Reaktivieren.
- Objekte als persistente Entitaeten mit Fussanker und Interaktion. Feinste Dekoration ist deterministisch visualisiert und nicht automatisch jedes einzelne Grasblatt ein Entity.
- Commands: TerrainEdit (Position, Radius, Aenderung, Actor, erwartete Revision), validierte Materialbilanz; DirtyRegions fuer Mesh, Kollision, Navigation, Hydrologie, Vegetation und Rendering.
- Godot 4 .NET: Orthografische 3D-Projektion und dynamisches Heightfield-Mesh, Material-Shader, instanzierte Sprites/Geometrie, Wasserlayer, kontrollierte Pixelausgabe. Simulation.Core bleibt ohne Godot.
- Geometrie, Biome/Materialgewichte, Hydrologie, Objekte und Darstellung sind getrennte Systeme. World seed + persistente Deltas; geaenderte Chunks koennen zu Snapshots verdichtet werden.

## Harte offene Risiken
1. Die Referenz zeigt eine kohärente **illustrative** Pixelart-Szene; ein 3D-Mesh mit Pixel-Shader reproduziert sie nicht automatisch.
2. Bildtexturen und Sprites muessen perspektivisch, skalen- und lichtkonsistent sein.
3. Shader-Detail darf bei wechselnder Hoehe und Kamerazoom weder schwimmen noch unkontrolliert filtern.
4. Wasservolumenerhaltung und Chunk-Uebergaenge benoetigen separate Physiktests.
5. Hoehenabtastung und 1-m-Gameplayraster brauchen explizite Navigation/Kollision-Mappings.

## Entscheidungstor
Keine Produktions-Assetpipeline, kein grosses Tileset und keine grosse Weltimplementierung vor bestandenem visuellen Terrain-Spike: siehe ../design/terrain-rendering-spike-v0.1.md.

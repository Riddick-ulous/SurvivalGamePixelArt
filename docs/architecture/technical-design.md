# Technischer Gesamtentwurf — Einordnung Rendering-Architektur

Der bestehende Entwurf (Godot 4 .NET + C#, engineunabhaengiger `Simulation.Core`, Headless-Tests, Content-Prozesse, Commands, Scheduler, Persistenz und Agenten) bleibt die Grundlage. Fuer Raum und Darstellung gilt aber ab diesem Experiment **vorrangig [ADR 0003](../decisions/0003-hybrid-terrain-renderer.md)**.

## Geaenderte Abgrenzung
- Statt reiner 2D-Tilemap nutzt die Darstellung ein dynamisches Heightfield-Mesh in orthografischer 3D-Projektion mit Pixel-Art-Materialen, getrennten Sprites und Wasseroberflaeche.
- `GridPosition(x,y,level)` bleibt fuer das gameplayseitige grobe Raster zulaessig; die reale Terrainoberflaeche wird in Metern plus Hoehenwerten abgebildet.
- Der erste 0,25-m-Terrain-Sampler ist **nicht** gleichzusetzen mit einem 0,25-m-Entity/Pathfinding-Raster; Maps muessen explizit projiziert werden.
- 32 px/m war ein moeglicher visueller Massstab, keine Vorgabe fuer Vertexdichte oder Tileformat.
- WorldCommand/WorldEvents bleiben zentral. Terrain-Edits pruefen Material- und Geometriemengen, invalidieren Hydrologie/Kollision/Navigation/Renderbereich atomar.
- Untergrundraeume als getrennte Regionen mit Portalen; keine Zusage beliebiger Voxel-Grabfreiheit.
- Wasser ist separates Volumen; physikalisch konservativer Transport unabhaengig von Material-Shadern.

## Reihenfolge
**Vor vollstaendigem Spielgeruest**: kleiner isolierter Render-Spike nach [Versuchsplan](../design/terrain-rendering-spike-v0.1.md). Erst bei sichtbarem Qualitaetsnachweis Implementierung eines dauerhaften Terrain-Systems. `Simulation.Core` darf weiterhin keine Godot-Abhaengigkeit enthalten.

Alle anderen technischen Systeme (Zeit, Content, Inventar, Produktion, Agenten, Save) sind weiterhin **geplant, nicht implementiert**. Originalhistorie kann ueber `main` eingesehen werden.

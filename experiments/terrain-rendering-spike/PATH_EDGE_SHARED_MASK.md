# Shared path boundary — terrain / material synchronization

The old R7.2 used independent, divergent functions for the raised grass sod and the visible material boundary. This revision creates a **single signed-distance mask** in world coordinates, 512×512 pixels over the 16×16 m terrain. Both the heightfield CPU sampling and R7.2 shader use that **same mask**, with bilinear interpolation. The mask is generated at startup, not AI-generated.

- Encoded signed distance: red = clamp((distance_m + 2)/4, 0, 1); negative is path, positive is grass.
- CPU: bilinear lookup of the Image for mesh vertex heights.
- GPU: linear-filtered sampler of the matching ImageTexture for material zones.
- Terrain height still uses a shallow worn path and a small raised turf lip; the material's root and earth strips use the same signed distance.
- R7.1 (9) remains an unchanged visual comparison; R7.2 (0) uses the shared mask.
- Geometry remains 128×128 (12.5 cm spacing). Mask is finer (3.125 cm per texel), so sub-vertex edge detail cannot be represented as actual mesh relief. This is an explicit LOD limitation, not an alignment mismatch.

Validation in Godot: 0 + A + Z, inspect path edge, compare 9; then B to inspect excavation. Runtime not executed here.

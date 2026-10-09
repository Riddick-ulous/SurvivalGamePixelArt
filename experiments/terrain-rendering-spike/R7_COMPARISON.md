# R7 — lit square excavation and turf edge

Key **8** selects R7; key **7** retains R6 baseline. **B** excavates, **A** shows natural path, **Z** toggles close camera, **Q/W/E** change pitch.

- 128x128 terrain cells in R7 (12.5 cm), while R0-R6 keep 64x64.
- Square signed-distance excavation with mild irregularity, 1.1m deep, approximately 0.52m bank transition and relatively flat floor.
- Mesh normals from centered height derivatives; DirectionalLight3D and shadows with ambient fill. R0-R6 keep their previous unlit look via emission.
- Dominant-axis side projection on excavated soil slopes, 1.5m texture period. Grass keeps original world XZ mapping.
- Signed-distance grass/path boundary with a narrow darkened turf lip (about 13cm). This is a shader-based edge, **not yet a separate cutout sprite or physically raised turf mesh**.
- R5 grass A/B stochastic choice retained.

**Known limitations:** no persistent underground simulation, overhangs, root decals, or actual geometry for the turf lip. Lighting and shader behavior have **not** been runtime-tested under Godot 4.7.2; verify parser and screenshots. Compare R6+B and R7+B at 45 degrees and close zoom, plus R6+A/R7+A wide.

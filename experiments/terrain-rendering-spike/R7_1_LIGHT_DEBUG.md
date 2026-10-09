# R7.1 — lighting and texture-scale diagnostics

**Keys:** 9 = R7.1, 8 = R7 baseline, B = excavation, Z = near view.
In R7.1 only: **L** cycles (0) textured + lit, (1) texture unlit via emission, (2) RGB world-space normals, (3) pure white lit terrain. **H** toggles directional shadows (default OFF), **J** flips the sun to a second direction. **S** saves screenshots.

A **white reference cube** is placed near the pit, using Godot StandardMaterial3D, to distinguish scene-light problems from terrain-shader problems. It is hidden in R0–R7.

Fixes:
- Side-wall texture UVs use the **same 8m per repeat** as the horizontal soil texture (formerly 1.5m), eliminating the 5.3x scale mismatch. This does not automatically fix all slope distortions or repetition.
- Side-projection axis is selected from the actual interpolated mesh normal, transformed from view space, rather than screen-space derivative cross products.
- Directional sun intensity increased to 1.8, ambient fill to 0.8, and shadows default OFF in R7.1 to isolate light response.
- R7.1 reuses R7's excavation geometry, turf lip and R5 stochastic grass choice; R7 remains available as a baseline.

Test order: 9+B+Z -> L through all four modes -> H on/off -> J direction. If the cube changes brightness with J but the terrain does not, inspect shader/normal transforms. If normal RGB is nearly uniform despite steep walls, inspect mesh normals. Once light works without shadows, enable H and evaluate occlusion.

**Validation:** changes are source-level only until run in Godot 4.7.2. Do not interpret these as a confirmed visual fix.

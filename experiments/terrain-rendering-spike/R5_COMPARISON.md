# R5 – Stochastic material selection + near camera

**Purpose:** compare R4 (key 5) to R5 (key 6) using exactly the same three real PNG materials. No newly invented textures and no changes to R4 shader behavior.

## R5 shader
- Grass A/B are selected per fragment using correlated world-space noise at ~0.65m and ~0.25m scales, with a minor world-anchored hash component.
- Soil/grass coverage uses the existing interpolated terrain material weight, plus coarse and medium organic perturbations and pixel-sized stochastic threshold jitter. This produces protrusions and small islands along the boundary.
- **No alpha/RGB color interpolation between materials**; each fragment displays an original source texel sampled with nearest-neighbor filtering.
- Shared world-space texture coordinates keep source-image texture alignment independent of grass selection and terrain deformation.
- These masks are a controlled baseline, not guaranteed visually optimal or seamlessly tiled textures. A/B source-image repeats still exist every 8m.

## Camera
- **Z** toggles wide view (orthographic size 23, whole 16m field) and close view (orthographic size 5.7, approximately 4m central ground region at 45-degree pitch). Actual visible ground area varies with pitch and window aspect ratio.
- **Q/W/E** change pitch, **A/B/C** change terrain shape, **S** saves screenshot with mode, case, pitch and zoom encoded in filename.
- Compare R4 vs R5 at wide and close zoom using identical conditions; record seams, blur, edge quality and grube slope legibility.

## Prerequisites
Same external three PNGs as R4 in `res://materials/`: `grass_a_256.png`, `grass_b_256.png`, `soil_256.png`. The PNGs are not in this commit. If missing, R4/R5 fall back to R3 with warning.

## Validation status
Source committed; Godot 4.7 runtime and visual A/B screenshots **not yet tested**. Evaluate with actual Godot output before considering the blending successful.

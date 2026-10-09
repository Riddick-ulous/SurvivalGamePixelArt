# R7.2 — mesh face orientation / normal correction

Key **0** selects R7.2; **9** selects R7.1. Use **B**, **Z** and cycle **L** for normal diagnostics (mode 2) and white-lit terrain (mode 3). **J** flips light direction, **H** toggles shadows.

**Fix:** Reverse triangle index winding from `[a,c,b,b,c,d]` to `[a,b,c,b,d,c]`. Godot uses clockwise front-facing triangle convention; the old index order caused the terrain to be treated as back-facing from above under `cull_disabled`. In fragment lighting, the back-face normal can be reversed even when supplied vertex normals point upward, consistent with the observed magenta (-Y) debug view. Explicit vertex normals remain computed from centered height differences, pointing +Y on flat terrain. The R7.1 wall texture scaling and debug tools are unchanged.

**Important:** Mesh winding is shared by all modes in the spike, not only R7.2. This affects face orientation across R0–R7.1, although unshaded modes should visually remain similar. To isolate shading changes, compare **9** and **0**; both now use corrected winding, so old screenshots serve as the pre-fix baseline.

**Expected checks:** In debug mode 2, flat terrain should appear approximately RGB (0.5,1.0,0.5) = light green, not magenta. Opposing walls should show different normal colors. In white-lit mode 3, flat terrain should receive direct sunlight, with wall brightness changing as **J** changes sun direction. The white reference cube should behave consistently.

**Status:** source change only; Godot runtime not available in this execution. Do not consider the fix visually verified until the normal and white-lit screenshots are inspected.

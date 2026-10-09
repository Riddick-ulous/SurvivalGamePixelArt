# R7.3 — adjustable lighting and defined grass/path edge

R7.2 remains the active mode on **0**, with the improved edge implemented there. Existing 8/9 modes are preserved for shader comparison (the winding fix is shared).

## Lighting controls
- Inspector export `sun_energy` default **0.95** (was 1.8).
- Inspector export `ambient_energy` default **0.45** (was 0.8).
- In game: **T/Y** lower/raise sunlight by 0.15, **G/U** lower/raise ambient by 0.10.
- The current numerical values appear in the on-screen HUD. **J** switches light direction, **H** toggles shadows, **L** cycles debug views.
- Settings affect R7, R7.1 and R7.2; old R0–R6 still use emission for comparable unlit appearance.

## Path edge
The path is still an analytic world-space signed-distance field, not a spline/pathfinding system. R7.2 now has **four separately defined edge features**, without blurring source images:
1. 11.5cm darkened compacted soil band just inside the path.
2. 10.5cm dark turf/root band immediately outside the path.
3. Patchy exposed-soil interruptions inside the turf band.
4. Sparse grass tufts protruding up to ~8.5cm onto the path.

These are material regions in the shader, **not a raised 3D sod mesh or sprite assets**. They do not alter excavation geometry, wall projection, or the grass A/B selection.

## Test
1. Press **0**, **A**, **Z** and inspect the path edge; switch to **8** for the older edge comparison.
2. Press **B** and inspect the unchanged pit with the new lighting defaults.
3. Adjust **T/Y** and **G/U** separately; record the chosen values shown in HUD.
4. Use **L** normals / white material if light response looks incorrect.

Not runtime-tested under Godot 4.7.2. Screenshot review is required before calling the edge aesthetically successful.

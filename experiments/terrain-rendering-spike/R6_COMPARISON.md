# R6 — Excavation and path boundary study

R6 is selected with **7**, R5 baseline remains **6**. Use **Z** to toggle the ~4m close camera and **B** to excavate.

### Changes
- R5 grass A/B stochastic mixing is copied without modifying its coefficients.
- Grass/soil path border is recomputed in fragment world-space: larger center/width variations, mid-scale islands and pixel-scale threshold noise. Unlike R5 this can visibly change the large-scale path silhouette.
- For R6+B only, a deeper excavation has a relatively flat floor and a shorter bank. The depth field is passed as interpolated vertex color green channel.
- Excavation exposure replaces grass with soil where depth exceeds 0.13m. This is a rendering-only depth criterion, not an implementation of soil-layer persistence.
- Bank soil uses a world-space side projection, blended according to the actual world-space surface normal computed with screen derivatives. Side-projection is **only** applied to soil; grass remains world XZ-projected on the surface.
- Slope darkening increases legibility of the depression. No soft RGB blending across the grass/soil material border.

### Comparison matrix
R5+A wide, R6+A wide (path silhouette); R5+B close, R6+B close (exposure, side projection); R6+B at pitches Q/W/E. Same three R4 material PNGs required.

### Known limitations
- Heightfield geometry cannot represent overhangs or vertical cliffs. Excavation has no volumetric mass conservation or persistent underground layers.
- Surface-normal estimation uses screen-space derivatives and may alias at mesh edges. A future mesh normal pass and pixelated directional lighting may be preferable.
- A thresholded exposure depth can show a crisp contour; no separate turf-edge decals yet.
- The grass/soil path still follows a predefined centerline; it is not an authored road network.
- **Not yet run under Godot 4.7 or visually approved.** Compare actual screenshots before tuning parameters.

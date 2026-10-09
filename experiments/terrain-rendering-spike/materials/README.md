# R4 — Real material images in Godot

R4 adds **key 5** to the original R0–R3 Godot spike. It uses three genuine generated source-material derivatives from the previous experiment: grass A, grass B and soil. **The three binary PNGs are distributed separately as a downloadable material bundle, not committed by this change.** Without them the project still opens and R0–R3 run, while R4 warns and falls back to R3.

## Installation
Copy these three exact filenames into `experiments/terrain-rendering-spike/materials/`:
- `grass_a_256.png`
- `grass_b_256.png`
- `soil_256.png`

Import the project in Godot 4.7, start it, press **5** for R4; **A/B/C** natural/excavation/mound; **Q/W/E** pitch 35/45/55; **S** screenshot. Set import filtering to nearest if desired; shader sampling is already nearest.

## Explicit limitations
- Each 256px texture is interpreted as **8 x 8 meters** (32 source px/m). This is an *assumption*, not a validated physical scale.
- Grass A and B are selected by 8m world cells. This makes variations easy to see but can introduce cell-edge seams.
- The prior compiler's periodic edge repair is rudimentary; visually inspect repetition.
- R4 is deliberately **not** a seamless production texture synthesis algorithm.
- Grass/soil boundary is thresholded with 32px/m world-space dithering; no decorative overlays or slope-specific materials yet.
- R4 uses real material images, but no actual runtime screenshot has been captured by the assistant. Visual acceptance pending.

Goal: decide whether the original generated art retains useful detail when displayed on the editable Heightfield at game zoom. No further generation or complex quilting before this test.

# R4 — Material source compiler (not yet a successful art test)

This folder contains a **working offline compiler source** for two independent square material PNGs, **not generated 1024x1024 source assets**. The image-generation result from this iteration was a composite presentation sheet, unsuitable for input: its individual textures are not full-resolution and the lower 'Godot renders' are illustrations. Do not crop it and claim full-resolution textures.

## Workflow
1. Obtain *two genuine separate image files*: grass_1024.png and soil_1024.png, ideally each 1024x1024, overhead orthographic, no large objects, consistent palette, representing 8x8m each.
2. `python -m pip install Pillow`
3. `python experiments/terrain-rendering-spike/material_compiler/compile_materials.py --grass grass_1024.png --soil soil_1024.png --out experiments/terrain-rendering-spike/material_compiler/compiled --meters 8`
4. Inspect generated `grass_repeat_4x4.png` and `soil_repeat_4x4.png` **at 1x and nearest 4x**. Reject prominent seams, repetition, lost detail and excessive color noise.
5. Compare 4m and 8m interpretation using explicit scale metadata; the generator's prompt does not prove metric scale.

The compiler generates 256px material outputs from source with nearest resampling, a narrow periodic boundary repair, repeat diagnostic sheets, SHA256 provenance and scale metadata. It does **not** solve stochastic texture synthesis, guarantee seamlessness, preserve every original detail, or integrate into Godot by itself. Its purpose is to make failure modes measurable before building more rendering code.

## Next gate
Separate original material PNGs, visual acceptance of compiled repeats, then Godot integration with real images (not generated noise). Existing R0-R3 remain independent baseline. Avoid declaring R4 implemented in-engine until images and actual screenshots are verified.

# R7.3 — lighting baseline calibration

R7.2 confirmed correct geometry orientation visually, but textured scene appeared overexposed. R7.3 reduces **light intensity**, not display gamma: sun default 0.80 (was 0.95), ambient default 0.30 (was 0.45). Both are exported for editor tuning and can be adjusted during runtime (T/Y sun, G/U ambient).

The white reference cube is hidden by default; **K** toggles it in R7.1/R7.2. **L** continues to cycle the four light diagnostic views. No modifications to generated texture pixels, material UV scale, geometry or stochastic blending.

Test: select **0** and **B** for R7.2 terrain, compare R7.3 baseline against previous screenshot. Tune T/Y and G/U independently. Brightness is not the same as gamma: exposure/color-management settings and material albedo may still need calibration after lighting is physically consistent.

Note: The R7.2 mode name remains as-is to preserve comparison and keyboard mapping. This commit calibrates the default lighting of the shared R7+ modes.

Source-level validation only; not run in Godot.

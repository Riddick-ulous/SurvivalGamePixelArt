# R7.2 grass edge geometry experiment

This revision addresses the **path-to-grass boundary**, not global lighting.

- Mode **0** (R7.2) adds a world-coordinate raised sod lip (~6.5 cm) adjacent to the path and a shallow worn path depression (~3.5 cm).
- R7.1 (**9**) retains the flat edge for A/B comparison. The R7.2 mesh uses the same 128x128 sampling grid as R7.1; the fine geometry edge is thus approximate and should be evaluated close-up.
- Shader adds a narrow dark root/earth zone, retaining stochastic grass A/B selection, path material, and the excavation.
- R7.2 retains the already corrected mesh winding and lighting debug controls.

**Known limitation:** geometry edge uses a low-cost deterministic trigonometric approximation, whereas the shader's edge uses multi-scale noise. Their boundaries may not coincide exactly. The next iteration should centralize the edge definition in a shared CPU-generated mask/heightfield, or send identical parameters/noise implementation to both stages. This is a visual spike, not final deformable-terrain architecture.

**Test:** press **0**, **A** (natural terrain), **Z** (close view), compare with **9**; then **B** to check the pit. The shallow lip may be subtle because mesh spacing is 12.5 cm and the height step is only 6.5 cm. No image generation was used. Godot runtime not validated.

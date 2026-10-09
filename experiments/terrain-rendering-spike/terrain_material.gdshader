shader_type spatial;
render_mode cull_disabled, depth_draw_opaque, diffuse_lambert, specular_disabled;

uniform int render_mode_id = 0;
uniform float world_scale = 32.0;
uniform float seed = 19.0;
uniform sampler2D r3_atlas : source_color, filter_nearest, repeat_enable;
uniform sampler2D grass_a_tex : source_color, filter_nearest, repeat_enable;
uniform sampler2D grass_b_tex : source_color, filter_nearest, repeat_enable;
uniform sampler2D soil_tex : source_color, filter_nearest, repeat_enable;
uniform float material_meters = 8.0;
uniform int r71_debug_mode = 0;

varying vec3 world_pos;
varying float grass;
varying float cut_depth;
varying float shared_edge;

float hash21(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7)) + seed) * 43758.5453123);
}
float noise2(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f*f*(3.0-2.0*f);
    return mix(mix(hash21(i),hash21(i+vec2(1.0,0.0)),f.x),
        mix(hash21(i+vec2(0.0,1.0)),hash21(i+vec2(1.0,1.0)),f.x),f.y);
}
void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    grass = COLOR.r;
    cut_depth = COLOR.g;
    shared_edge = COLOR.b*4.0-2.0;
}
void fragment() {
    vec2 p = world_pos.xz;
    float g = clamp(grass,0.0,1.0);
    if (render_mode_id == 0) {
        ALBEDO = mix(vec3(0.39,0.25,0.15),vec3(0.30,0.47,0.23),g);
    } else if (render_mode_id == 1) {
        // R1: multi-scale world-space material, smooth organic blend.
        float large = noise2(p*0.7);
        float medium = noise2(p*4.0);
        float fine = noise2(p*17.0);
        vec3 earth = mix(vec3(0.25,0.16,0.10),vec3(0.50,0.34,0.20),0.5*large+0.5*medium);
        vec3 turf = mix(vec3(0.16,0.29,0.12),vec3(0.46,0.55,0.24),0.6*large+0.4*medium);
        float blend = smoothstep(0.26,0.74,g+0.14*(medium-0.5));
        ALBEDO = mix(earth,turf,blend)*(0.90+0.20*fine);
    } else if (render_mode_id == 8 || render_mode_id == 9) {
        // R7.1: same terrain and grass mix as R7, but consistent
        // meters-per-repeat on all projection axes.
        vec2 uv = fract(p/material_meters);
        vec3 turf_a = texture(grass_a_tex,uv).rgb;
        vec3 turf_b = texture(grass_b_tex,uv).rgb;
        float grass_field = 0.64*noise2(p*1.55+vec2(13.7,8.2))
                          + 0.36*noise2(p*4.0+vec2(71.1,19.4));
        float grass_jitter = hash21(floor(p*8.0+vec2(2.0,7.0)))-0.5;
        vec3 turf = mix(turf_a,turf_b,step(0.50,grass_field+0.14*grass_jitter));
        // R7.2: interpolated from the same mesh vertices that define the sod lip.
        // R7.1: keep the original independent shader noise for comparison.
        float signed_edge = shared_edge;
        if (render_mode_id == 8) {
            float center = 6.1+0.85*sin(p.x*0.42);
            center += 0.40*(noise2(vec2(p.x*0.55,11.0))-0.5)*2.0;
            center += 0.20*(noise2(p*0.85+vec2(6.0,17.0))-0.5)*2.0;
            float half_width = 0.62+0.24*(noise2(p*0.75+vec2(34.0,12.0))-0.5)*2.0;
            signed_edge = abs(p.y-center)-half_width;
            signed_edge += 0.15*(noise2(p*2.2+vec2(7.0,3.0))-0.5)*2.0;
            signed_edge += 0.05*(noise2(p*7.0+vec2(4.0,23.0))-0.5)*2.0;
            signed_edge += 0.035*(hash21(floor(p*32.0))-0.5);
        }
        // Explicit world-space path-edge material zones.
        // Keep this mask in sync with the geometry edge in terrain_spike.gd.
        // Signed distance: negative = compacted path, positive = grass.
        // A narrow exposed-earth strip precedes the darker turf root edge.
        float exposed = step(0.11,cut_depth);
        float turf_coverage = step(0.0,signed_edge)*(1.0-exposed);
        float rim_soil = (1.0-step(0.0,signed_edge))*step(-0.115,signed_edge);
        float root_edge = turf_coverage*(1.0-step(0.105,signed_edge));
        float sod_face = (1.0-step(0.0,signed_edge))*step(-0.065,signed_edge);
        // Sparse coarse clumps grow across the edge, but only locally.
        float clump_noise = noise2(p*5.5+vec2(24.0,41.0));
        float tuft = step(0.67,clump_noise)*step(-0.085,signed_edge)* (1.0-step(0.05,signed_edge))*(1.0-exposed);
        // Individual dark soil interruptions within the turf root strip.
        float broken_edge = step(0.71,noise2(p*13.0+vec2(5.0,13.0)))*root_edge;
        // Geometry normals from the mesh (view-space NORMAL) are transformed
        // to world-space, avoiding screen-derivative sign ambiguity.
        vec3 normal_world = normalize((INV_VIEW_MATRIX*vec4(NORMAL,0.0)).xyz);
        vec3 weights = abs(normal_world);
        vec3 earth = texture(soil_tex,uv).rgb;
        vec3 side_x = texture(soil_tex,fract(world_pos.zy/material_meters)).rgb;
        vec3 side_z = texture(soil_tex,fract(world_pos.xy/material_meters)).rgb;
        if (weights.y < max(weights.x,weights.z)) {
            earth = weights.x > weights.z ? side_x : side_z;
        }
        vec3 path_rim = earth*vec3(0.72,0.77,0.68);
        vec3 root_turf = turf*vec3(0.57,0.68,0.47);
        ALBEDO = mix(earth,turf,turf_coverage);
        ALBEDO = mix(ALBEDO,path_rim,rim_soil*0.75);
        ALBEDO = mix(ALBEDO,earth*vec3(0.50,0.57,0.43),sod_face*0.60);
        ALBEDO = mix(ALBEDO,root_turf,root_edge*0.85);
        ALBEDO = mix(ALBEDO,earth*vec3(0.80,0.85,0.72),broken_edge*0.80);
        ALBEDO = mix(ALBEDO,turf*vec3(0.85,0.97,0.70),tuft*0.72);
        ROUGHNESS = 1.0;
        if (r71_debug_mode == 1) {
            // Unlit material diagnostic, independent of all light sources.
            EMISSION = ALBEDO;
            ALBEDO = vec3(0.0);
        } else if (r71_debug_mode == 2) {
            // World-space normals encoded as RGB.
            EMISSION = normal_world*0.5+0.5;
            ALBEDO = vec3(0.0);
        } else if (r71_debug_mode == 3) {
            // Pure white terrain under the actual scene lighting.
            ALBEDO = vec3(1.0);
        }
    } else if (render_mode_id == 7) {
        // R7: retain R5 grass A/B selection, add an explicit path-edge lip.
        vec2 uv = fract(p/material_meters);
        vec3 turf_a = texture(grass_a_tex,uv).rgb;
        vec3 turf_b = texture(grass_b_tex,uv).rgb;
        float grass_field = 0.64*noise2(p*1.55+vec2(13.7,8.2))
                          + 0.36*noise2(p*4.0+vec2(71.1,19.4));
        float grass_jitter = hash21(floor(p*8.0+vec2(2.0,7.0)))-0.5;
        vec3 turf = mix(turf_a,turf_b,step(0.50,grass_field+0.14*grass_jitter));
        float center = 6.1+0.85*sin(p.x*0.42);
        center += 0.40*(noise2(vec2(p.x*0.55,11.0))-0.5)*2.0;
        center += 0.20*(noise2(p*0.85+vec2(6.0,17.0))-0.5)*2.0;
        float half_width = 0.62+0.24*(noise2(p*0.75+vec2(34.0,12.0))-0.5)*2.0;
        float signed_edge = abs(p.y-center)-half_width;
        signed_edge += 0.15*(noise2(p*2.2+vec2(7.0,3.0))-0.5)*2.0;
        signed_edge += 0.05*(noise2(p*7.0+vec2(4.0,23.0))-0.5)*2.0;
        signed_edge += 0.035*(hash21(floor(p*32.0))-0.5);
        float turf_coverage = step(0.0,signed_edge)*(1.0-step(0.11,cut_depth));
        float lip = turf_coverage*(1.0-step(0.13,signed_edge));
        vec3 normal_world = normalize(cross(dFdx(world_pos),dFdy(world_pos)));
        vec3 weights = abs(normal_world);
        vec3 soil_top = texture(soil_tex,uv).rgb;
        vec3 soil_side_x = texture(soil_tex,fract(world_pos.zy/1.5)).rgb;
        vec3 soil_side_z = texture(soil_tex,fract(world_pos.xy/1.5)).rgb;
        vec3 earth = soil_top;
        if (weights.y < max(weights.x,weights.z)) {
            earth = weights.x > weights.z ? soil_side_x : soil_side_z;
        }
        ALBEDO = mix(earth,turf,turf_coverage);
        ALBEDO = mix(ALBEDO,turf*vec3(0.63,0.76,0.53),lip*0.65);
        ROUGHNESS = 1.0;
    } else if (render_mode_id == 6) {
        // R6: R5's exact stochastic grass A/B selection, unchanged.
        vec2 uv = fract(p / material_meters);
        vec3 turf_a = texture(grass_a_tex,uv).rgb;
        vec3 turf_b = texture(grass_b_tex,uv).rgb;
        float grass_field = 0.64*noise2(p*1.55+vec2(13.7,8.2))
                          + 0.36*noise2(p*4.0+vec2(71.1,19.4));
        float grass_jitter = hash21(floor(p*8.0+vec2(2.0,7.0))) - 0.5;
        float grass_pick = step(0.50,grass_field+0.14*grass_jitter);
        vec3 turf = mix(turf_a,turf_b,grass_pick);

        // Reconstruct broad-scale path boundaries analytically in world-space:
        // width and center vary independently over 0.5-2m spatial scales.
        // Do not reuse the near-straight per-vertex R5 material weight.
        float center = 6.1 + 0.85*sin(p.x*0.42);
        center += 0.40*(noise2(vec2(p.x*0.55,11.0))-0.5)*2.0;
        center += 0.20*(noise2(p*0.85+vec2(6.0,17.0))-0.5)*2.0;
        float half_width = 0.62 + 0.24*(noise2(p*0.75+vec2(34.0,12.0))-0.5)*2.0;
        float distance_to_path = abs(p.y-center);
        float edge_field = distance_to_path-half_width;
        float islands = 0.21*(noise2(p*2.2+vec2(7.0,3.0))-0.5)*2.0
                      + 0.08*(noise2(p*7.0+vec2(4.0,23.0))-0.5)*2.0;
        float pixel_jitter = (hash21(floor(p*32.0+vec2(97.0,31.0)))-0.5)*0.065;
        float grass_coverage = step(0.0,edge_field+islands+pixel_jitter);

        // Exposed subsurface: no grass inside the excavated floor or bank.
        // Depth is encoded in vertex color.g by the terrain geometry builder.
        float exposed = step(0.13,cut_depth);
        grass_coverage *= 1.0-exposed;

        // Slope-aware projection: the original XZ mapping stretches across
        // banks. Blend in a side-projected soil sample only on steep surfaces.
        // World derivatives avoid reliance on a possibly flipped face normal.
        vec3 dpdx = dFdx(world_pos);
        vec3 dpdy = dFdy(world_pos);
        vec3 geometric_normal = normalize(cross(dpdx,dpdy));
        float up = abs(geometric_normal.y);
        float bank = 1.0-smoothstep(0.68,0.94,up);
        vec2 side_uv_x = fract(world_pos.zy / material_meters);
        vec2 side_uv_z = fract(world_pos.xy / material_meters);
        vec3 side_x = texture(soil_tex,side_uv_x).rgb;
        vec3 side_z = texture(soil_tex,side_uv_z).rgb;
        float side_mix = abs(geometric_normal.x)/
                         max(0.001,abs(geometric_normal.x)+abs(geometric_normal.z));
        vec3 earth = mix(texture(soil_tex,uv).rgb,mix(side_z,side_x,side_mix),bank);

        // Gentle geometry-based lightness, without filtering source pixels.
        float shade = mix(0.77,1.0,up);
        ALBEDO = mix(earth,turf,grass_coverage)*shade;
    } else if (render_mode_id == 5) {
        // R5: world-anchored stochastic material selection.
        // No RGB interpolation between different texture materials.
        // All material samples use the same UVs, so micro-pixel structure
        // remains sharp; cluster boundaries are stochastic and repeatable.
        vec2 uv = fract(p / material_meters);
        vec3 turf_a = texture(grass_a_tex,uv).rgb;
        vec3 turf_b = texture(grass_b_tex,uv).rgb;
        vec3 earth = texture(soil_tex,uv).rgb;

        // Grass variants: correlated coarse patches (~0.65m) plus irregular
        // noise at 0.25m. This avoids hard 8m checkerboard switching.
        float grass_field = 0.64*noise2(p*1.55+vec2(13.7,8.2))
                          + 0.36*noise2(p*4.0+vec2(71.1,19.4));
        float grass_jitter = hash21(floor(p*8.0+vec2(2.0,7.0))) - 0.5;
        float grass_pick = step(0.50, grass_field+0.14*grass_jitter);
        vec3 turf = mix(turf_a,turf_b,grass_pick);

        // Transition width follows the existing world-material mask.
        // Multi-scale excursions, islands and quantized pixel jitter
        // replace the thin R4 noise-only edge. Avoid smoothstep color blend.
        float organic = 0.58*(noise2(p*1.15+vec2(23.0,47.0))-0.5)
                      + 0.28*(noise2(p*3.4+vec2(5.0,11.0))-0.5)
                      + 0.14*(noise2(p*9.0+vec2(41.0,3.0))-0.5);
        float pixel_jitter = hash21(floor(p*32.0+vec2(97.0,31.0)))-0.5;
        float coverage = g + 0.66*organic + 0.12*pixel_jitter;
        float grass_pick_final = step(0.5,coverage);
        ALBEDO = mix(earth,turf,grass_pick_final);
    } else if (render_mode_id == 4) {
        // R4: real generated material PNGs, world-space 8m per image.
        // Alternating grass sources per 8m macro cell; intentionally simple
        // baseline to expose repeated motifs and texture discontinuities.
        vec2 material_pos = p / material_meters;
        vec2 uv = fract(material_pos);
        vec2 cell = floor(material_pos);
        float selector = hash21(cell);
        vec3 turf_a = texture(grass_a_tex,uv).rgb;
        vec3 turf_b = texture(grass_b_tex,uv).rgb;
        vec3 turf = mix(turf_a,turf_b,step(0.5,selector));
        vec3 earth = texture(soil_tex,uv).rgb;
        // Pixel-sized threshold jitter avoids blurred grass/soil edges.
        float boundary = hash21(floor(p*32.0)) - 0.5;
        float blend = step(0.5,g + 0.16*boundary);
        ALBEDO = mix(earth,turf,blend);
    } else if (render_mode_id == 3) {
        // R3: 2 hand-structured procedural atlases, repeated in world coordinates.
        // Texture atlas: grass left half, soil right half.
        vec2 uv = fract(p*0.48);
        float edge = noise2(p*2.0);
        float blend = step(0.48,g+0.13*(edge-0.5));
        vec2 atlas_uv = vec2(uv.x*0.5 + (1.0-blend)*0.5,uv.y);
        ALBEDO = texture(r3_atlas,atlas_uv).rgb;
    } else {
        // R2: explicit world-anchored pixel clusters and quantized palette.
        // These are PROCEDURAL placeholders, not extracted reference pixels.
        vec2 cell = floor(p*world_scale);
        float macro = noise2(floor(cell/16.0)*0.20);
        float micro = hash21(floor(cell/3.0));
        float clump = noise2(floor(cell/7.0)*0.8);
        float blend = step(0.47, g+0.17*(clump-0.5));
        float tone = floor(clamp(0.55*macro+0.45*micro,0.0,0.999)*4.0);
        vec3 earth = vec3(0.26,0.17,0.11)+tone*vec3(0.045,0.032,0.018);
        vec3 turf = vec3(0.17,0.28,0.12)+tone*vec3(0.047,0.048,0.020);
        vec3 color = mix(earth,turf,blend);
        float sprig = step(0.91,hash21(floor(cell/11.0))) * step(0.55,blend);
        ALBEDO = mix(color,vec3(0.55,0.58,0.29),sprig*step(0.65,hash21(cell)));
    }
    // Keep R0-R6 visually unlit for direct comparison with R7.
    if (render_mode_id < 7) {
        EMISSION = ALBEDO;
        ALBEDO = vec3(0.0);
    }
}

shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_opaque;

uniform int render_mode_id = 0;
uniform float world_scale = 32.0;
uniform float seed = 19.0;
uniform sampler2D r3_atlas : source_color, filter_nearest, repeat_enable;

varying vec3 world_pos;
varying float grass;

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
}

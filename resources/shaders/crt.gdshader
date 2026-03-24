shader_type canvas_item;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec2 native_resolution = vec2(960.0, 540.0);

// --- Color controls ---
uniform float brightness  : hint_range(0.0, 2.0) = 1.02;
uniform float contrast    : hint_range(0.0, 2.0) = 1.08;
uniform float saturation  : hint_range(0.0, 2.0) = 1.10;
uniform float gamma       : hint_range(0.2, 3.0) = 1.05;

// --- CRT geometry ---
uniform float curvature      : hint_range(0.0, 0.40) = 0.09;
uniform float corner_soften  : hint_range(0.0, 0.20) = 0.06;

// --- Pixelization ---
uniform float pixel_scale : hint_range(1.0, 8.0) = 1.0;

// --- Vignette ---
uniform float vignette_strength : hint_range(0.0, 1.0) = 0.38;

// --- Scanlines ---
uniform float scanline_opacity : hint_range(0.0, 1.0) = 0.04;
uniform float scanline_density : hint_range(0.5, 3.0) = 1.7;

// --- Rolling scan band ---
uniform float rolling_speed      : hint_range(0.0, 2.0) = 0.1;
uniform float rolling_band_width : hint_range(0.0, 0.3) = 0.08;
uniform float rolling_strength   : hint_range(0.0, 0.5) = 0.01;

// --- Interlacing ---
uniform float interlace_strength : hint_range(0.0, 1.0) = 0.08;

// --- Shadow mask ---
uniform float mask_strength : hint_range(0.0, 1.0) = 0.07;
uniform float mask_scale    : hint_range(0.5, 4.0) = 0.7;

// --- Chromatic aberration ---
uniform float chroma_offset_px : hint_range(0.0, 6.0) = 0.04;

// --- Luma smear ---
uniform float luma_smear_px : hint_range(0.0, 8.0) = 0.6;

// --- Movement / drift ---
uniform float drift_speed  : hint_range(0.0, 2.0)  = 1.0;
uniform float drift_amount : hint_range(0.0, 0.01) = 0.001;
uniform float jitter_px    : hint_range(0.0, 8.0)  = 0.05;
uniform float wobble_px    : hint_range(0.0, 10.0) = 0.1;

// --- Noise / tape ---
uniform float noise_strength   : hint_range(0.0, 1.0) = 0.02;
uniform float flicker_strength : hint_range(0.0, 1.0) = 0.01;
uniform float tape_lines       : hint_range(0.0, 1.0) = 0.0;

// --- Glow ---
uniform float glow_strength  : hint_range(0.0, 2.0) = 0.25;
uniform float glow_threshold : hint_range(0.0, 1.0) = 0.65;

// ---- Helpers ----

float hash11(float n) {
    return fract(sin(n) * 43758.5453123);
}

float hash_simple(vec2 p) {
    p = fract(p * vec2(443.897, 441.423));
    p += dot(p, p + 19.19);
    return fract(p.x * p.y);
}

vec2 crt_curve(vec2 uv, float k) {
    vec2 cc = uv * 2.0 - 1.0;
    vec2 d  = cc * cc;
    cc *= 1.0 + k * vec2(d.y, d.x);
    return cc * 0.5 + 0.5;
}

float inside01(vec2 uv) {
    return step(0.0, uv.x) * step(uv.x, 1.0)
         * step(0.0, uv.y) * step(uv.y, 1.0);
}

vec3 apply_color_controls(vec3 c) {
    c *= brightness;
    c  = mix(vec3(0.5), c, contrast);
    float l = dot(c, vec3(0.2126, 0.7152, 0.0722));
    c  = mix(vec3(l), c, saturation);
    c  = pow(max(c, vec3(0.0)), vec3(1.0 / max(gamma, 0.0001)));
    return c;
}

vec3 triad_mask(vec2 frag_xy) {
    float x = floor(frag_xy.x / max(mask_scale, 0.0001));
    float m = mod(x, 3.0);
    if (m < 1.0) return vec3(1.10, 0.85, 0.85);
    if (m < 2.0) return vec3(0.85, 1.10, 0.85);
    return     vec3(0.85, 0.85, 1.10);
}

vec3 sample_screen(vec2 uv) {
    return textureLod(SCREEN_TEXTURE, uv, 0.0).rgb;
}

void fragment() {
    vec2 px = 1.0 / native_resolution;
    float t = TIME;

    vec2 uv = UV;

    // --- Per-line jitter ---
    float y_line = floor(uv.y * native_resolution.y);
    float jitter = (hash11(y_line + floor(t * 15.0) * 37.0) - 0.5) * 2.0;
    uv.x += jitter * (jitter_px * px.x);

    // --- Slow wobble ---
    uv.x += sin(uv.y * 8.0 + t * 1.2) * (wobble_px * px.x);

    // --- Subtle drift ---
    uv.x += sin(t * drift_speed + uv.y * 8.0) * drift_amount;
    uv.y += cos(t * drift_speed * 0.7 + uv.x * 6.0) * drift_amount * 0.5;

    // --- CRT curve ---
    vec2 cuv = crt_curve(uv, curvature);

    // --- Pixelization (post-warp, snapped to native res grid) ---
    vec2 pixel_res = native_resolution / max(pixel_scale, 1.0);
    cuv = floor(cuv * pixel_res) / pixel_res;

    float in_bounds = inside01(cuv);

    // --- Rounded corners ---
    vec2 d        = abs(cuv - 0.5) * 2.0;
    float edge        = max(d.x, d.y);
    float corner_mask = 1.0 - smoothstep(1.0 - corner_soften, 1.0, edge);

    // --- Chromatic aberration ---
    vec2 chroma = vec2(chroma_offset_px * px.x, 0.0);
    float r = sample_screen(cuv + chroma).r;
    float g = sample_screen(cuv).g;
    float b = sample_screen(cuv - chroma).b;
    vec3 col = vec3(r, g, b);

    // --- Luma smear ---
    float smear = luma_smear_px * px.x;
    vec3 s1 = sample_screen(cuv + vec2(smear, 0.0));
    vec3 s2 = sample_screen(cuv - vec2(smear, 0.0));
    col = mix(col, (col + s1 + s2) / 3.0, 0.35);

    // --- Scanlines (snapped to native res) ---
    float scan     = sin((cuv.y * native_resolution.y) * 3.14159 * scanline_density);
    float scan_mul = 1.0 - scanline_opacity * (0.5 - 0.5 * scan);
    col *= scan_mul;

    // --- Interlacing ---
    float field = mod(floor(FRAGCOORD.y) + floor(t * 60.0), 2.0);
    col *= 1.0 - interlace_strength * field * 0.10;

    // --- Rolling scan band ---
    float band_pos  = fract(t * rolling_speed);
    float band_dist = abs(cuv.y - band_pos);
    band_dist = min(band_dist, 1.0 - band_dist);
    float band = smoothstep(rolling_band_width, 0.0, band_dist);
    col += band * rolling_strength;

    // --- Tape lines ---
    float line_n = hash11(y_line * 0.7 + floor(t * 12.0) * 11.0);
    float line   = smoothstep(0.985, 1.0, line_n) * tape_lines;
    col += line * vec3(0.18);

    // --- Grain ---
    vec2 noise_uv = floor(cuv * native_resolution) / native_resolution;
    float grain   = hash_simple(noise_uv + fract(t * 31.7));
    col += (grain - 0.5) * noise_strength;

    // --- Flicker ---
    float flicker = 1.0 - flicker_strength * hash_simple(vec2(t * 17.3, 0.5));
    col *= flicker;

    // --- Glow ---
    vec3 cx1 = sample_screen(cuv + vec2(px.x, 0.0));
    vec3 cx2 = sample_screen(cuv - vec2(px.x, 0.0));
    vec3 cy1 = sample_screen(cuv + vec2(0.0, px.y));
    vec3 cy2 = sample_screen(cuv - vec2(0.0, px.y));
    vec3 blur = (col + cx1 + cx2 + cy1 + cy2) / 5.0;
    float br  = dot(blur, vec3(0.2126, 0.7152, 0.0722));
    vec3 glow_col = max(blur - vec3(glow_threshold), vec3(0.0));
    col += glow_col * glow_strength * (0.5 + 0.5 * br);

    // --- Vignette ---
    vec2 v    = cuv - 0.5;
    float vig = smoothstep(0.9, 0.2, dot(v, v) * 2.2);
    col *= mix(1.0 - vignette_strength, 1.0, vig);

    // --- Shadow mask ---
    vec3 mask = triad_mask(FRAGCOORD.xy);
    col *= mix(vec3(1.0), mask, mask_strength);

    // --- Color grading ---
    col = apply_color_controls(col);

    // --- Bounds + corners ---
    col *= in_bounds * corner_mask;

    COLOR = vec4(col, 1.0);
}
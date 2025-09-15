shader_type canvas_item;

uniform float radius_px = 200.0; // rayon en pixels

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    vec2 center = vec2(0.5);

    // taille de la texture en pixels
    vec2 tex_size = vec2(textureSize(TEXTURE, 0));

    // distance du centre en pixels
    vec2 diff_px = (UV - center) * tex_size;
    float d_px = length(diff_px);

    // alpha = 0.5 au centre, 0 au bord
    float alpha_factor = clamp(0.25 * (1.0 - d_px / radius_px), 0.0, 0.25);

    tex.a *= alpha_factor;

    COLOR = tex;
}

shader_type canvas_item;

uniform vec2 player_pos; // position du joueur (en pixels, envoyée par script)
uniform float radius = 48.0; // rayon du cercle de transparence
uniform float alpha_factor = 0.3; // transparence (0 = invisible, 1 = opaque)

void fragment() {
    // Couleur normale du tile
    vec4 tex_color = texture(TEXTURE, UV);

    // Position actuelle du pixel à l'écran
    vec2 pixel_pos = SCREEN_UV * vec2(SCREEN_PIXEL_SIZE);

    // Distance entre le pixel et le joueur
    float dist = distance(pixel_pos, player_pos);

    // Si le pixel est proche du joueur, on réduit son alpha
    if (dist < radius) {
        tex_color.a *= alpha_factor;
    }

    COLOR = tex_color;
}
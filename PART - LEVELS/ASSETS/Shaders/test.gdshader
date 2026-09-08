shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear;

uniform vec2 center = vec2(0.5, 0.5);
uniform float start_time = -10.0;

uniform float speed = 0.8;
uniform float width = 0.025;
uniform float strength = 0.04;

uniform float interval = 0.15;
uniform int wave_count = 3;


void fragment()
{
    vec2 uv = SCREEN_UV;

    vec2 aspect = vec2(
        SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x,
        1.0
    );

    vec2 pos = (uv - center) * aspect;

    float dist = length(pos);

    float total_ring = 0.0;
    vec2 total_offset = vec2(0.0);

    for (int i = 0; i < 3; i++)
    {
        float wave_start = start_time + float(i) * interval;

        float elapsed = TIME - wave_start;

        if (elapsed > 0.0)
        {
            float radius = elapsed * speed;

            if (radius < 1.5)
            {
                float ring = 1.0 - smoothstep(
                    0.0,
                    width,
                    abs(dist - radius)
                );

                vec2 dir = normalize(pos);

                total_offset += dir * ring * strength / aspect;

                total_ring += ring;
            }
        }
    }

    vec4 color = texture(
        screen_texture,
        uv + total_offset
    );

    color.rgb += total_ring * 0.12;

    COLOR = color;
}
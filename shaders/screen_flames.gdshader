shader_type canvas_item;

// Warping and blending textures, Simplex Smooth noise
uniform sampler2D flame1_texture : repeat_enable;
uniform sampler2D flame2_texture : repeat_enable;
uniform sampler2D flame3_texture : repeat_enable;

// Flame color gradient (use a GradientTexture2D)
uniform sampler2D color_gradient;

// Optional: For capturing the screen (can be left unassigned)
uniform sampler2D screen_texture;

// Flame intensity, controlled by script
uniform float intensity : hint_range(0.0, 1.0) = 0.0;

vec4 blend_screen(vec4 base, vec4 blend) {
    return 1.0 - (1.0 - base) * (1.0 - blend);
}

void fragment() {
    // Scrolling vectors for the 3 flame textures
    vec2 f1_uv = vec2(UV.x - TIME * 0.3, UV.y + TIME * 0.1);
    vec2 f2_uv = vec2(UV.x + TIME * 0.3, UV.y + TIME * 0.1);
    vec2 f3_uv = vec2(UV.x, UV.y + TIME * 0.8);

    // Calculate flame distortion using two textures
    float warp1 = texture(flame1_texture, f1_uv * 2.1).r;
    float warp2 = texture(flame2_texture, f2_uv * 2.1).r;
    vec2 warp = vec2(warp1 - warp2, 0.0) * 0.05;

    // Sample the flame noise textures
    float flame1_sample = texture(flame1_texture, f1_uv).r;
    float flame2_sample = texture(flame2_texture, f2_uv).r;
    float flame3_sample = texture(flame3_texture, f3_uv + warp).r;

    // Flame shape - a half-oval rising from the bottom
    float shape_fade = 1.0 - sqrt(pow(UV.x - 0.5, 2.0) + pow(UV.y - 1.0, 2.0) * 0.2) * 2.0;

    // Blend the flame samples and apply the shape fade
    float flame = ((flame1_sample + flame2_sample + flame3_sample * 1.5) / 3.5) * shape_fade;

    // Apply intensity to scale the flame
    flame *= intensity;

    // Determine alpha for flames
    float alpha = step(0.12, flame); // On/off flame cutoff

    // Generate the flame color using the gradient texture
    vec3 color = texture(color_gradient, vec2(flame, 0.0)).rgb * flame * 3.5;

    // Transparent background when alpha is low
    if (alpha <= 0.0) {
        discard; // Skip rendering this fragment (fully transparent)
    }

    // Final output with alpha applied
    COLOR = vec4(color, alpha);
}

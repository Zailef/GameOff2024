shader_type canvas_item;
render_mode blend_premul_alpha;

// Shader parameters
uniform float line_smoothness : hint_range(0.0, 0.1) = 0.045;
uniform float line_width : hint_range(0.0, 0.2) = 0.09;
uniform float brightness = 3.0;
uniform float rotation_angle : hint_range(-90.0, 90.0) = 30.0;
uniform float distortion : hint_range(1.0, 2.0) = 1.8;
uniform float speed = 0.7;
uniform float scroll_position : hint_range(0.0, 1.0) = 0.0;
uniform float position_min = 0.25;
uniform float position_max = 0.5;
uniform float alpha : hint_range(0.0, 1.0) = 1.0;
uniform bool is_active = true;

// Utility function for rotating UV coordinates
vec2 rotate_uv(vec2 uv, vec2 center, float angle_deg) {
    float angle_rad = radians(angle_deg);
    mat2 rotation_matrix = mat2(
        vec2(cos(angle_rad), -sin(angle_rad)),
        vec2(sin(angle_rad), cos(angle_rad))
    );
    vec2 delta = uv - center;
    return rotation_matrix * delta + center;
}

void fragment() {
    // If the shader is not active, output transparent
    if (!is_active) {
        COLOR = vec4(0.0, 0.0, 0.0, 0.0); // Transparent
    } else {
        // Calculate gradient from UV center to edge, affected by distortion
        vec2 uv_centered = UV - vec2(0.5, 0.5);
        float gradient_to_edge = max(abs(uv_centered.x), abs(uv_centered.y)) * distortion;
        gradient_to_edge = 1.0 - gradient_to_edge;

        // Rotate UV coordinates around the center
        vec2 rotated_uv = rotate_uv(UV, vec2(0.5, 0.5), rotation_angle);

        // Remap the position for scrolling
        float position_range = position_max - position_min;
        float remapped_position = position_min + position_range * scroll_position;

        // Calculate scrolling offset over time
        float time_offset = fract(TIME * speed + remapped_position);
        time_offset = -2.0 + 4.0 * time_offset; // Map time offset to the range [-2, 2]

        vec2 offset_uv = rotated_uv + vec2(time_offset, 0.0);

        // Calculate the line gradient
        float line_intensity = abs(offset_uv.x) * gradient_to_edge;
        line_intensity = sqrt(line_intensity);

        // Adjust line intensity based on width and smoothness
        float smooth_range = clamp(line_smoothness, 0.001, 1.0);
        float line_upper_bound = line_width + smooth_range;
        float line_lower_bound = line_width - smooth_range;

        float line_range = line_lower_bound - line_upper_bound;
        float adjusted_line = (line_intensity - line_upper_bound) / line_range;
        adjusted_line *= brightness;
        adjusted_line = min(adjusted_line, alpha);

        // Apply the final color and alpha
        COLOR.rgb *= adjusted_line;
        COLOR.a = adjusted_line;
    }
}

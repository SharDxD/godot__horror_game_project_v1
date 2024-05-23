shader_type canvas_item;

void fragment() {
    // Sample the texture color
    vec4 color = texture(TEXTURE, UV);
    
    // Convert to grayscale
    float gray = dot(color.rgb, vec3(0.3, 0.59, 0.11));
    
    // Apply a green tint
    vec3 nightVisionColor = vec3(0.0, gray, 0.0);
    
    // Increase brightness and contrast
    nightVisionColor = pow(nightVisionColor, vec3(0.5));
    nightVisionColor = nightVisionColor * 2.0;

    // Output the final color
    COLOR = vec4(nightVisionColor, color.a);
}
shader_type spatial;

uniform sampler2D screen_texture: hint_screen_texture, filter_linear_mipmap;
uniform float amount: hint_range(0.0,5.0);

void fragment() {
	vec4 color = textureLod(screen_texture, SCREEN_UV, amount);
}

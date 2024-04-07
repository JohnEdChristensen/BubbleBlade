shader_type canvas_item;

render_mode blend_mix;
uniform vec4 modulate: source_color;

void fragment() {
	COLOR.r = texture(TEXTURE, UV).r - modulate.r;
	COLOR.g = texture(TEXTURE, UV).g - modulate.g;
	COLOR.b = texture(TEXTURE, UV).b - modulate.b;
}

shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform sampler2D gradient;

void fragment() {
	float b = texture(TEXTURE, UV).r;
	COLOR = texture(gradient, vec2(b, 0.0f));
}

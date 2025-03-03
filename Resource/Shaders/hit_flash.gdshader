shader_type canvas_item;

uniform vec4 flashColor: source_color;
uniform float flashValue: hint_range(0.0, 1.0, 0.1);

void fragment() {
	vec4 textureColor = texture(TEXTURE, UV);
	COLOR = mix(textureColor, flashColor, flashValue);
	COLOR.a = textureColor.a;
}
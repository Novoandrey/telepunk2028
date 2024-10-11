shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
uniform float value = 0.0;

void fragment() {
	COLOR = textureLod(screen_texture, SCREEN_UV, value);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

shader_type canvas_item;
uniform float scale = 1;
void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX *= scale;
}

void fragment() {
	
	COLOR = texture(TEXTURE, UV);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

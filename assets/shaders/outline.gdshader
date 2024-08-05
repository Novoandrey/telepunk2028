shader_type canvas_item;

uniform float width : hint_range(0.0, 30.0);
uniform vec4 outline_color : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float size = width * 1.0 / float(textureSize(TEXTURE, 0).x);
	vec4 sprite_color = texture(TEXTURE, UV);
	float alpha = -4.0 * sprite_color.a;
	alpha += texture(TEXTURE, UV + vec2(size, 0.0)).a;
	alpha += texture(TEXTURE, UV + vec2(-size, 0.0)).a;
	alpha += texture(TEXTURE, UV + vec2(0.0, size)).a;
	alpha += texture(TEXTURE, UV + vec2(0.0, -size)).a;
	
	vec4 final_color = outline_color;
	COLOR = vec4(final_color.rgb, alpha);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

shader_type canvas_item;

uniform vec4 old_color: source_color = vec4(0, 1, 0, 1);
uniform vec4 new_color: source_color;
uniform float bias = 595;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float simularity = distance(COLOR, old_color);
	if (simularity < bias) {
		COLOR = new_color;
		COLOR.rgb -= simularity * vec3(5);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

shader_type canvas_item;

uniform vec3 playerPos = vec3(0,0,0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 coord = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

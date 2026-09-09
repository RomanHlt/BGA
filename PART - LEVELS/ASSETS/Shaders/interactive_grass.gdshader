shader_type canvas_item;

uniform float skew = 0;

void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX.x += (1.0-UV.y)*skew;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

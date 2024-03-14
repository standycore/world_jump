shader_type canvas_item;

uniform float brightness = 0.0;
uniform vec4 color: source_color = vec4(1.0);

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 sample = texture(TEXTURE, UV);
	if (sample.a > 0.0) {
		COLOR = mix(sample, color, brightness);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

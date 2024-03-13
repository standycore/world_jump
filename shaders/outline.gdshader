shader_type canvas_item;

uniform bool visible = false;
uniform bool flashing = false;
uniform float outline_width = 2.0;
uniform vec4 outline_color: source_color = vec4(1.0);
uniform float flash_speed = 10.0;
uniform float flash_max_alpha = 0.2;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (visible) {
		vec2 pixel_size = TEXTURE_PIXEL_SIZE;
		
		vec4 center_sample = texture(TEXTURE, UV);
		if (center_sample.a <= 0.5) {
			for (float y = -1.0; y <= 1.0; y += 1.0) {
				for (float x = -1.0; x <= 1.0; x += 1.0) {
					vec4 sample = texture(TEXTURE, UV + vec2(x, y) * pixel_size * outline_width);
					if (sample.a > 0.0) {
						if (flashing) {
							COLOR = vec4(outline_color.rgb,
								mix(outline_color.a, flash_max_alpha, sin(TIME * flash_speed) * .5 + .5)
							);
						} else {
							COLOR = outline_color;
						}
						
					}
				}
			}
		}
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

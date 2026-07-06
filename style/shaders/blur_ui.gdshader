shader_type canvas_item;

uniform float blur_amount : hint_range(0.0, 10.0) = 4.0;
uniform int sample_count : hint_range(1, 16) = 8;

// Die Farbe, die über den Blur gelegt wird
uniform vec4 tint_color : source_color = vec4(0.8, 0.8, 0.8, 1.0);
// 0.0 = kein Tint, 1.0 = volle Tint-Farbe
uniform float tint_strength : hint_range(0.0, 1.0) = 0.3;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec2 pixel_size = SCREEN_PIXEL_SIZE * blur_amount;
	vec4 color_sum = vec4(0.0);
	float total_weight = 0.0;

	for (int x = -sample_count; x <= sample_count; x++) {
		for (int y = -sample_count; y <= sample_count; y++) {
			vec2 offset = vec2(float(x), float(y)) * pixel_size;
			float weight = 1.0 - (length(vec2(float(x), float(y))) / float(sample_count));
			weight = max(weight, 0.0);

			color_sum += textureLod(screen_texture, SCREEN_UV + offset, 2.0) * weight;
			total_weight += weight;
		}
	}

	vec4 blurred = color_sum / total_weight;

	// Farbe reinmischen, Alpha des Original-Blurs beibehalten
	COLOR = vec4(mix(blurred.rgb, tint_color.rgb, tint_strength), blurred.a);
}
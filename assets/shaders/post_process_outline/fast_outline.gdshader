shader_type canvas_item;

uniform vec4 outline_color : source_color;
uniform float outline_width : hint_range(0.0, 10.0, 0.1);

void fragment() {
	// Place fragment code here.
	
	vec4 sample_point_color = texture(TEXTURE, SCREEN_UV, 0.0);
	
	if (sample_point_color.a == 0.0) {
		
		bool end_search = false;
		vec2 search_area = outline_width * SCREEN_PIXEL_SIZE;
		
		for (float x = -search_area.x; x <= search_area.x && !end_search; x += SCREEN_PIXEL_SIZE.x) {
			for (float y = -search_area.y; y <= search_area.y && !end_search; y += SCREEN_PIXEL_SIZE.y) {
				vec4 search_point_color = texture(TEXTURE, SCREEN_UV+vec2(x, y), 0.0);
				
				if (search_point_color.a != 0.0) {
					COLOR = outline_color;
					end_search = true;
				}
				else {
					COLOR = vec4(0,0,0,0);
				}
			}
		}
	}
	else {
		COLOR = sample_point_color;
	}
}

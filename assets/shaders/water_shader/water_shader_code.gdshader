shader_type spatial;


uniform sampler2D vertex_height_map : hint_default_black;
uniform float height_scale : hint_range(0.0, 1.0);
uniform float vertex_floating_speed_scale : hint_range(0.01, 10.0, 0.01);
uniform float vertex_map_scale : hint_range(1.0, 100.0, 0.01);

uniform float roughness_scale : hint_range(0.0, 10, 0.001);
uniform float metallic : hint_range(0.0, 1.0, 0.01);
uniform vec3 albedo : source_color;
uniform float alpha : hint_range(0.0, 1.0, 0.01);

float wave(vec2 position){
  position += texture(vertex_height_map, position / 10.0).y * 2.0 - 1.0;
  vec2 wv = 1.0 - abs(sin(position));
  return pow(1.0 - pow(wv.x * wv.y, 0.65), 4.0);
}

float height(vec2 position, float time, float scale) {
  float d = wave((position + time) * 0.4 * scale) * 0.3;
  d += wave((position - time) * 0.5 * scale) * 0.3;
  d += wave((position + time) * 0.6 * scale) * 0.2;
  d += wave((position - time) * 0.7 * scale) * 0.2;
  return d;
}

//varying vec3 normal;
void vertex(){
	
	float delta_height = height(
		vec2(VERTEX.x, VERTEX.z), 
		TIME*vertex_floating_speed_scale, 
		vertex_map_scale
	);
	
	VERTEX.y += (delta_height - 0.5) * height_scale;
	
} 

void fragment() {
	// Place fragment code here
	float fnl = sqrt( 1.0 - dot(NORMAL, VIEW));
	RIM = 0.2;
	ROUGHNESS = roughness_scale * (1.0 - fnl);
	METALLIC = metallic;
	ALBEDO = albedo;
	
	vec3 v1 = dFdx(VERTEX);
	vec3 v2 = dFdy(VERTEX);
	NORMAL = normalize(cross(v1, v2));
	ALPHA = alpha;
		
}

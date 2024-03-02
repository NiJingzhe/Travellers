shader_type sky;

uniform vec3 dawntime_color : source_color;
uniform vec3 daytime_color : source_color;
uniform vec3 dusktime_color : source_color;
uniform vec3 nighttime_color : source_color;


// day stage : 1 is dawn to day, 2 is day to dusk and so on
uniform int day_stage : hint_range(1, 4, 1);
// stage progress : representing the progress of current stage, to make gradient change of color
uniform float stage_progress : hint_range(0.0, 1.0, 0.001);

uniform float light_energy : hint_range(0.0, 1.0, 0.01);

vec3 calc_color(int stage, float prog) {
	if (stage == 1)
		return mix(dawntime_color, daytime_color, prog);
	else if (stage == 2)
		return mix(daytime_color, dusktime_color, prog);
	else if (stage == 3)
		return mix(dusktime_color, nighttime_color, prog);
	else
		return mix(nighttime_color, dawntime_color, prog);
}

void sky() {
	// Place sky code here.
	
	COLOR = calc_color(day_stage, stage_progress) * light_energy;	
	
}

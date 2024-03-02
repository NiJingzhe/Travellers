extends WorldEnvironment

@onready var root : SunSystem = self.get_parent() as SunSystem
@onready var energy_curve : Curve = root.energy_curve
@onready var dawntime_color : Color = root.dawntime_color
@onready var daytime_color : Color = root.daytime_color
@onready var dusktime_color : Color = root.dusktime_color
@onready var nighttime_color : Color = root.nighttime_color
@onready var time_of_whole_day : float = root.time_of_whole_day
@onready var game_time : float = root.game_time
@onready var DAWN_START : float = root.DAWN_START
@onready var DAY_START : float = root.DAY_START
@onready var DUSK_START : float = root.DUSK_START
@onready var NIGHT_START : float = root.NIGHT_START

@onready var sky_shader : ShaderMaterial = self.environment.sky.sky_material as ShaderMaterial

func _ready():
	
	sky_shader.set_shader_parameter("dawntime_color", dawntime_color)
	sky_shader.set_shader_parameter("daytime_color", daytime_color)
	sky_shader.set_shader_parameter("dusktime_color", dusktime_color)
	sky_shader.set_shader_parameter("nighttime_color", nighttime_color)

func _process(_delta):

	game_time = root.game_time

	sky_shader.set_shader_parameter("light_energy", energy_curve.sample_baked(game_time / 24))
	#print(energy_curve.sample_baked(game_time / 24))
	if game_time > DAWN_START and game_time <= DAY_START:
		sky_shader.set_shader_parameter("day_stage", 1)
		sky_shader.set_shader_parameter("stage_progress", get_weight(DAWN_START, DAY_START, game_time))
	elif game_time > DAY_START and game_time <= DUSK_START:
		sky_shader.set_shader_parameter("day_stage", 2)
		sky_shader.set_shader_parameter("stage_progress", get_weight(DAY_START, DUSK_START, game_time))
	elif game_time > DUSK_START and game_time <= NIGHT_START:
		sky_shader.set_shader_parameter("day_stage", 3)
		sky_shader.set_shader_parameter("stage_progress", get_weight(DUSK_START, NIGHT_START, game_time))
	elif game_time > NIGHT_START or game_time <= DAWN_START:
		sky_shader.set_shader_parameter("day_stage", 4)
		var game_time_fix = game_time - 24 if game_time <= 24 and game_time > NIGHT_START else game_time
		sky_shader.set_shader_parameter("stage_progress", get_weight(NIGHT_START-24, DAWN_START, game_time_fix))

func get_mid_value(start:float, end:float, t:float) -> float:
	return t * (end - start) + start

func get_weight(start:float, end:float, mid_val:float) -> float:
	return (mid_val - start) / (end - start)

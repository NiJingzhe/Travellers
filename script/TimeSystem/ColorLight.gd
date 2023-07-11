extends DirectionalLight3D

@onready var root : SunSystem = self.get_parent() as SunSystem
@onready var energy_curve : Curve = root.energy_curve
@onready var dawntime_color : Color = root.dawntime_color
@onready var daytime_color : Color = root.daytime_color
@onready var dusktime_color : Color = root.dusktime_color
@onready var nighttime_color : Color = root.nighttime_color
@onready var time_of_whole_day : float = root.time_of_whole_day
@onready var game_time : float = root.game_time
@onready var sun : DirectionalLight3D = self
@onready var DAWN_START : float = 3.5
@onready var DAY_START : float = 6.5
@onready var DUSK_START : float = 17
@onready var NIGHT_START : float = 19.5


func _ready():
	pass
	#energy_curve.bake()

func _process(delta):
	
	game_time = root.game_time
	
	sun.light_energy = energy_curve.sample_baked(game_time / 24)
	
	if game_time >= DAWN_START and game_time <= get_mid_value(DAWN_START, DAY_START, 0.6):
		sun.light_color = dawntime_color
	elif game_time > get_mid_value(DAWN_START, DAY_START, 0.6) and game_time <= DAY_START:
		sun.light_color = dawntime_color.lerp(daytime_color, get_weight(get_mid_value(DAWN_START, DAY_START, 0.6), DAY_START, game_time))
	elif game_time > DAY_START and game_time <= get_mid_value(DAY_START, DUSK_START, 0.6):
		sun.light_color = daytime_color
	elif game_time > get_mid_value(DAY_START, DUSK_START, 0.6) and game_time <= DUSK_START:
		sun.light_color = daytime_color.lerp(dusktime_color, get_weight(get_mid_value(DAY_START, DUSK_START, 0.6), DUSK_START, game_time))
	elif game_time > DUSK_START and game_time <= get_mid_value(DUSK_START, NIGHT_START, 0.8):
		sun.light_color = dusktime_color
	elif game_time > get_mid_value(DUSK_START, NIGHT_START, 0.8) and game_time < NIGHT_START:
		sun.light_color = dusktime_color.lerp(nighttime_color, get_weight(get_mid_value(DUSK_START, NIGHT_START, 0.8), NIGHT_START, game_time))
	elif game_time > NIGHT_START or game_time < 2:
		sun.light_color = nighttime_color
	elif game_time >= 2 and game_time <= DAWN_START:
		sun.light_color = nighttime_color.lerp(dawntime_color, get_weight(2, DAWN_START, game_time))

func get_mid_value(start:float, end:float, t:float) -> float:
	return t * (end - start) + start
		
func get_weight(start:float, end:float, mid_val:float) -> float:
	return (mid_val - start) / (end - start)

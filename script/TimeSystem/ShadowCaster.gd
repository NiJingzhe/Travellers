extends DirectionalLight3D

@onready var root : SunSystem = self.get_parent() as SunSystem
@onready var angle_curve : Curve = root.angle_curve     #整体向左侧平移了0.25个循环
@onready var shadow_blur_curve : Curve = root.shadow_blur_curve
@onready var shadow_transparency_curve : Curve = root.shadow_transparency_curve
@onready var game_time = root.game_time
@onready var energy_curve : Curve = root.energy_curve
@onready var dawntime_color : Color = root.dawntime_color
@onready var daytime_color : Color = root.daytime_color
@onready var dusktime_color : Color = root.dusktime_color
@onready var nighttime_color : Color = root.nighttime_color
@onready var DAWN_START : float = 3.5
@onready var DAY_START : float = 6.5
@onready var DUSK_START : float = 17
@onready var NIGHT_START : float = 19.5

# Called when the node enters the scene tree for the first time.
func _ready():
	#angle_curve.bake()
	#shadow_blur_curve.bake()
	#shadow_transparency_curve.bake()
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	game_time = root.game_time
	self.light_energy = energy_curve.sample_baked(game_time / 24) * 0.6
	var temp_game_time = game_time / 24 - 0.25
	if temp_game_time < 0:
		temp_game_time += 1
	self.rotation_degrees.x = angle_curve.sample_baked(temp_game_time)
	self.shadow_blur = shadow_blur_curve.sample_baked(self.light_energy / 0.6)
	self.shadow_opacity = shadow_transparency_curve.sample_baked(self.light_energy / 0.6)
	
	if self.rotation_degrees.x > 10 and self.rotation_degrees.x < 170:
		self.shadow_enabled = false
	else:
		self.shadow_enabled = true
		
	if game_time >= DAWN_START and game_time <= get_mid_value(DAWN_START, DAY_START, 0.6):
		self.light_color = dawntime_color
	elif game_time > get_mid_value(DAWN_START, DAY_START, 0.6) and game_time <= DAY_START:
		self.light_color = dawntime_color.lerp(daytime_color, get_weight(get_mid_value(DAWN_START, DAY_START, 0.6), DAY_START, game_time))
	elif game_time > DAY_START and game_time <= get_mid_value(DAY_START, DUSK_START, 0.6):
		self.light_color = daytime_color
	elif game_time > get_mid_value(DAY_START, DUSK_START, 0.6) and game_time <= DUSK_START:
		self.light_color = daytime_color.lerp(dusktime_color, get_weight(get_mid_value(DAY_START, DUSK_START, 0.6), DUSK_START, game_time))
	elif game_time > DUSK_START and game_time <= get_mid_value(DUSK_START, NIGHT_START, 0.8):
		self.light_color = dusktime_color
	elif game_time > get_mid_value(DUSK_START, NIGHT_START, 0.8) and game_time < NIGHT_START:
		self.light_color = dusktime_color.lerp(nighttime_color, get_weight(get_mid_value(DUSK_START, NIGHT_START, 0.8), NIGHT_START, game_time))
	elif game_time > NIGHT_START or game_time < 2:
		self.light_color = nighttime_color
	elif game_time >= 2 and game_time <= DAWN_START:
		self.light_color = nighttime_color.lerp(dawntime_color, get_weight(2, DAWN_START, game_time))

func get_mid_value(start:float, end:float, t:float) -> float:
	return t * (end - start) + start
		
func get_weight(start:float, end:float, mid_val:float) -> float:
	return (mid_val - start) / (end - start)

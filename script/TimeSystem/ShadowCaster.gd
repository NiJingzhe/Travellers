extends DirectionalLight3D

@onready var root : SunSystem = self.get_parent() as SunSystem
@onready var angle_curve : Curve = root.angle_curve     #整体向左侧平移了0.25个循环
@onready var shadow_blur_curve : Curve = root.shadow_blur_curve
@onready var shadow_transparency_curve : Curve = root.shadow_transparency_curve
@onready var game_time = root.game_time
@onready var energy_curve : Curve = root.energy_curve
# Called when the node enters the scene tree for the first time.
func _ready():
	#angle_curve.bake()
	#shadow_blur_curve.bake()
	#shadow_transparency_curve.bake()
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	game_time = root.game_time
	self.light_energy = energy_curve.sample_baked(game_time / 24)
	var temp_game_time = game_time / 24 - 0.25
	if temp_game_time < 0:
		temp_game_time += 1
	self.rotation_degrees.x = angle_curve.sample_baked(temp_game_time)
	self.shadow_blur = shadow_blur_curve.sample_baked(self.light_energy)
	self.shadow_opacity = shadow_transparency_curve.sample_baked(self.light_energy)
	
	if self.rotation_degrees.x > 10 and self.rotation_degrees.x < 170:
		self.shadow_enabled = false
	else:
		self.shadow_enabled = true

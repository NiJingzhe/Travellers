@tool
extends Node3D
class_name SunSystem

@export var energy_curve : Curve
@export var dawntime_color : Color = Color(0,0,0,1)
@export var daytime_color : Color = Color(1, 1, 1, 1)
@export var dusktime_color : Color = Color(0,0,0,1)
@export var nighttime_color : Color = Color(0.2, 0.2, 0.5, 1)
@export var time_of_whole_day : float
@export var game_time : float = 12.0
@export var angle_curve : Curve      #整体向左侧平移了0.25个循环
@export var shadow_blur_curve : Curve
@export var shadow_transparency_curve : Curve


# Called when the node enters the scene tree for the first time.
func _ready():
	energy_curve.bake()
	angle_curve.bake()
	shadow_blur_curve.bake()
	shadow_transparency_curve.bake()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	game_time += 24 / time_of_whole_day / 10
	if game_time >= 24:
		game_time = 0

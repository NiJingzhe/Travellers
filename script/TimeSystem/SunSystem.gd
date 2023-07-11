@tool
extends Node3D
class_name SunSystem

#Energy Curve是light_energy关于game_time的函数，横坐标0-1对应game_time的0-24

#Shadow Blur Curve和Shadow Transparency Curve是阴影的模糊程度和透明度关于光强的函数

#Angle Curve比较特殊，虽然也是太阳角度关于game_time的函数，但是为了正确的处理间断点，
#整体曲线向左平移了0.25，即6 hours，这是为了让间断点产生在曲线边界，
#即其横坐标0-0.75对应的是game_time的6-24，0.75-1对应game_time的0-6，自定义曲线时要注意这点

@export var energy_curve : Curve
@export var angle_curve : Curve      #整体向左侧平移了0.25个循环
@export var shadow_blur_curve : Curve
@export var shadow_transparency_curve : Curve
@export var dawntime_color : Color = Color(0,0,0,1)
@export var daytime_color : Color = Color(1, 1, 1, 1)
@export var dusktime_color : Color = Color(0,0,0,1)
@export var nighttime_color : Color = Color(0.2, 0.2, 0.5, 1)
@export var time_of_whole_day : float
@export var game_time : float = 12.0
@export var DAWN_START : float = 3.5
@export var DAY_START : float = 6.5
@export var DUSK_START : float = 16.5
@export var NIGHT_START : float = 19.5


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

@tool
extends Node3D
class_name InteractableObject

@export var detect_area : Area3D
@export var detect_list : Array[String]
@onready var event_bubble : Signal = Signal(self, "event_bubble")
@onready var inside_area : Area3D = null

enum event_type {
	PLAYER_IN,
	PLAYER_OUT,
	PLAYER_INTERACT,
	SOMEONE_IN,
	SOMEONE_OUT,
	SOMEONE_INTERACT
}

const IN = 1
const OUT = 0

func init_interactable_object(listener : Callable):
	detect_area.monitoring = true
	detect_area.connect("area_entered", enter_call_back, CONNECT_PERSIST)
	detect_area.connect("area_exited", exit_call_back, CONNECT_PERSIST)
	self.add_user_signal(
		"event_bubble",
		[
			{"name" : "obj", "type" : InteractableObject},
			{"name" : "event", "type" : event_type},
			{"name" : "area", "type": Area3D}
		]
	)
	self.event_bubble.connect(listener)

func enter_call_back(area):
	if area.name in self.detect_list:
		self.detect_call_back(area, IN)
	
func exit_call_back(area):
	if area.name in self.detect_list:
		self.detect_call_back(area, OUT)
	
func detect_call_back(_area:Area3D, _in_or_out:int):
	pass

	


@tool
extends Node3D
class_name InteractableObject

@export var detect_area : Area3D
@export var detect_list : Array
@export var hint_text : RichTextLabel

const IN = 1
const OUT = 0

func init_interactable_object():
	detect_area.monitoring = true
	hint_text.visible = false
	detect_area.connect("area_entered", self.enter_call_back, CONNECT_PERSIST)
	detect_area.connect("area_exited", self.exit_call_back, CONNECT_PERSIST)
func enter_call_back(area):
	if area.name in self.detect_list:
		self.detect_call_back(area, IN)
	
func exit_call_back(area):
	if area.name in self.detect_list:
		self.detect_call_back(area, OUT)
	
func detect_call_back(area:Area3D, in_or_out:int):
	pass
	


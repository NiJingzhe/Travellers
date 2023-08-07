@tool
extends Node3D
class_name Map

@onready var ui : UI = %UI as UI

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func interactable_obj_event_listener(obj : InteractableObject, event : int):
	if obj.name == "box":
		if event == obj.event_type.PLAYER_IN:
			ui.show_element(ui.element_type.HINT_TEXT, {"text": "按F打开宝箱"})
		elif event == obj.event_type.PLAYER_OUT or event == obj.event_type.PLAYER_INTERACT:
			ui.hide_element(ui.element_type.HINT_TEXT)

@tool
extends Label
class_name HintText

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_hint(text_ : String):
	self.text = text_
	self.visible = true
	
func hide_hint():
	self.visible = false

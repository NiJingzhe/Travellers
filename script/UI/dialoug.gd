@tool
extends Control
class_name Dialoug

@onready var text_area : Label = %Label
@onready var image : TextureRect = %TextureRect 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_dialoug(text_ : String, image_ : String):
	self.text_area.text = text_
	self.image.texture.resource_path = image_
	self.visible = true
	
func hide_dialoug():
	self.visible = false

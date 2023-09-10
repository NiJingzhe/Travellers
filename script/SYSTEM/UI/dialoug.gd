@tool
extends Control
class_name Dialoug

@onready var text_area : Label = %Label
@onready var image : TextureRect = %TextureRect 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func show_dialoug(text_ : String, image_ : String, choices_ : Array[String]):
	self.text_area.text = text_
	self.image.texture.resource_path = image_
	self.visible = true
	
	if choices_ != []:
		var choices_num : int = len(choices_)
		var button_width : float = self.text_area.size.x / choices_num
		var start_x : float = self.text_area.position.x
		var start_y : float = self.text_area.position.y + self.text_area.size.y * 1.2
		for i in range(choices_num):
			var choice_box : TextureButton = TextureButton.new()
			var texture_normal : Texture2D = Texture2D.new()
			texture_normal.resource_path = "res://assets/texture/dialougSystem/ChoicesButton.png"
			choice_box.texture_normal = texture_normal
			choice_box.stretch_mode = TextureButton.STRETCH_SCALE
			choice_box.size.x = button_width * 0.8
			choice_box.size.y = 0.25 * choice_box.size.x
			choice_box.position.x = start_x + i * choice_box.size.x
			choice_box.position.y = start_y
			choice_box.visible = true
			choice_box.name = "choice%d" % (i+1)
			$DialougBox.add_child(choice_box)
			
func hide_dialoug():
	self.visible = false
	for child in $DialougBox.get_children():
		if child.name.contains("choice"):
			$DialougBox.remove_child(child)
	

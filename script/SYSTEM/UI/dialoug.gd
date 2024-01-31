extends Control
class_name Dialoug

@onready var text_area : Label = %Label
@onready var image : TextureRect = %TextureRect
@onready var chosen_maked : Signal = Signal(self, "chosen_maked")
# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_user_signal(
		"chosen_maked",
		[
			{"name" : "content", "type" : TYPE_STRING}
		]
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func show_dialoug(text_ : String, image_ : String, choices_ : Array, choose_call_back):
	self.text_area.text = text_
	self.image.texture.resource_path = image_ if image_ != "" else "res://assets/texture/role/test_girl1/立绘.png"
	self.visible = true
	if choose_call_back != null and not self.chosen_maked.is_connected(choose_call_back):
		self.chosen_maked.connect(choose_call_back, 4)
	if choices_.size() != 0:
		var choices_num : int = len(choices_)
		var button_width : float = self.text_area.size.x / choices_num
		var start_x : float = self.text_area.position.x
		var start_y : float = self.text_area.position.y + self.text_area.size.y * 1.2
		for i in range(choices_num):
			var choice_box : ChoiceButton = ChoiceButton.new()
			choice_box.name = "choice%d" % (i+1)
			$DialougBox.add_child(choice_box)
			choice_box.text = choices_[i]["content"]
			choice_box.choose_this.connect(choice_pressed_call_back)
			choice_box.size.x = button_width * 0.8
			choice_box.size.y = 0.25 * choice_box.size.x
			choice_box.position.x = start_x + i * choice_box.size.x * 1.2
			choice_box.position.y = start_y
			choice_box.visible = true
			choice_box.add_to_group("choice_box")

func hide_dialoug():
	self.visible = false
	for child in $DialougBox.get_children():
		if child.is_in_group("choice_box"):
			$DialougBox.remove_child(child)

func choice_pressed_call_back(content : String):
	self.chosen_maked.emit(content)


extends Button
class_name ChoiceButton

var choose_this : Signal = Signal(self, "choose_this")

func _ready():
	self.add_user_signal(
		"choose_this",
		[
			{"name" : "content", "type" : TYPE_STRING}
		]
	)

	self.pressed.connect(self.pressed_call_back, 4)

func pressed_call_back():
	self.choose_this.emit(self.text)

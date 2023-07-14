extends InteractableObject

@onready var player_in : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	self.detect_area = $InteractArea
	self.detect_list.append("PlayerArea")
	self.hint_text = $RichTextLabel
	self.init_interactable_object()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.hint_text.visible = player_in
	
func detect_call_back(area, in_or_out):
	if in_or_out == IN:
		if area.name == "PlayerArea":
			player_in = true
				
	if in_or_out == OUT:
		if area.name == "PlayerArea":
			player_in = false
			

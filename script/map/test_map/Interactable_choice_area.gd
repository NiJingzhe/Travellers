extends InteractableObject

@onready var map : Map = self.get_parent() as Map
var player_in : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	self.detect_area = $Area3D
	self.detect_list.append("PlayerArea")
	self.init_interactable_object(map.interactable_obj_event_listener)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player_in:
		if Input.is_action_just_pressed("map_element_interact"):
			self.event_bubble.emit(self, self.event_type.PLAYER_INTERACT, self.inside_area)


func detect_call_back(area, in_or_out):
	if in_or_out == IN:
		self.inside_area = area
		if area.name == "PlayerArea":
			player_in = true
			self.event_bubble.emit(self, self.event_type.PLAYER_IN, self.inside_area)

	if in_or_out == OUT:
		if area.name == "PlayerArea":
			player_in = false
			self.event_bubble.emit(self, self.event_type.PLAYER_OUT, self.inside_area)

		self.inside_area = null


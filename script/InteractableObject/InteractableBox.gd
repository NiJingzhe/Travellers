extends InteractableObject

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var light : OmniLight3D = $Light
@onready var player_in : bool  = false
@onready var map : Map = self.get_parent() as Map
# Called when the node enters the scene tree for the first time.
func _ready():
	self.detect_area = $Area3D
	self.detect_list.append("PlayerArea")
	self.init_interactable_object(map.interactable_obj_event_listener as Callable)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player_in:
		if Input.is_action_just_pressed("map_element_interact"):
			self.event_bubble.emit(self, self.event_type.PLAYER_INTERACT)
			animation_player.play("open")
	if animation_player.current_animation != "":
		light.light_energy = pow(animation_player.current_animation_position, 10) * 4

func detect_call_back(area, in_or_out):
	if in_or_out == IN:
		if area.name == "PlayerArea":
			player_in = true
			self.event_bubble.emit(self, self.event_type.PLAYER_IN)
			
	if in_or_out == OUT:
		var current_animation_pos = animation_player.current_animation_position
		if area.name == "PlayerArea":
			player_in = false
			self.event_bubble.emit(self, self.event_type.PLAYER_OUT)
			if current_animation_pos == 1.0:
				animation_player.play_backwards("open")


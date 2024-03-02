extends Camera3D

@onready var player_path : String = "/root/MainWorld/Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	var player : Player = self.get_node_or_null(player_path) as Player
	var player_cam : Camera3D
	if player :
		player_cam = player.player_cam

		self.global_transform = player_cam.global_transform
		self.size = player_cam.size
		self.near = player_cam.near
		self.far = player_cam.far
		self.environment = player_cam.environment
		self.attributes = player_cam.attributes
		self.h_offset = player_cam.h_offset
		self.v_offset = player_cam.v_offset

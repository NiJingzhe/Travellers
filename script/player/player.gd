extends CharacterBody3D
class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 5.0

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var animation_state = animation_tree.get('parameters/playback')

@onready var data_base : DataSheet = self.get_node("../DataBase") as DataSheet
@onready var player_sheet : DataSheet = self.get_node(data_base.query_log("sheet_name", "PlayerSheet")["sheet_path"]) as DataSheet

@onready var player_FSM : FSM = $PlayerFSM as FSM
@onready var climb_mode : bool = false
@onready var direction : Vector3 = Vector3.ZERO
@onready var last_direction : Vector3 = Vector3.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	animation_tree.active = true
	animation_player.speed_scale = 5
	if "PlayerPosition" not in self.player_sheet.get_all_segment_name():
		self.player_sheet.add_segment("PlayerPosition")
	else:
		self.position.x = self.player_sheet.get_value("PlayerPosition", 0)["x"]
		self.position.y = self.player_sheet.get_value("PlayerPosition", 0)["y"]
		self.position.z = self.player_sheet.get_value("PlayerPosition", 0)["z"]

	self.player_sheet.set_value("PlayerPosition", 0, {"x": self.position.x, "y": self.position.y, "z": self.position.z})

func _process(_delta):
	# Add the gravity.
	#self.position.x = self.player_sheet.get_value("PlayerPosition", 0)["x"]
	#self.position.y = self.player_sheet.get_value("PlayerPosition", 0)["y"]
	#self.position.z = self.player_sheet.get_value("PlayerPosition", 0)["z"]
	self.player_sheet.set_value("PlayerPosition", 0, {"x": self.position.x, "y": self.position.y, "z": self.position.z})


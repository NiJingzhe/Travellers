extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 5.0

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var animation_state = animation_tree.get('parameters/playback')

@onready var data_base : DataSheet = self.get_node("../DataBase") as DataSheet
@onready var player_sheet : DataSheet = self.get_node(data_base.query_log("sheet_name", "PlayerSheet")["sheet_path"]) as DataSheet

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

func _physics_process(delta):
	# Add the gravity.
	self.position.x = self.player_sheet.get_value("PlayerPosition", 0)["x"]
	self.position.y = self.player_sheet.get_value("PlayerPosition", 0)["y"]
	self.position.z = self.player_sheet.get_value("PlayerPosition", 0)["z"]
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	if input_dir != Vector2.ZERO:
		animation_tree.set('parameters/Idle/blend_position', input_dir)
		animation_tree.set('parameters/Walk/blend_position', input_dir)
		animation_state.travel('Walk')
	else:
		animation_state.travel('Idle')
	var direction = (transform.basis * Vector3(input_dir.y, 0, -input_dir.x)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

	self.player_sheet.set_value("PlayerPosition", 0, {"x": self.position.x, "y": self.position.y, "z": self.position.z})


func _on_save_area_area_entered(area):
	if area.name == "PlayerArea":
		print("进入存档点！")
		(data_base as DataBase).save_game()

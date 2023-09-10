extends State
class_name ClimbState


@onready var player : Player = self.get_parent().get_parent()
@onready var gravity = player.gravity

var last_direction : Vector3

func trans_check(new_state : State):
	if new_state == %NormalState:
		return not player.climb_mode
	else:
		return false
		
func state_process(_delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_just_pressed("ui_accept") and player.climb_mode:
		player.climb_mode = false
	
	var input_dir = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	var direction = (player.transform.basis * Vector3(input_dir.y, 0, -input_dir.x)).normalized()
	
	if direction:
		player.velocity.y = -direction.x * player.SPEED * 0.5
		#player.velocity.z = direction.z * player.SPEED
	else:
		player.velocity.y = -move_toward(player.velocity.y, 0, player.SPEED * 0.5)
		#player.velocity.z = move_toward(player.velocity.z, 0, player.SPEED)

	player.move_and_slide()
	
func into_state(_from : State):
	pass
	
func outof_state(_to : State):
	player.climb_mode = false
	print(player.last_direction)
	player.position.x += player.last_direction.x * 0.8
	player.position.z += player.last_direction.z * 0.8
	player.position.y += 0.1
	#player.move_and_slide()



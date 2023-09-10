extends State
class_name NormalState

@onready var player : Player = self.get_parent().get_parent()
@onready var gravity = player.gravity

func trans_check(new_state : State):
	if new_state == %ClimbState:
		return player.climb_mode
	else:
		return false
		
func state_process(delta):
	if not player.is_on_floor():
		player.velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and player.is_on_floor():
		player.velocity.y = player.JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	if input_dir != Vector2.ZERO:
		player.animation_tree.set('parameters/Idle/blend_position', input_dir)
		player.animation_tree.set('parameters/Walk/blend_position', input_dir)
		player.animation_state.travel('Walk')
	else:
		player.animation_state.travel('Idle')
	
	player.direction = (Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if player.direction:
		player.velocity.x = player.direction.x * player.SPEED
		player.velocity.z = player.direction.z * player.SPEED
		player.last_direction = player.direction
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
		player.velocity.z = move_toward(player.velocity.z, 0, player.SPEED)

	player.move_and_slide()
	
func into_state(_from : State):
	pass
	
func outof_state(_to : State):
	pass



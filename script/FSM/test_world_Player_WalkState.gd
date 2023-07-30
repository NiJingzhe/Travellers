extends State

func trans_check(new_state : State):
	if new_state.get_name() == "NullState":
		return IfStop()

	else:
		return false

func into_state(from : State):
	if from.get_name() == "NullState":
		Null2Walk()
	else:
		pass

func state_process(_delta):
	#print("Walking")
	pass

func outof_state(to : State):
	if to.get_name() == "NullState":
		print("离开Walk状态")
	else:
		return



func IfStop() -> bool:
	var flag: bool = false
	flag = flag || Input.is_action_just_released("walk_down")
	flag = flag || Input.is_action_just_released("walk_left")
	flag = flag || Input.is_action_just_released("walk_right")
	flag = flag || Input.is_action_just_released("walk_up")
	flag = flag && !Input.is_action_pressed("walk_down")
	flag = flag && !Input.is_action_pressed("walk_up")
	flag = flag && !Input.is_action_pressed("walk_left")
	flag = flag && !Input.is_action_pressed("walk_right")
	return flag

func Null2Walk():
	self.fsm.CurrentState = self.get_node("../WalkState") as State
	#测试用代码
	print("状态转移到了Walk")

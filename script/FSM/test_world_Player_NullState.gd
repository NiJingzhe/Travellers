extends State

func trans_check(new_state : State):
	if new_state.name == "WalkState":
		return Ifwalk()
	else:
		return false
	
func state_process(_delta):
	#print("Null")
	pass
	
func into_state(from : State):
	if from.name == "WalkState":
		Walk2Null()
	else:
		pass
	
func outof_state(to : State):
	if to.name == "WalkState":
		print("离开了NullState")
	else:
		pass


func Ifwalk():
	var flag: bool = false
	flag = flag || Input.is_action_just_pressed("walk_down")
	flag = flag || Input.is_action_just_pressed("walk_left")
	flag = flag || Input.is_action_just_pressed("walk_right")
	flag = flag || Input.is_action_just_pressed("walk_up")
	return flag
	
func Walk2Null():
	self.fsm.CurrentState = self.get_node("../NullState") as State
	#测试用代码
	print("状态转移到了Null")

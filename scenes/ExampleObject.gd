extends "FSM.gd"
var Testdict : Dictionary
# 映射字典， 从A状态到B状态的检测函数
var Procdict : Dictionary
# 执行字典，从A状态到B状态的转移函数
var CurrentState : Node 

# 第三个参数是函数类型，但是我不知道它的类型叫什么名字，，
# 把判断状态函数装进字典中
func add_to_Testdict(state1 : Node, state2 : Node, fun : Callable):
	if Testdict.has(state1):
		var tmp = Testdict[state1].duplicate()
		tmp[state2] = fun
		Testdict[state1] = tmp
	else: 
		var tmp = {state2 : fun}
		Testdict[state1] = tmp
	
	
func add_to_Procdict(state1 : Node, state2 : Node, fun : Callable):
	if Procdict.has(state1):
		var tmp = Procdict[state1].duplicate()
		tmp[state2] = fun
		Procdict[state1] = tmp
	else: 
		var tmp = {state2 : fun}
		Procdict[state1] = tmp

# Called when the node enters the scene tree for the first time.
func _ready():
	CurrentState = $NullState
	add_to_Testdict($NullState, $WalkState, Ifwalk)
	add_to_Procdict($NullState, $WalkState, Null2Walk)
	add_to_Testdict($WalkState, $NullState, IfStop)
	add_to_Procdict($WalkState, $NullState, Walk2Null)
	pass # Replace with function body.
	
# Null -> Walk
func Ifwalk():
	var flag: bool = false
	flag = flag || Input.is_action_just_pressed("walk_down")
	flag = flag || Input.is_action_just_pressed("walk_left")
	flag = flag || Input.is_action_just_pressed("walk_right")
	flag = flag || Input.is_action_just_pressed("walk_up")
	return flag
	
func Null2Walk():
	CurrentState = $WalkState
	#测试用代码
	print("状态转移到了Walk")


# Walk -> Null
func IfStop():
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
	
func Walk2Null():
	CurrentState = $NullState
	#测试用代码
	print("状态转移到了Null")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# 根据目前状态来遍历检测函数，如果符合条件则进行状态转移
	for NextState in Testdict[CurrentState].keys():
		var tes = Testdict[CurrentState][NextState]
		var pro = Procdict[CurrentState][NextState]
		if tes.call():
			pro.call()
			
		
	

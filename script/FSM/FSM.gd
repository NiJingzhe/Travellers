extends Node
class_name FSM

# 状态机架构阐述：
# FSM 作为 状态机的基类型，其子类为各个实体的状态机，如 PlayerFSM 就是 extends 自 FSM
# FSM 有一个 CurrentState 变量，用于记录当前状态，其类型为 State
# FSM 有一个 Testdict 变量，用于记录状态转移函数，其类型为 Dictionary
# 其第一级 key 代表 CurrentState，第二级 key 代表 NextState，两层 key 之后的 value 代表CurrentState 到 NextState 的转移函数

# State 作为 状态机的状态类型，其子类为各个实体的状态，如 WalkState 就是 extends 自 State
# State 有几个关键函数，分别是 into_state(from : State), outof_state(to : State), state_process(delta : float)
# into_state(from : State) 用于处理状态进入时的事物，包括更新CurrentState，from 代表上一个状态
# outof_state(to : State) 用于处理状态退出时的事物，to 代表下一个状态
# state_process(delta : float) 用于处理状态的逻辑，delta 代表时间间隔

# FSM 运作逻辑
# FSM 再进入场景树后，会尝试将自己的第一个子节点作为初始状态。
# 开发者在 某个实体的FSM 的_ready函数中通过add_relation添加状态转移关系
# FSM 运行时会循环检查与当前状态有通路连接的所有状态，如果通路上的检测函数返回true，则进行状态转移
# 状态转移过程分为：退出当前状态，进入新状态，开始运行新状态处理函数

var Testdict : Dictionary
# 执行字典，从A状态到B状态的转移函数
var CurrentState : State

#Private
func add_to_Testdict(state1 : State, state2 : State, fun : Callable):
	if Testdict.has(state1):
		var tmp = Testdict[state1].duplicate()
		tmp[state2] = fun
		Testdict[state1] = tmp
	else: 
		var tmp = {state2 : fun}
		Testdict[state1] = tmp

#Public
# 添加状态转移关系
func add_relation(from : State, to : State):
	add_to_Testdict(from, to, from.trans_check)

# 初始化状态机，将第一个状态作为初始状态
func init_FSM():
	self.CurrentState = self.get_children()[0]
	
func travel_to(state : State, force : bool = false):
	if force:
		self.CurrentState.outof_state(state)
		(state as State).into_state(self.CurrentState)
		self.CurrentState = state
	else:
		if Testdict.has(self.CurrentState):
			if Testdict[self.CurrentState].has(state):
				var tes : Callable = Testdict[self.CurrentState][state]
				if tes.call(state):
					self.CurrentState.outof_state(state)
					(state as State).into_state(self.CurrentState)
					self.CurrentState = state
				else:
					print("can't travel to " + state.get_name())
			else:
				print("can't travel to " + state.get_name())
		else:
			print("can't travel to " + state.get_name())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# 根据目前状态来遍历检测函数，如果符合条件则进行状态转移
	for NextState in Testdict[CurrentState].keys():
		var tes : Callable = Testdict[CurrentState][NextState]
		if tes.call(NextState):
			self.CurrentState.outof_state(NextState)
			(NextState as State).into_state(self.CurrentState)

	self.CurrentState.state_process(delta)
	

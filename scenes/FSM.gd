extends Node
class_name FSM

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# 我觉得以后可以用_physics_process.看其它教程有用。
# 上官网查了下这两个的区别应该在帧处理上有区别，理论上目前可以相互替代
func _process(delta : float):
	pass

# 读取当前对象的状态
func get_current_state(object : Node) -> Node:
	return object.CurrentState

# 转移状态
func transfer_state(object : Node, newstate : Node):
	var oldstate = get_current_state(object)
	object.transfer(oldstate, newstate)
	
# 有一说一我觉得这个类没啥用，，如果把检测环节全部下放的话
# 如果拿上来更简洁，如果拿上来可以考虑下，直接放到process里
# 如果不拿就当标题父节点好了（

extends FSM
class_name PlayerFSM

func _ready():
	self.init_FSM()
	self.add_relation($NormalState, $ClimbState)
	self.add_relation($ClimbState, $NormalState)

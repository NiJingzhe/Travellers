extends Node
class_name State

@onready var fsm : FSM = self.get_parent()

func trans_check(_new_state : State):
	pass
	
func state_process(_delta):
	pass
	
func into_state(_from : State):
	pass
	
func outof_state(_to : State):
	pass


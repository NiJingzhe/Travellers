extends Node
class_name Action

func execute_action(action : Dictionary):

	var command : String = action["command"]
	var param : Dictionary = action["param"]


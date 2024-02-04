extends Node
class_name ActionSystem

enum EVENT_TYPE {
	DISABLE_MOVE,
	ENABLE_MOVE,
	SET_SWITCH,
	DEL_SWITCH,
	NAVIGATE_TO
}

var event_mapping : Dictionary = {
	"disable_move" : EVENT_TYPE.DISABLE_MOVE,
	"enable_move" : EVENT_TYPE.ENABLE_MOVE,
	"set_switch" : EVENT_TYPE.SET_SWITCH,
	"del_switch" : EVENT_TYPE.DEL_SWITCH,
	"navigate_to" : EVENT_TYPE.NAVIGATE_TO
}

func execute_action(action : Dictionary):

	var event_type : String = action["command"]
	var param : Dictionary = action["param"]


	EventBus.publish_event(event_mapping[event_type], param)


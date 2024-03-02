extends Node
class_name ActionSystem

var event_mapping : Dictionary = {
	"disable_move" : EventBus.EVENT_TYPE.DISABLE_MOVE,
	"enable_move" : EventBus.EVENT_TYPE.ENABLE_MOVE,
	"set_switch" : EventBus.EVENT_TYPE.SET_SWITCH,
	"del_switch" : EventBus.EVENT_TYPE.DEL_SWITCH,
	"navigate_to" : EventBus.EVENT_TYPE.NAVIGATE_TO
}

func execute_action(action : Dictionary):

	var event_type : String = action["command"]
	var param : Dictionary = action["param"]


	EventBus.publish_event(event_mapping[event_type], param)


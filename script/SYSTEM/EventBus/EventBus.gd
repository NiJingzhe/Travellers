extends Node

enum EVENT_TYPE {
	DISABLE_MOVE,
	ENABLE_MOVE,
	SET_SWITCH,
	DEL_SWITCH,
	NAVIGATE_TO
}

var event_queue : Dictionary = {}


func subscribe_to_event(event_type : EVENT_TYPE, callback : Callable) -> void:
	if event_queue.has(event_type):
		event_queue[event_type].append(callback)
	else:
		event_queue[event_type] = [callback]

func unsubscribe_from_event(event_type : EVENT_TYPE, callback : Callable) -> void:
	if event_queue.has(event_type):
		event_queue[event_type].remove_at(event_queue[event_type].find(callback))

func publish_event(event_type : EVENT_TYPE, data : Dictionary) -> void:
	if event_queue.has(event_type):
		for callback in event_queue[event_type]:
			callback.call(data)

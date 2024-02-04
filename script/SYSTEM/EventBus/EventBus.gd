extends Node
class_name EventBus 

var event_queue : Dictionary = {}


func subscribe_to_event(event_name : String, callback : Callable) -> void:
	if event_queue.has(event_name):
		event_queue[event_name].append(callback)
	else:
		event_queue[event_name] = [callback]

func unsubscribe_from_event(event_name : String, callback : Callable) -> void:
	if event_queue.has(event_name):
		event_queue[event_name].remove_at(event_queue[event_name].find(callback))

func publish_event(event_name : String, data : Dictionary) -> void:
	if event_queue.has(event_name):
		for callback in event_queue[event_name]:
			callback.call(data)

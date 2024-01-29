extends Map
class_name TestMap

func _ready():
	self.switch_system.set_switch(
		"test_chapter",
		switch_system.SWITCH_TYPE.TOGGLE,
		switch_system.SWITCH_STATE.ON
	)
	
	self.switch_system.set_switch(
		"f_pressed",
		switch_system.SWITCH_TYPE.ONE_SHOT,
		switch_system.SWITCH_STATE.OFF
	)

func _process(_delta):
	
	if Input.is_action_just_pressed("map_element_interact"):
		self.switch_system.set_switch(
			"f_pressed",
			switch_system.SWITCH_TYPE.ONE_SHOT,
			switch_system.SWITCH_STATE.ON
		)
	else:
		self.switch_system.set_switch(
				"f_pressed",
				switch_system.SWITCH_TYPE.ONE_SHOT,
				switch_system.SWITCH_STATE.OFF
			)

func interactable_obj_event_listener(obj : InteractableObject, event : int, area : Area3D):
	if obj.name.contains("box"):
		if event == obj.event_type.PLAYER_IN:
			ui.show_element(ui.element_type.HINT_TEXT, {"text": "按F打开宝箱"})
			switch_system.set_switch(
				"close_to_box",
				switch_system.SWITCH_TYPE.TOGGLE,
				switch_system.SWITCH_STATE.ON
			)
		elif event == obj.event_type.PLAYER_INTERACT:
			ui.hide_element(ui.element_type.HINT_TEXT)
		else:
			ui.hide_element(ui.element_type.HINT_TEXT)
			switch_system.set_switch(
				"close_to_box",
				switch_system.SWITCH_TYPE.TOGGLE,
				switch_system.SWITCH_STATE.OFF
			)
			
	if obj.name.contains("ladder"):
		if event == obj.event_type.PLAYER_IN:
			ui.show_element(ui.element_type.HINT_TEXT, {"text": "按F进入攀爬"})
		elif event == obj.event_type.PLAYER_OUT or event == obj.event_type.PLAYER_INTERACT:
			ui.hide_element(ui.element_type.HINT_TEXT)
			if event == obj.event_type.PLAYER_OUT:
				var player = area.get_parent() as Player
				player.climb_mode = false
			else:
				var player = area.get_parent() as Player
				player.climb_mode = true

extends Node
class_name SwitchSystem

#三种开关状态，若定义了开关，则只能是ON或OFF
#若开关未定义，则处在UNDEF状态
enum SWITCH_STATE {
	ON,
	OFF,
	UNDEF
}

enum SWITCH_TYPE {
	ONE_SHOT,
	TOGGLE
}

@onready var switch_sheet : DataSheet = %SwitchSheet as DataSheet
@onready var switch_changed_signal : Signal = Signal(self, "switch_state_changed")

func _ready():
	self.add_user_signal(
		"switch_state_changed",
		[
			{"name": "switch_system", "type": SwitchSystem},
			{"name": "switch_name", "type": TYPE_STRING},
			{"name": "old_state", "type": SWITCH_STATE},
			{"name": "new_state", "type": SWITCH_STATE}
		]
	)

	switch_sheet.load_sheet(switch_sheet.SAVE_PATH)
	#var plot_system : PlotSystem = %PlotSystem as PlotSystem
	#self.switch_changed_signal.connect(plot_system.check_plot_update)


##定义开关，若开关不存在，则申请一个开关并设置为state状态
func set_switch(switch_name : String, switch_type : SWITCH_TYPE, state : SWITCH_STATE):

	var state_ : SWITCH_STATE = state
	if state_ == SWITCH_STATE.UNDEF:
		push_warning("SwitchSystem Warning : 在定义开关时状态不可为UNDEF，将自动改为OFF")
		state_ = SWITCH_STATE.OFF

	if switch_sheet.query_log("switch_name", switch_name) == {}:
		#写入数据表
		switch_sheet.add_log({"switch_name" : switch_name, "switch_type" : switch_type, "switch_state" : state_})
		if state_ != SWITCH_STATE.OFF:
			self.switch_changed_signal.emit(
				self,
				switch_name,
				SWITCH_STATE.UNDEF,
				state_
			)
	else:
		for i in range(0, switch_sheet.count_log()):
			if switch_sheet.get_value("switch_name", i) == switch_name:
				var old_state = switch_sheet.get_value("switch_state", i)
				switch_sheet.set_value("switch_state", i, state_)
				if state_ != old_state:
					self.switch_changed_signal.emit(
						self,
						switch_name,
						old_state,
						state_
					)

				break

##检查某个开关的状态
func check_switch(switch_name : String) -> SWITCH_STATE:

	var switch_log : Dictionary = switch_sheet.query_log("switch_name", switch_name)

	if switch_log != {}:
		return switch_log["switch_state"]
	else:
		return SWITCH_STATE.UNDEF

##删除一个开关
func del_switch(switch_name : String):

	var switch_log : Dictionary = switch_sheet.query_log("switch_name", switch_name)

	if switch_log != {}:
		#从表中删除
		for i in range(0, switch_sheet.count_log()):
			if switch_sheet.get_value("switch_name", i) == switch_name:
				if switch_sheet.get_value("switch_state", i) != SWITCH_STATE.OFF:
					var old_state = switch_sheet.get_value("switch_state", i)
					switch_sheet.del_log(i)
					self.switch_changed_signal.emit(
						self,
						switch_name,
						old_state,
						SWITCH_STATE.UNDEF
					)
				break
	else:
		push_warning("SwitchSystem Warning : 你正在尝试删除一个不存在的开关")

# 该函数用于进入下一个状态前更新 ONE SHOT 类开关的值
func update_switch():
	for i in range(0, switch_sheet.count_log()):
		if switch_sheet.get_value("switch_type", i) == SWITCH_TYPE.ONE_SHOT:
			var old_state : SWITCH_STATE = switch_sheet.get_value("switch_state", i)
			if old_state == SWITCH_STATE.ON:
				switch_sheet.set_value("switch_state", i, SWITCH_STATE.OFF)


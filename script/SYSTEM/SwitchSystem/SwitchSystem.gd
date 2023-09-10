@tool
extends Node
class_name SwitchSystem

#三种开关状态，若定义了开关，则只能是ON或OFF
#若开关未定义，则处在UNDEF状态
enum SWITCH_STATE {
	ON,
	OFF,
	UNDEF
}

@onready var switch_sheet : DataSheet = %SwitchSheet as DataSheet
@onready var data_base : DataBase = %DataBase as DataBase

##定义开关，若开关不存在，则申请一个开关并设置为state状态
func set_switch(name : String, state : SWITCH_STATE):
	
	var state_ : SWITCH_STATE = state
	if state_ == SWITCH_STATE.UNDEF:
		push_warning("SwitchSystem Warning : 在定义开关时状态不可为UNDEF，将自动改为OFF")
		state_ = SWITCH_STATE.OFF
	
	if switch_sheet.query_log("switch_name", name) == {}:
		#写入数据表
		switch_sheet.add_log({"switch_name" : name, "switch_state" : state_})
	else:
		for i in range(0, switch_sheet.count_log()):
			if switch_sheet.get_value("switch_name", i) == name:
				switch_sheet.set_value("switch_state", i, state_)
				break
	
##检查某个开关的状态
func check_switch(name : String) -> bool:
	
	var switch_log : Dictionary = switch_sheet.query_log("switch_name", name)
	
	if switch_log != {}:
		return switch_log["switch_state"]
	else:
		return SWITCH_STATE.UNDEF
		
##删除一个开关
func del_switch(name : String):
	
	var switch_log : Dictionary = switch_sheet.query_log("switch_name", name)
	
	if switch_log != {}:
		#从表中删除
		for i in range(0, switch_sheet.count_log()):
			if switch_sheet.get_value("switch_name", i) == name:
				switch_sheet.del_log(i)
				break
	else:
		push_warning("SwitchSystem Warning : 你正在尝试删除一个不存在的开关")

extends Node
class_name PlotSystem

# 剧情系统

var current_plot_file : Dictionary = {}
@onready var plot_sheet : PlotSheet = %PlotSheet as PlotSheet
@onready var switch_system : SwitchSystem = %SwitchSystem as SwitchSystem

# Called when the node enters the scene tree for the first time.
func _ready():

	if plot_sheet == null:
		push_error("Error : 剧情系统初始化失败，无法读取剧情表节点")
		return

	if plot_sheet.count_log() == 0:
		plot_sheet.load_sheet(plot_sheet.SAVE_PATH)
		
	var plot_file_name :String = ""

	# 根据开关系统状态决定读取哪一个剧情文件
	for i in range(0, plot_sheet.count_log()):
		var temp_plot_file_name = plot_sheet.get_value("plot_file", i)
		var require_on_list = plot_sheet.get_value("require_on", i)
		var require_off_list = plot_sheet.get_value("require_off", i)

		var check_pass = true

		for require_on in require_on_list:
			if switch_system.check_switch(require_on) != switch_system.SWITCH_STATE.ON:
				check_pass = false
				break
				
		if check_pass == false:
			continue

		for require_off in require_off_list:
			if switch_system.check_switch(require_off) != switch_system.SWITCH_STATE.OFF:
				check_pass = false
				break
		
		if check_pass == false:
			continue

		if check_pass:
			plot_file_name = temp_plot_file_name
			break
			
	
	current_plot_file = JSON.parse_string(
		(FileAccess.open("res://assets/plots/"+plot_file_name, FileAccess.READ)).get_as_text()
	) as Dictionary
	
	var head_list = current_plot_file["head_list"] as Array

	for head in head_list:
		var ids = head
		var plot_chain : Array[Dictionary] = []
		var head_plot : Dictionary = self.get_plot(current_plot_file, head)
		plot_chain.append(head_plot)
		ids = (head_plot["next"] as Array).duplicate()
		
		while ids != []:
			
			for id in ids:
				var plot_dict = self.get_plot(current_plot_file, id)
				if not plot_dict in plot_chain:
					plot_chain.append(plot_dict)
				
				ids.remove_at(ids.find(id))
				for next_id in plot_dict["next"]:
					if not next_id in ids && next_id != -head:
						ids.append(next_id)

		var plot_chain_node : PlotChain = PlotChain.new()
		plot_chain_node.name = current_plot_file["file_name"] + "_" + "headid_" + str(head)
		plot_chain_node.init_plot_chain(plot_chain.duplicate(true))
		self.add_child(plot_chain_node)


func get_plot(plot_file : Dictionary, id : int) -> Dictionary:

	for plot in plot_file["plots"]:
		if plot["id"] == id:
			return (plot as Dictionary)

	push_warning("PlotSystem Warning : 未找到id为"+str(id)+"的剧情")
	return {}

	

	

		







	







	

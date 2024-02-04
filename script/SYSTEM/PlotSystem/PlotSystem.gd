extends Node
class_name PlotSystem

# 剧情系统

# 剧情系统首先会读取plot sheet中的每一条记录，每一条记录中包含了剧情文件名，该文件的进度，使用该文件的条件
# 根据读取的剧情文件，剧情系统将会把剧情文件中每一条剧情链抽出，并生成PlotChain子结点（本质是一个FSM）
# 每一个PlotChain节点会在每一个frame中进行状态转移判定，并作出相应的状态转移操作
# 当所有的PlotChain都完成一次状态转移检查的时候，剧情系统会负责自动更新一次开关系统以关闭打开的 ONE_SHOT 类开关
# PlotChain作为FSM的派生类能够检查是否进入了剧情链的结尾状态，如果进入了结尾状态则会上报剧情系统将自己从节点树中删除

var current_plot_file : Dictionary = {}
var plot_chain_transfer_checked_counter = 0
var plot_chain_num : int = 0
@onready var plot_sheet : PlotSheet = %PlotSheet as PlotSheet
@onready var switch_system : SwitchSystem = %SwitchSystem as SwitchSystem
@onready var ui : UI = %UI as UI
@onready var action_system : ActionSystem = %ActionSystem as ActionSystem

# Called when the node enters the scene tree for the first time.
func _ready():

	if plot_sheet == null:
		push_error("PlotSystem Error : 剧情系统初始化失败，无法读取剧情表节点")
		return

	if plot_sheet.count_log() == 0:
		plot_sheet.load_sheet(plot_sheet.SAVE_PATH)

	var plot_file_name : String = ""

	# 根据开关系统状态决定读取哪一个剧情文件
	for i in range(0, plot_sheet.count_log()):
		var temp_plot_file_name = plot_sheet.get_value("plot_file", i)

		# 下面这一段代码用于检查作为剧情文件触发条件的开关
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

		# 如果检查到一个符合条件的剧情文件就将其作为目前要使用的剧情文件
		# 从设计上需要规避某个一组条件能够触发多个剧情文件的情况

		if check_pass:
			plot_file_name = temp_plot_file_name
			break


	# 读取当前的剧情文件为一个字典
	# 一个剧情文件中可以有多个剧情链条，剧情链条的概念就是一串能够从头连续触发的剧情
	# 所以一个剧情文件中包含有一个head list以声明每一个剧情链条的头剧情
	current_plot_file = JSON.parse_string(
		(FileAccess.open("res://assets/plots/"+plot_file_name, FileAccess.READ)).get_as_text()
	) as Dictionary

	# 获取head list
	var head_list = current_plot_file["head_list"] as Array
	# 获取progress dict，其中包含了每一条剧情链的进度
	var progress_dict = self.plot_sheet.query_log("plot_file", current_plot_file["file_name"])["progress"]

	# 通过head list遍历每一个剧情链，并开始抽链操作
	for head in head_list:
		var ids = head
		var plot_chain : Array[Dictionary] = []
		var head_plot : Dictionary = self.get_plot(current_plot_file, head)
		plot_chain.append(head_plot)
		ids = (head_plot["next"] as Array[int]).duplicate(true)
		if ids.size() == 0:
			for choice in head_plot["choices"]:
				for id in choice["next"]:
					ids.append(id)

		# 因为不关注plot之间的互相关系，仅仅是整理出一整条剧情链，所以用了大家喜闻乐见的BFS（

		while ids != []:
			for id in ids:
				var plot_dict = self.get_plot(current_plot_file, id)
				if not plot_dict in plot_chain:
					plot_chain.append(plot_dict)

				ids.remove_at(ids.find(id))
				if plot_dict["next"].size() == 0:
					for choice in plot_dict["choices"]:
						for next_id in choice["next"]:
							if not next_id in ids && next_id != -head:
								ids.append(next_id)
				else:
					for next_id in plot_dict["next"]:
						if not next_id in ids && next_id != -head:
							ids.append(next_id)

		var plot_chain_node : PlotChain = PlotChain.new()
		plot_chain_node.name = current_plot_file["file_name"] + "_" + "headid_" + str(head)
		plot_chain_node.init_plot_chain(plot_chain.duplicate(true), head, progress_dict[str(head)])
		self.add_child(plot_chain_node)
		self.plot_chain_num += 1



func get_plot(plot_file : Dictionary, id : int) -> Dictionary:

	for plot in plot_file["plots"]:
		if plot["id"] == id:
			return (plot as Dictionary)

	push_warning("PlotSystem Warning : 未找到id为"+str(id)+"的剧情")
	return {}

# 检查所有Plot Chain都完成状态转移检查的call back
func all_chain_transfer_check_finished():
	self.plot_chain_transfer_checked_counter += 1
	if self.plot_chain_transfer_checked_counter == self.plot_chain_num:
		switch_system.update_switch()
		self.plot_chain_transfer_checked_counter = 0

# PlotChain完成的删除上报call back
func remove_plot_chain(plot_chain : PlotChain):
	self.remove_child(plot_chain)
	self.plot_chain_num -= 1






















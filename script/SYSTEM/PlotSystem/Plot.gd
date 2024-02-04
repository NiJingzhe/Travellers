extends State
class_name Plot

var id : int
var content : Dictionary
var action : Array
var next : Array
var choices : Array
var require_on : Array
var require_off : Array
var type : String

var have_shown : bool = false
var chosen : String = ""

@onready var plot_chain : PlotChain = self.get_parent()
@onready var plot_system : PlotSystem = self.get_node("/root/MainWorld/PlotSystem") as PlotSystem
@onready var ui : UI = self.get_node("/root/MainWorld/UI") as UI


func init_plot(plot_ : Dictionary):
	id = plot_["id"]
	content = plot_["content"]
	type = plot_["type"]
	action = plot_["action"] as Array
	next = plot_["next"] as Array
	choices = plot_["choices"] as Array
	require_on = plot_["require_on"] as Array
	require_off = plot_["require_off"] as Array

# 用于检查plot是否满足转移条件，由于在PlotChain中使用了DFS构建relation所以剧情之间的顺序关系已经包含在Tesdict中了
# 该函数几乎只进行switch检查
func check_plot(switch_system : SwitchSystem, plot : Plot) -> bool:

	# 通俗易懂的 switch 检查部分
	var require_on_list = plot.require_on as Array
	var require_off_list = plot.require_off as Array

	var check_pass = true

	for require_on_ in require_on_list:
		if switch_system.check_switch(require_on_) != switch_system.SWITCH_STATE.ON:
			check_pass = false
			break

	for require_off_ in require_off_list:
		if switch_system.check_switch(require_off_) != switch_system.SWITCH_STATE.OFF:
			check_pass = false
			break

	# 当当前的剧情是一个选择剧情的时候 (choices.size() > 0)
	# 该剧情在process中会调用ui相关接口展示选择框
	# 在ui中作出选择会触发回调传回被选择选项的内容
	var choice_result_ids : Array[int] = []
	if self.choices.size() > 0:
		for choice in self.choices:
			# 这时候和自己选项内容作匹配，获得作出选择的结果列表
			if (choice["content"] as String) == (self.chosen as String):
				for id_ in choice["next"]:
					choice_result_ids.append(int(id_))
				break
		# 如果plot是选择的可能结果之一，那么可以跳转
		# 从设计上应该避开某一时刻某个选择能够触发多个结果的情况
		if plot.id not in choice_result_ids:
			check_pass = false

	# 当然能够转移到下一个剧情还有一个条件是当前剧情已经完成了
	return check_pass and self.have_shown

# 这个函数用于在process中检查自身是否应该显示，例如靠近某个物体触发的剧情效果在远离该物体时不应该显示
# 但是该函数不会检查f_pressed开关，因为该开关是一个 one shot 开关，如果检查则任何剧情都会在触发的一瞬间取消显示
func busy_self_check(switch_system : SwitchSystem) -> bool:
	var require_on_list = self.require_on as Array
	var require_off_list = self.require_off as Array

	var check_pass = true

	for require_on_ in require_on_list:
		if require_on_ != "f_pressed":
			if switch_system.check_switch(require_on_) != switch_system.SWITCH_STATE.ON:
				check_pass = false
				break

	for require_off_ in require_off_list:
		if require_off_ != "f_pressed":
			if switch_system.check_switch(require_off_) != switch_system.SWITCH_STATE.OFF:
				check_pass = false
				break

	return check_pass


# override State的状态转移检查函数
func trans_check(new_state : State):
	var new_plot = new_state as Plot
	return check_plot(self.plot_chain.switch_system, new_plot)

# override State的process
func state_process(_delta):

	var during_satisfy = self.busy_self_check(self.plot_chain.switch_system)

	# dummy head 剧情节点将会直接结束
	if self.id == 0:
		self.have_shown = true

	# 求解process是否进行的条件
	# 只有在 未显示过 和 期间满足 两个条件下 才会调用ui接口显示内容
	var can_process = not self.have_shown and                                  \
					  during_satisfy


	if can_process:

		# 根据 type 决定调用 ui 接口的行为

		# 决定 image
		var image : String = ""
		if self.type == "narration":
			image = ""
		elif self.type == "monologue":
			image = "res://assets/texture/role/model_character_avater.png"

		# 决定选择列表
		var choices_ = []
		if self.choices.size() == 0:
			# 显示过是一个 one shot 的flag
			self.have_shown = true
		elif self.choices.size() > 0:
			choices_ = self.choices.duplicate(true)

		ui.show_element(ui.element_type.DIALOUG, {
				"text" : self.content["text"],
				"image" : image,
				"choices" : choices_.duplicate(true),
				"chosen_call_back" : self.chosen_call_back
		})

	# 如果期间不满足了，再次进入时需要重新显示，所以需要把 have_shown 重新设置为false
	if not during_satisfy:
		ui.hide_element(ui.element_type.DIALOUG)
		self.have_shown = false


# override
func into_state(_from : State):

	# 如果是 end plot，在进入的时候就直接结束并返回了
	if self.id == -self.plot_chain.head_id:
		self.have_shown = true
		return

	# 对于实际剧情节点，每次进入该剧情时需要更新progress
	var new_progress_dict : Dictionary = self.plot_chain.plot_sheet.query_log(
		"plot_file", self.plot_system.current_plot_file["file_name"]
	)["progress"]
	new_progress_dict[str(self.plot_chain.head_id)] = self.id
	self.plot_system.plot_sheet.set_value(
		"progress",
		self.plot_system.plot_sheet.find(
			"plot_file",
			self.plot_system.current_plot_file["file_name"]
		)[0],
		new_progress_dict
	)

	self.chosen = ""
	self.have_shown = false

# override
func outof_state(_to : State):
	self.chosen = ""
	self.have_shown = false
	ui.hide_element(ui.element_type.DIALOUG)

# 做出选择call back
func chosen_call_back(content_ : String):
	self.chosen = content_
	self.have_shown = true


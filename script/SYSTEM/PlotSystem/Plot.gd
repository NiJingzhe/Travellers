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

var finished : bool = false
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


func check_plot(switch_system : SwitchSystem, plot : Plot) -> bool:

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

	var choice_result_ids : Array[int] = []
	if self.choices.size() > 0:
		for choice in self.choices:
			if (choice["content"] as String) == (self.chosen as String):
				for id_ in choice["next"]:
					choice_result_ids.append(int(id_))
				break

		if plot.id not in choice_result_ids:
			check_pass = false

	return check_pass and self.finished

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



func trans_check(new_state : State):
	var new_plot = new_state as Plot
	return check_plot(self.plot_chain.switch_system, new_plot)


func state_process(_delta):

	var during_satisfy = self.busy_self_check(self.plot_chain.switch_system)

	if self.id == 0:
		self.finished = true

	if not finished and during_satisfy:
		if self.choices.size() == 0:
			ui.show_element(
				ui.element_type.DIALOUG,
				{
					"text" : self.content["text"],
					"image" : "",
					"choices" : [],
					"chosen_call_back" : null
				}
			)
			self.finished = true

		elif self.choices.size() > 0:
			ui.show_element(ui.element_type.DIALOUG, {
				"text" : self.content["text"],
				"image" : "",
				"choices" : self.choices.duplicate(true),
				"chosen_call_back" : self.chosen_call_back
			})

	if not during_satisfy:
		ui.hide_element(ui.element_type.DIALOUG)
		self.finished = false



func into_state(_from : State):

	if self.id == -self.plot_chain.head_id or id == 0:
		finished = true
		return

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
	self.finished = false

func outof_state(_to : State):
	self.chosen = ""
	self.finished = false
	ui.hide_element(ui.element_type.DIALOUG)


func chosen_call_back(content_ : String):
	self.chosen = content_
	self.finished = true


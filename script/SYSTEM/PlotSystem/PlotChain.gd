extends FSM
class_name PlotChain

var plot_chain : Array[Dictionary]
var transfer_check_finished : Signal = Signal(self, "transfer_check_finished")
var self_finished : Signal = Signal(self, "self_finished")
var head_id : int = 0
@onready var switch_system : SwitchSystem = self.get_parent().switch_system as SwitchSystem
@onready var plot_sheet : PlotSheet = self.get_parent().plot_sheet as PlotSheet
@onready var ui : UI = self.get_parent().ui as UI

func _ready():
	self.transfer_check_finished.connect((self.get_parent() as PlotSystem).all_chain_transfer_check_finished)
	self.self_finished.connect((self.get_parent() as PlotSystem).remove_plot_chain)
func init_plot_chain(plot_chain_to_init : Array[Dictionary], head_id_ : int, progress : int = 0):

	self.add_user_signal(
		"transfer_check_finished",
		[]
	)

	self.add_user_signal(
		"self_finished",
		[
			{"name" : "plot_chain", "type" : PlotChain}
		]
	)

	plot_chain = plot_chain_to_init
	head_id = head_id_

	# 添加一个dummy head和一个end节点，这样每一个实际剧情节点的操作就能够被统一了
	var dummy_head : Dictionary = {
		"action": [
		],
		"content": {
			"text" : ""
		},
		"id": 0,
		"next": [
			plot_chain[0]["id"]
		],
		"require_off": [],
		"require_on": [],
		"choices": [],
		"type": "dummy_head"
	}

	var end_plot : Dictionary = {
		"action": [
		],
		"content": {
			"text" : ""
		},
		"id": -head_id,
		"next": [],
		"require_off": [],
		"require_on": ["f_pressed"],
		"choices": [],
		"type": "end_plot"
	}

	plot_chain.append(end_plot)
	plot_chain.append(dummy_head)

	self.init_relation(dummy_head)

	for child in self.get_children():
		if (child as Plot).id == progress:
			self.CurrentState = child
			break


# 通过深度优先便利创建剧情之间的relation
func init_relation(current_plot : Dictionary):
	if current_plot["id"] == -head_id:
		var plot = Plot.new()
		plot.name = self.name + "_end"
		plot.init_plot(current_plot)
		self.add_child(plot)
		return

	var plot = Plot.new()
	plot.name = self.name + "_" + str(current_plot["id"])
	plot.init_plot(current_plot)
	self.add_child(plot)

	var relation_ids : Array[int] = []
	var need_create_plot_ids : Array[int] = []
	if plot.next.size() != 0:
		for id in plot.next:
			relation_ids.append(int(id))

	else:
		for choice in plot.choices:
			for id in choice["next"]:
				relation_ids.append(int(id))

	need_create_plot_ids = relation_ids.duplicate(true)

	for child in self.get_children():
		if (child as Plot).id in need_create_plot_ids:
			need_create_plot_ids.remove_at(need_create_plot_ids.find((child as Plot).id))

	for plot_dict in self.plot_chain:
		if int(plot_dict["id"]) in need_create_plot_ids:
			init_relation(plot_dict)

	for child in self.get_children():
		if int((child as Plot).id) in relation_ids:
			self.add_relation(plot, (child as Plot))


func _process(delta):
	super._process(delta)
	if self.CurrentState.id == -head_id:
		for child in self.get_children():
			self.remove_child(child)


	self.transfer_check_finished.emit()





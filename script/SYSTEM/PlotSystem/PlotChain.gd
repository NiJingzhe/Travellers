extends FSM
class_name PlotChain

var plot_chain : Array[Dictionary]

@onready var switch_system : SwitchSystem = self.get_parent().switch_system as SwitchSystem

func init_plot_chain(plot_chain_to_init : Array[Dictionary]):
	plot_chain = plot_chain_to_init

	var dummy_head : Plot = Plot.new()
	dummy_head.init_plot({
		"action": [
		],
		"content": {
		},
		"id": 0,
		"next": [
			plot_chain[0]["id"]
		],
		"require_off": [],
		"require_on": [],
		"choices": [],
		"type": "dummy_head"
	})
	dummy_head.name = self.name + "_" + str(dummy_head.id)
	self.add_child(dummy_head)
	
	var pre_plot : Plot = Plot.new()
	pre_plot.init_plot(plot_chain[0])
	pre_plot.name = self.name + "_" + str(pre_plot.id)
	self.add_child(pre_plot)
	self.add_relation(dummy_head, pre_plot)
	var next_plots_ids : Array = pre_plot.next
	while !(next_plots_ids.size() == 1 && next_plots_ids[0] == -plot_chain[0]["id"] or next_plots_ids.size() == 0):
		for next_plot_id in next_plots_ids:
			var new_plot = Plot.new()
			for plot_dict in plot_chain:
				if plot_dict["id"] == next_plot_id:
					new_plot.init_plot(plot_dict)
					new_plot.name = self.name + "_" + str(new_plot.id)
					self.add_child(new_plot)
					self.add_relation(pre_plot, new_plot)
					break
			next_plots_ids = new_plot.next
			pre_plot = new_plot

	
	self.CurrentState = dummy_head
	

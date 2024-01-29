extends State
class_name Plot 

var id : int
var content : Dictionary
var action : Array
var next : Array
var choices : Array
var require_on : Array
var require_off : Array

@onready var plot_chain : PlotChain = self.get_parent()

func init_plot(plot_ : Dictionary):
	id = plot_["id"]
	content = plot_["content"]
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

	return check_pass


func trans_check(new_state : State):
	var new_plot = new_state as Plot
	return check_plot(plot_chain.switch_system, new_plot)

	
func state_process(_delta):
	pass
	
func into_state(_from : State):
	print("++++++++++++++++++++++++++++++++++++")
	print("enter plot :\nid :", self.id)
	print("content :", self.content)
	print("action :", self.action)
	print("choices :", self.choices)
	print("require_on :", self.require_on)
	print("require_off :", self.require_off)
	print("next :", self.next)

	
func outof_state(_to : State):
	print("out of plot :\nid :", self.id)
	print("+++++++++++++++++++++++++++++++++++++")


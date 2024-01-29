extends DataSheet
class_name PlotSheet

var SAVE_PATH : String = "res://save/plot_sheet.json"
var PLOT_RES_PATH : String = "res://assets/plots/plots_list.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.init_sheet(["plot_file", "require_on", "require_off", "possible_id_list_stack", "excluded_head_list"])



func load_sheet(load_path : String):

	if FileAccess.file_exists(load_path) == false:
		push_warning("DataSystem WARNING：你正在尝试从磁盘加载一个不存在的数据表！")
		return
	var load_file = FileAccess.open(load_path, FileAccess.READ)
	self.data_sheet.merge((JSON.parse_string(load_file.get_as_text()) as Dictionary), true)
	load_file.close()

	if self.count_log() == 0:
		push_warning("PlotSystem WARNING：目前没有任何剧情序列化信息！")

		if FileAccess.file_exists(PLOT_RES_PATH) == false:
			push_warning("PlotSystem WARNING：你正在尝试从磁盘加载一个不存在的剧情配置列表！")
			return
		
		var plot_res_file = FileAccess.open(PLOT_RES_PATH, FileAccess.READ)
		var plot_res_list = JSON.parse_string(plot_res_file.get_as_text()) as Dictionary

		for plots_file_name in plot_res_list["plots_list"]:
			
			var plots_file = JSON.parse_string(
				FileAccess.open("res://assets/plots/"+plots_file_name, FileAccess.READ).get_as_text()
			) as Dictionary

			var init_stack : Stack = Stack.new()
			init_stack.push(plots_file["head_list"])
			
			self.add_log(
				{
					"plot_file" : plots_file["file_name"], 
					"require_on" : plots_file["require_on"], 
					"require_off" : plots_file["require_off"], 
					"possible_id_list_stack" : init_stack,
					"excluded_head_list" : []
				}
			)




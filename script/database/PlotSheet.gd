extends DataSheet
class_name PlotSheet

var PLOT_RES_PATH : String = "res://assets/plots/plots_list.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	# progress中存放一个字典，key为head id，value为该head的进度，即该head下的一个plot id
	SAVE_PATH = "res://save/plot_sheet.json"
	self.init_sheet(["plot_file", "require_on", "require_off", "progress"])



func load_sheet(load_path : String):

	super.load_sheet(load_path)

	if self.count_log() == 0:
		push_warning("PlotSystem WARNING：目前没有任何剧情序列化信息！")

		if FileAccess.file_exists(PLOT_RES_PATH) == false:
			push_error("PlotSystem ERROR：你正在尝试从磁盘加载一个不存在的剧情配置列表！")
			return

		var plot_res_file = FileAccess.open(PLOT_RES_PATH, FileAccess.READ)
		var plot_res_list = JSON.parse_string(plot_res_file.get_as_text()) as Dictionary
		plot_res_file.close()

		for plots_file_name in plot_res_list["plots_list"]:

			var plots_file = JSON.parse_string(
				FileAccess.open("res://assets/plots/"+plots_file_name, FileAccess.READ).get_as_text()
			) as Dictionary

			var empty_progress_dict = {}
			for head_id in plots_file["head_list"]:
				empty_progress_dict[str(head_id)] = 0

			self.add_log(
				{
					"plot_file" : plots_file["file_name"],
					"require_on" : plots_file["require_on"],
					"require_off" : plots_file["require_off"],
					"progress" : empty_progress_dict
				}
			)




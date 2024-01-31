extends DataSheet


func _ready():
	SAVE_PATH = "res://save/time_sheet.json"
	self.init_sheet(["GameTime"])
	self.add_log({"GameTime" : 2})


extends DataSheet

var SAVE_PATH : String = "res://save/time_sheet.json"

func _ready():
	self.init_sheet(["GameTime"])
	self.add_log({"GameTime" : 2})
	

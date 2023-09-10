extends DataSheet

var SAVE_PATH : String = "res://save/switch_sheet.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.init_sheet(["switch_name", "switch_state"])

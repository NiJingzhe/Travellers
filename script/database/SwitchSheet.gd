extends DataSheet

# Called when the node enters the scene tree for the first time.
func _ready():
	SAVE_PATH = "res://save/switch_sheet.json"
	self.init_sheet(["switch_name", "switch_type", "switch_state"])

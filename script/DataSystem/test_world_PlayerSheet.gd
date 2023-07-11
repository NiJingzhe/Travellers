extends DataSheet

var SAVE_PATH : String = "res://save/player_sheet.json"

func _ready():
	self.init_sheet(["Name", "Wear", "HealthState", "HealthProblemDescription"])
	self.add_log({"Name": "TestPlayerName", "Wear":"Model Character", "HealthState": "Well", "HealthProblemDescription": "You are totally well"})
	

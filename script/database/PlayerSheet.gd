extends DataSheet



func _ready():
	SAVE_PATH = "res://save/player_sheet.json"
	self.init_sheet(["Name", "Wear", "HealthState", "HealthProblemDescription"])
	self.add_log({"Name": "TestPlayerName", "Wear":"Model Character", "HealthState": "Well", "HealthProblemDescription": "You are totally well"})


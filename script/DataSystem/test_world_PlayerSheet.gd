extends DataSheet

func _ready():
	self.init_sheet(["Name", "Wear", "HealthState", "HealthProblemDescription"])
	self.add_log({"Name": "TestPlayerName", "Wear":"Model Character", "HealthState": "Well", "HealthProblemDescription": "You are totally well"})
	

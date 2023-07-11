extends DataSheet

func _ready():
	self.init_sheet(["GameTime"])
	self.add_log({"GameTime" : 0})
	

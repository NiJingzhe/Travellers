extends DataSheet

func _ready():
	self.init_sheet(["sheet_name", "sheet_node"])
	for child_node in self.get_children():
		self.add_log({"sheet_name" : child_node.name, "sheet_node" : child_node})
		
	

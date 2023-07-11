extends DataSheet
class_name DataBase
func _ready():
	self.init_sheet(["sheet_name", "sheet_path"])
	for child_node in self.get_children():
		self.add_log({"sheet_name" : child_node.name, "sheet_path" : child_node.get_path()})
	self.load_game()
		
func _process(delta):
	if Input.is_key_pressed(KEY_F1):
		print("保存游戏！")
		self.save_game()	
	if Input.is_key_pressed(KEY_F2):
		print("载入游戏！")
		self.load_game()	

func save_game():
	for child_node in self.get_children():
		var sub_sheet : DataSheet = child_node as DataSheet
		sub_sheet.save_sheet(child_node.SAVE_PATH)

func load_game():
	for child_node in self.get_children():
		var sub_sheet : DataSheet = child_node as DataSheet
		sub_sheet.load_sheet(child_node.SAVE_PATH)

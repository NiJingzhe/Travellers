@tool
extends Node
class_name DataManager

@export var data : Dictionary = {}
@onready var data_segement_list : Array = []

#设置初始数据
func init_data_manager(init_data) -> void:
	self.data = init_data
	for key in self.data.keys():
		self.data_segement_list.append(key)

#获取当前实体的所有数据字段
func get_data_segement_list() -> Array:
	return self.data_segement_list as Array
	
#获取某一个字段的具体数据
func get_data(data_segement):
	if data_segement in self.data_segement_list:
		return self.data[data_segement]
	else:
		print("WARNING：你正在尝试访问不存在的数据！")
		return false
		
#设置一个数据段的值，可以添加新数据段
func set_data(data_segement : String, value) -> void:
	if data_segement not in self.data_segement_list:
		data_segement_list.append(data_segement)
	
	self.data.merge({data_segement : value}, true)
	
#删除某个数据段
func del_data(data_segement):
	if data_segement in self.data_segement_list:
		self.data_segement_list.remove_at(self.data_segement_list.bsearch(data_segement))
		self.data.erase(data_segement)
	else:
		print("WARNING：你正在尝试删除不存在的数据！")
		return false
		

	



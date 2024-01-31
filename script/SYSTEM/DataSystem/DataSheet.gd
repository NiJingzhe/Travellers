@tool
extends Node
class_name DataSheet

var SAVE_PATH : String = ""

##数据表,用于存储数据
var data_sheet : Dictionary

##初始化数据表,此时应当传入一个字符串列表,用于初始化数据表的字段
func init_sheet(all_data_segment : Array) -> void:
	for data_segment in all_data_segment:
		self.data_sheet.merge({data_segment : []}, true)

##计算数据表中记录的数量
func count_log() -> int:
	for data_segment in self.data_sheet.keys():
		return len(data_sheet[data_segment])

	return 0

##添加记录,此时应当传入一个字典,用于添加一条记录
func add_log(new_log : Dictionary) -> bool:
	for log_segment in new_log.keys():
		if log_segment not in self.data_sheet.keys():
			push_warning("DataSystem WARNING：添加记录时记录字段必须和现有表字段相同！")
			return false
		else:
			data_sheet[log_segment].append(new_log[log_segment])

	return true

##删除记录,此时应当传入一个整数,用于删除指定索引的记录
func del_log(index : int) -> bool:
	if index >= self.count_log():
		push_warning("DataSystem WARNING：你正在尝试删除不存在的记录！")
		return false
	for data_segment in self.data_sheet.keys():
		var segment_list : Array = data_sheet[data_segment] as Array
		segment_list.remove_at(index)
		data_sheet[data_segment] = segment_list
	return true

##查询记录,此时应当传入一个字段和该字段用于查找的key,用于查找指定索引的记录,找到返回该记录的字典形式,否则返回空字典
func query_log(data_segment:String, key) -> Dictionary:
	for log_index in range(self.count_log()):
		if self.data_sheet[data_segment][log_index] == key:
			var result_dict : Dictionary = {}
			for segment in self.data_sheet.keys():
				var value = self.data_sheet[segment][log_index]
				if value is Dictionary:
					value = value.duplicate(true)
				result_dict.merge({segment : value}, true)

			return result_dict

	return {}

##根据给定的键值对查找符合的log并返回id，如果有多个则返回一个列表
func find(segement_name : String, value) -> Array[int]:

	var result_list : Array[int] = []
	for i in range(self.count_log()):
		if self.get_value(segement_name, i) == value:
			result_list.append(i)

	return result_list

##直接通过下标取得记录
func get_log(index : int) -> Dictionary:
	if index >= self.count_log():
		push_warning("DataSystem WARNING：你正在尝试访问不存在的记录！")
		return {}
	var result_dict : Dictionary = {}
	for segment in self.data_sheet.keys():
		var value = self.data_sheet[segment][index]
		if value is Dictionary:
			value = value.duplicate(true)
		result_dict.merge({segment : value}, true)

	return result_dict

##给一个单元设置值
func set_value(segment_name : String, index : int, value) -> bool:
	if segment_name in self.data_sheet.keys() and index < self.count_log():
		self.data_sheet[segment_name][index] = value
		return true
	else:
		push_warning("DataSystem WARNING : 你正在给一个不存在的单元写入值 !")
		return false

##取一个单元的值
func get_value(segment_name : String, index : int):
	if segment_name in self.data_sheet.keys() and index < self.count_log():
		var result = self.data_sheet[segment_name][index]
		if result is Dictionary:
			return result.duplicate(true)
		else:
			return result
	else:
		push_warning("DataSystem WARNING : 你正在访问一个不存在的单元 !")
		return null

##取得所有字段名称,返回一个字符串列表
func get_all_segment_name() -> Array:
	return self.data_sheet.keys()

##添加一个新的字段,所有记录新字段的值都设置为null
func add_segment(segment_name : String) -> bool:
	if segment_name in self.data_sheet.keys():
		push_warning("DataSystem WARNING：你正在尝试添加已存在的字段！")
		return false
	else:
		var new_segment_array : Array = []
		for i in range(self.count_log()):
			new_segment_array.append(null)
		self.data_sheet.merge({segment_name : new_segment_array}, true)
		return true

##删除一个字段,所有记录中该字段的值都会被删除
func del_segment(segment_name : String) -> bool:
	if segment_name not in self.data_sheet.keys():
		push_warning("DataSystem WARNING：你正在尝试删除不存在的字段！")
		return false
	else:
		self.data_sheet.erase(segment_name)
		return true

##保存一张表
func save_sheet(save_path : String):
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_line(JSON.stringify(self.data_sheet))
	save_file.close()

##加载一张表
func load_sheet(load_path : String):
	if FileAccess.file_exists(load_path) == false:
		push_warning("DataSystem WARNING：你正在尝试从磁盘加载一个不存在的数据表！数据系统将会为您创建一个空表")
		self.save_sheet(load_path)

	var load_file = FileAccess.open(load_path, FileAccess.READ)
	var file_content : Dictionary = JSON.parse_string(load_file.get_as_text()) as Dictionary
	for key in file_content.keys():
		if not key in self.data_sheet.keys():
			push_warning("DataSystem WARNING：Key : ", key, "不在当前配置的datasheet节点中\n", "当前的节点包含 : ", self.data_sheet.keys())
			data_sheet.merge(file_content, true)

	self.data_sheet.merge(file_content, true)
	load_file.close()

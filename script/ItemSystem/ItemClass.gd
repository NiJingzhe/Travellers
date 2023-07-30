@tool
extends Node
class_name Item

var item_shape : Array
# Shape中存储一系列二元组， 代表占位格横纵坐标（相对于基准点，基准点本身为[0, 0]）
var item_name : String
# 物品名称
var item_description : String
# 物品描述
var item_image : String
# 物品图片
var basic_point : Array
# 基准点的位置：二元组，相对于物品栏最左上角而言
# 基准点定义为最上边界和最左边界交点对应右下物品栏块
var rotate_mode : int
# 旋转模式, 0, 90, 180, 270度 顺时针

var effect : ItemEffect = preload("res://script/ItemSystem/ItemEffect.gd").instantiate() as ItemEffect

enum ROTATE_STATE {UP, RIGHT, DOWN, LEFT}
# 分别对应 0, 90, 180, 270度 顺时针

#example shape
# var ExampleShape0 : Array = [[0, 1], [0, 7], [1, 0], [1, 4], [1, 6], [2, 4], [2, 5], [3, 5], [4, 4]]
# var ExampleShape1 : Array = [[0, 0], [0, 1], [1, 0], [1, 1]]

##初始化函数
func init_item():
	self.item_name = "Nameless"
	self.basic_point = [0, 0]
	self.item_shape = []
	self.rotate_mode = ROTATE_STATE.UP

	
#example func
# func create_example() :
# 	self.Name = "Example"
# 	self.BasicPoint = [1, 1]
# 	self.Shape = ExampleShape1
# 	self.RotateMode = RotateState.UP
	
##创建物品函数
func create_item(Name_ : String, Image_ : String, BasicPoint_ : Array, Shape_ : Array, RotateMode_ : int) :
	self.item_name = Name_
	self.item_image = Image_
	self.basic_point = BasicPoint_
	self.item_shape = Shape_
	self.rotate_mode = RotateMode_
	


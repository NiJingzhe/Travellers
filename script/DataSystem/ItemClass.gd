extends Node
class_name Item

var Shape : Array
# Shape中存储一系列二元组， 代表占位格横纵坐标（相对于基准点，基准点本身为[0, 0]）
var Name : String
# 物品名称
var BasicPoint : Array
# 基准点的位置：二元组，相对于物品栏最左上角而言
# 基准点定义为最上边界和最左边界交点对应右下物品栏块
var RotateMode : int
# 旋转模式, 0, 90, 180, 270度 顺时针

enum RotateState{UP, RIGHT, DOWN, LEFT}
# 分别对应 0, 90, 180, 270度 顺时针

var ExampleShape0 : Array = [[0, 1], [0, 7], [1, 0], [1, 4], [1, 6], [2, 4], [2, 5], [3, 5], [4, 4]]
var ExampleShape1 : Array = [[0, 0], [0, 1], [1, 0], [1, 1]]

func _ready():
	self.Name = "Nameless"
	self.BasicPoint = [0, 0]
	self.Shape = []
	self.RotateMode = RotateState.UP
	

func create_example() :
	self.Name = "Example"
	self.BasicPoint = [1, 1]
	self.Shape = ExampleShape1
	self.RotateMode = RotateState.UP
	
func create_by_data(Name : String, BasicPoint : Array, Shape : Array, RotateMode : int) :
	self.Name = Name
	self.BasicPoint = BasicPoint
	self.Shape = Shape
	self.RotateMode = RotateMode
	
func create_by_code(fun : Callable):
	fun.call(self)


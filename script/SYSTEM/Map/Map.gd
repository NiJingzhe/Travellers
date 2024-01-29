extends Node3D
class_name Map

## 这里是Map类型
## Map类型中目前主要负责监听Map场景中子节点（一般是InteractableObject）的事件上报
## 并设计监听到对应事件后的一些操作，如改变UI等等

## 这是通过全局唯一访问名称指定的UI根节点
## 所有UI操作都通过访问该根节点中的 Interface 实现
@onready var ui : UI = %UI as UI
@onready var switch_system : SwitchSystem = %SwitchSystem as SwitchSystem
@onready var data_base : DataBase = %DataBase as DataBase
@onready var sun_system : SunSystem = %SunSystem as SunSystem

## 子节点事件冒泡监听函数
## 接收参数为:
## obj : InteractableObject 即冒泡的子节点本身
## event : int 代表冒泡事件的类型，可选值可以参考InteractableObject中对于event_type的定义
## area : Area3D 代表触发事件的进入（或走出）探测区域的Area3D对象
##        （一般直接获取他们的parent就可以那到实际上的对象了）
func interactable_obj_event_listener(_obj : InteractableObject, _event : int, _area : Area3D):
	pass

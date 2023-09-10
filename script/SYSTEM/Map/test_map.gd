@tool
extends Node3D
class_name Map

## 这里是Map类型
## Map类型中目前主要负责监听Map场景中子节点（一般是InteractableObject）的事件上报
## 并设计监听到对应事件后的一些操作，如改变UI等等

## 这是通过全局唯一访问名称指定的UI根节点
## 所有UI操作都通过访问该根节点中的 Interface 实现
@onready var ui : UI = %UI as UI

## 子节点事件冒泡监听函数
## 接收参数为:
## obj : InteractableObject 即冒泡的子节点本身
## event : int 代表冒泡事件的类型，可选值可以参考InteractableObject中对于event_type的定义
## area : Area3D 代表触发事件的进入（或走出）探测区域的Area3D对象
##        （一般直接获取他们的parent就可以那到实际上的对象了）
func interactable_obj_event_listener(obj : InteractableObject, event : int, area : Area3D):
	if obj.name.contains("box"):
		if event == obj.event_type.PLAYER_IN:
			ui.show_element(ui.element_type.HINT_TEXT, {"text": "按F打开宝箱"})
		elif event == obj.event_type.PLAYER_OUT or event == obj.event_type.PLAYER_INTERACT:
			ui.hide_element(ui.element_type.HINT_TEXT)
			
	if obj.name.contains("ladder"):
		if event == obj.event_type.PLAYER_IN:
			ui.show_element(ui.element_type.HINT_TEXT, {"text": "按F进入攀爬"})
		elif event == obj.event_type.PLAYER_OUT or event == obj.event_type.PLAYER_INTERACT:
			ui.hide_element(ui.element_type.HINT_TEXT)
			if event == obj.event_type.PLAYER_OUT:
				var player = area.get_parent() as Player
				player.climb_mode = false
			else:
				var player = area.get_parent() as Player
				player.climb_mode = true

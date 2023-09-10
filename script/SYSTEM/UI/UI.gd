@tool
extends Control
class_name UI

@onready var dialoug : Dialoug = $Dialoug
@onready var hint_text : HintText = $HintText

enum element_type {
	DIALOUG,
	HINT_TEXT
}
# Called when the node enters the scene tree for the first time.
func _ready():
	for ui_element in self.get_children():
		ui_element.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func show_element(elmt_type : int, param : Dictionary):
	
	if elmt_type == element_type.DIALOUG:
		dialoug.show_dialoug(param["text"], param["image"], param["choices"])
	
	elif elmt_type == element_type.HINT_TEXT:
		hint_text.show_hint(param["text"])

func hide_element(elmt_type : int):
	
	if elmt_type == element_type.DIALOUG:
		dialoug.hide_dialoug()
	elif elmt_type == element_type.HINT_TEXT:
		hint_text.hide_hint()

extends Node
class_name ItemEffect

func change_value(sheet : DataSheet, segement : String, index : int, value : float) -> void:
    sheet.set_value(segement, index, value)
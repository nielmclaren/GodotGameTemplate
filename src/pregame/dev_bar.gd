class_name DevBar
extends Node2D


func _ready() -> void:
	if OS.has_feature("template"):
		hide()

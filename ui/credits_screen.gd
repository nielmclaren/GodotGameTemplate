class_name CreditsScreen
extends Node2D

@export var done_button: Button

signal done_pressed


func _ready() -> void:
	done_button.pressed.connect(func() -> void: done_pressed.emit())

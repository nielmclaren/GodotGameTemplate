class_name CreditsScreen
extends Node2D

@onready var done_button: Button = %DoneButton

signal done_pressed


func _ready() -> void:
	done_button.pressed.connect(func() -> void: done_pressed.emit())

	visibility_changed.connect(_visibility_changed)


func _visibility_changed() -> void:
	if visible:
		done_button.grab_focus.call_deferred()

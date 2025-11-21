class_name PauseMenu
extends Node2D

@export var resume_button: Button
@export var abandon_button: Button
@export var credits_button: Button
@export var exit_button: Button
@export var fullscreen_button: Button

signal resume_pressed
signal abandon_pressed
signal credits_pressed
signal exit_pressed
signal fullscreen_pressed


func _ready() -> void:
	resume_button.pressed.connect(resume_pressed.emit)
	abandon_button.pressed.connect(abandon_pressed.emit)
	credits_button.pressed.connect(credits_pressed.emit)
	exit_button.pressed.connect(exit_pressed.emit)
	fullscreen_button.pressed.connect(fullscreen_pressed.emit)

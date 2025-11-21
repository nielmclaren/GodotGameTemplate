class_name TitleScreen
extends Node2D

@export var play_button: Button
@export var credits_button: Button
@export var exit_button: Button
@export var fullscreen_button: Button

signal play_pressed
signal credits_pressed
signal exit_pressed
signal fullscreen_pressed


func _ready() -> void:
	play_button.pressed.connect(play_pressed.emit)
	credits_button.pressed.connect(credits_pressed.emit)
	exit_button.pressed.connect(exit_pressed.emit)
	fullscreen_button.pressed.connect(fullscreen_pressed.emit)

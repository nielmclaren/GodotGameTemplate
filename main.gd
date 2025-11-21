class_name Main
extends Node2D

@export var title_screen: TitleScreen
@export var credits_screen: CreditsScreen
@export var game_container: Node2D
@export var pause_menu: PauseMenu

var game_scene: PackedScene

var _game: Game

# Track pause separately since Game may pause the scene tree.
var _is_pause_menu: bool = false

# Used to return the scene tree to the paused value set by Game.
var _prev_paused: bool = false


func _init() -> void:
	AudioManager.set_music_volume_linear(0.5)
	AudioManager.set_sfx_volume_linear(0.5)


func _ready() -> void:
	game_scene = load("res://game.tscn")

	process_mode = Node.PROCESS_MODE_ALWAYS
	game_container.process_mode = Node.PROCESS_MODE_PAUSABLE

	title_screen.play_pressed.connect(_play)
	title_screen.credits_pressed.connect(func() -> void: credits_screen.show())
	title_screen.exit_pressed.connect(func() -> void: get_tree().quit())
	title_screen.fullscreen_pressed.connect(_toggle_fullscreen)

	pause_menu.resume_pressed.connect(_toggle_pause_menu)
	pause_menu.abandon_pressed.connect(_abandon)
	pause_menu.credits_pressed.connect(func() -> void: credits_screen.show())
	pause_menu.exit_pressed.connect(func() -> void: get_tree().quit())
	pause_menu.fullscreen_pressed.connect(_toggle_fullscreen)
	pause_menu.hide()

	credits_screen.done_pressed.connect(func() -> void: credits_screen.hide())
	credits_screen.hide()


func _play() -> void:
	if _game:
		_game.queue_free()
		_game = null

	title_screen.hide()
	credits_screen.hide()

	_game = game_scene.instantiate()
	game_container.add_child(_game)


func _abandon() -> void:
	if _game:
		_game.queue_free()
		_game = null

	title_screen.show()
	pause_menu.hide()
	credits_screen.hide()

	_is_pause_menu = false
	_prev_paused = false
	get_tree().paused = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and !event.is_echo():
		if credits_screen.visible:
			credits_screen.hide()

		elif _game:
			_toggle_pause_menu()
			get_viewport().set_input_as_handled()

		else:
			get_tree().quit()

	elif event.is_action_pressed("pause") and !event.is_echo():
		if _game:
			_toggle_pause_menu()
			get_viewport().set_input_as_handled()


func _toggle_pause_menu() -> void:
	if _is_pause_menu:
		pause_menu.hide()
		get_tree().paused = _prev_paused
		_is_pause_menu = false

	else:
		pause_menu.show()
		_prev_paused = get_tree().paused
		get_tree().paused = true
		_is_pause_menu = true


func _toggle_fullscreen() -> void:
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

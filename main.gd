class_name Main
extends Node2D

var _sm: CallableStateMachineNoProcess

var _title_screen: TitleScreen
var _game: Game

# Track pause separately since Game may pause the scene tree.
var _is_pause_menu: bool = false

# Used to return the scene tree to the paused value set by Game.
var _prev_paused: bool = false

var _game_scene: PackedScene = preload("res://game.tscn")
var _title_screen_scene: PackedScene = preload("res://ui/title_screen.tscn")

@onready var screen_container: Node2D = %ScreenContainer
@onready var credits_screen: CreditsScreen = %CreditsScreen
@onready var game_container: Node2D = %GameContainer
@onready var pause_menu: PauseMenu = %PauseMenu


func _init() -> void:
	AudioManager.set_music_volume_linear(0.5)
	AudioManager.set_sfx_volume_linear(0.5)


func _ready() -> void:
	TracerIntegration.init()
	get_tree().set_auto_accept_quit(false)

	process_mode = Node.PROCESS_MODE_ALWAYS
	game_container.process_mode = Node.PROCESS_MODE_PAUSABLE

	_sm = CallableStateMachineNoProcess.new()
	_sm.add_state(_title_state_enter, _title_state_leave)
	_sm.add_state(_credits_state_enter, _credits_state_leave)
	_sm.add_state(_game_state_enter, _game_state_leave)
	_sm.set_initial_state(_title_state_enter)

	pause_menu.resume_pressed.connect(_toggle_pause_menu)
	pause_menu.abandon_pressed.connect(_abandon_pressed)
	pause_menu.credits_pressed.connect(_show_credits_pressed)
	pause_menu.exit_pressed.connect(_exit_pressed)
	pause_menu.fullscreen_pressed.connect(_toggle_fullscreen)
	pause_menu.hide()

	credits_screen.done_pressed.connect(_credits_done_pressed)
	credits_screen.hide()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		Tracer.trace("Quit notification received.")
		await TracerIntegration.quit()
		get_tree().quit()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and !event.is_echo():
		Tracer.trace("ui_cancel pressed.")
		if credits_screen.visible:
			Tracer.trace("Hiding credits.")
			_hide_credits()

		elif _game:
			_toggle_pause_menu()
			get_viewport().set_input_as_handled()

	elif event.is_action_pressed("pause") and !event.is_echo():
		if _game:
			_toggle_pause_menu()
			get_viewport().set_input_as_handled()


func _play_pressed() -> void:
	Tracer.trace("Play clicked.")
	_sm.change_state(_game_state_enter)


func _abandon_pressed() -> void:
	Tracer.trace("Abandon clicked.")
	_sm.change_state(_title_state_enter)


func _show_credits_pressed() -> void:
	Tracer.trace("Show credits clicked.")
	if _is_pause_menu:
		# No state change for in-game pause menu.
		credits_screen.show()
	else:
		_sm.change_state(_credits_state_enter)


func _credits_done_pressed() -> void:
	Tracer.trace("Hide credits clicked.")
	_hide_credits()


func _hide_credits() -> void:
	if _is_pause_menu:
		# No state change for pause menu.
		credits_screen.hide()
	else:
		_sm.change_state(_title_state_enter)


func _exit_pressed() -> void:
	Tracer.trace("Exit clicked.")
	_quit()


func _quit() -> void:
	Tracer.trace("Quitting.")
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)


func _toggle_pause_menu() -> void:
	if _is_pause_menu:
		Tracer.trace("Unpausing.")
		pause_menu.hide()
		get_tree().paused = _prev_paused
		_is_pause_menu = false

	else:
		Tracer.trace("Pausing.")
		pause_menu.show()
		_prev_paused = get_tree().paused
		get_tree().paused = true
		_is_pause_menu = true


func _toggle_fullscreen() -> void:
	Tracer.trace("Toggle fullscreen clicked.")
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
		Tracer.trace("Going fullscreen mode.")
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		Tracer.trace("Going window mode.")
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


### States


func _title_state_enter() -> void:
	_title_screen = _title_screen_scene.instantiate()
	_title_screen.play_pressed.connect(_play_pressed)
	_title_screen.credits_pressed.connect(_show_credits_pressed)
	_title_screen.exit_pressed.connect(_exit_pressed)
	screen_container.add_child(_title_screen)


func _title_state_leave() -> void:
	_title_screen.queue_free()


func _credits_state_enter() -> void:
	credits_screen.show()


func _credits_state_leave() -> void:
	credits_screen.hide()


func _game_state_enter() -> void:
	_game = _game_scene.instantiate()
	game_container.add_child(_game)


func _game_state_leave() -> void:
	_game.queue_free()
	_game = null

	pause_menu.hide()

	_is_pause_menu = false
	_prev_paused = false
	get_tree().paused = false

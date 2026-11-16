class_name CallableStateMachine
extends Node

#
# Based on CallableStateMachine by FireBelley.
# @see https://gist.github.com/firebelley/96f2f82e3feaa2756fe647d8b9843174
#

var state_data: Variant

var is_debug: bool

var _state_dictionary: Dictionary = {}
var _current_state: String

var _pending_state: StringName
var _pending_data: Variant


# Add a state by defining the functions to call when entering and leaving the state and when CallableStateMachine.update() is called.
func add_state(
	enter_state_callable: Callable, update_state_callable: Callable, leave_state_callable: Callable
) -> void:
	_state_dictionary[enter_state_callable.get_method()] = {
		"update": update_state_callable,
		"enter": enter_state_callable,
		"leave": leave_state_callable
	}


func is_state(matching_state: Callable) -> bool:
	return _current_state == matching_state.get_method()


func is_state_in(matching_states: Array[Callable]) -> bool:
	return (
		_current_state
		in matching_states.map(func(callable: Callable) -> String: return callable.get_method())
	)


# Set the starting state of the state machine.
func set_initial_state(state_callable: Callable, data: Variant = null) -> void:
	var state_name: String = state_callable.get_method()
	if _state_dictionary.has(state_name):
		_set_state(state_name, data)
	else:
		push_warning("No state with name " + state_name)


# Calls the "update_state_callable" for whichever state is currently active.
func update() -> void:
	if _current_state != null:
		var update_callable: Callable = _state_dictionary[_current_state].update
		if !update_callable.is_null():
			if update_callable.get_argument_count() == 1:
				update_callable.call(state_data)
			else:
				update_callable.call()


# Change to another state. Automatically calls the leave method for the previous
# state and the enter method for the next one.
func change_state(state_callable: Callable, data: Variant = null) -> void:
	var state_name: StringName = state_callable.get_method()
	if _pending_state == state_name:
		return

	if !_pending_state and _current_state == state_name:
		return

	if _pending_state:
		push_warning(
			(
				"Failed to change state. State change is already pending. current=%s, attempted=%s, pending=%s"
				% [_current_state, state_name, _pending_state]
			)
		)
		return

	if _state_dictionary.has(state_name):
		_pending_state = state_name
		_pending_data = data
		_set_state.call_deferred(state_name, data)

	else:
		push_warning("Failed to change state. No state with name " + state_name)


func _set_state(state_name: String, data: Variant) -> void:
	if is_debug:
		print("set state: ", state_name)

	_pending_state = ""
	_pending_data = ""

	if _current_state:
		var leave_callable: Callable = _state_dictionary[_current_state].leave
		if !leave_callable.is_null():
			if leave_callable.get_argument_count() == 1:
				leave_callable.call(state_data)
			else:
				leave_callable.call()

	_current_state = state_name
	state_data = data

	var enter_callable: Callable = _state_dictionary[_current_state].enter
	if !enter_callable.is_null():
		if enter_callable.get_argument_count() == 1:
			enter_callable.call(state_data)
		else:
			enter_callable.call()

class_name IntModifier
extends RefCounted

const DEFAULT_MODIFIERS: Array[int] = [-2, -1, -1, 0, 1, 1, 2]

var _base_value: int
var _next_value: int
var _modifiers: Array[int]
var _remaining_modifiers: Array[int]


func _init(base_value: int) -> void:
	_base_value = base_value

	_modifiers = []

	_reset_modifiers()
	_update_value()


func with_modifiers(modifiers: Array[int] = DEFAULT_MODIFIERS) -> IntModifier:
	_modifiers = modifiers
	_reset_modifiers()
	_update_value()
	return self


func next() -> int:
	var result: int = _next_value
	_update_value()
	return result


func peek() -> int:
	return _next_value


func _modify(value: int) -> int:
	if _modifiers.is_empty():
		return value

	if _remaining_modifiers.is_empty():
		_reset_modifiers()

	var modifier: int = _remaining_modifiers.pop_at(randi() % _remaining_modifiers.size())
	return value + modifier


func _reset_modifiers() -> void:
	_remaining_modifiers = _modifiers.duplicate()


func _update_value() -> void:
	_next_value = _modify(_base_value)

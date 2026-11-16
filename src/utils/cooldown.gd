class_name Cooldown
extends RefCounted

const DEFAULT_MODIFIERS: Array[int] = [-2, -1, -1, 0, 1, 1, 2]

var _base_ticks: int = -1
var _range_low: int = -1
var _range_high: int = -1
var _ticks_remaining: int
var _modifiers: Array[int]
var _remaining_modifiers: Array[int]


# Initialize a cooldown with the given duration in ticks.
func _init(ticks_or_range_low: int = 0, range_high: int = -1) -> void:
	if range_high < 0 or ticks_or_range_low == range_high:
		_base_ticks = ticks_or_range_low
	else:
		_range_low = ticks_or_range_low
		_range_high = range_high

		if _range_low > _range_high:
			push_error("Cooldown got bad range. low=%d, high=%d" % [_range_low, _range_high])
			print("ERROR Cooldown got bad range. low=%d, high=%d" % [_range_low, _range_high])

	_modifiers = []

	_reset_modifiers()
	_reset_ticks()


func with_modifiers(modifiers: Array[int] = DEFAULT_MODIFIERS) -> Cooldown:
	_modifiers = modifiers
	_reset_modifiers()
	_reset_ticks()
	return self


func with_randomize_initial_value() -> Cooldown:
	var base_ticks: int = _get_base_ticks()
	if base_ticks <= 0:
		_ticks_remaining = base_ticks
	else:
		_ticks_remaining = randi() % base_ticks
	return self


# Reduces the cooldown to zero so the next call to `peek()` or `tick()` returns true.
func clear() -> void:
	_ticks_remaining = 0


# Returns true iff the cooldown has completed.
func peek() -> bool:
	return _ticks_remaining <= 0


# Resets the cooldown to the initial value.
func reset() -> void:
	_reset_ticks()


# Reduces cooldown by one tick and returns true iff the cooldown has completed.
func tick() -> bool:
	var result: bool = _ticks_remaining <= 0
	_ticks_remaining -= 1
	return result


func _get_base_ticks() -> int:
	if _base_ticks >= 0:
		return _base_ticks

	return randi_range(_range_low, _range_high)


func _modify(value: int) -> int:
	if _modifiers.is_empty():
		return value

	if _remaining_modifiers.is_empty():
		_reset_modifiers()

	var modifier: int = _remaining_modifiers.pop_at(randi() % _remaining_modifiers.size())
	return value + modifier


func _reset_modifiers() -> void:
	_remaining_modifiers = _modifiers.duplicate()


func _reset_ticks() -> void:
	_ticks_remaining = _modify(_get_base_ticks())

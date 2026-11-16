class_name AnalogInputDebouncer
extends Object

#
# Takes input from a joystick and only returns the input value
# at the moment that it first meets the high threshold. Otherwise
# returns zero. The value must meet the low threshold to reset.
#

var _low_threshold: float
var _high_threshold: float

var _is_press_ready: bool = true
var _is_release_ready: bool = true


func _init(low_threshold: float = 0.3, high_threshold: float = 1.0) -> void:
  _low_threshold = low_threshold
  _high_threshold = high_threshold


# Debounce a scalar value. If `is_press` is false then the behaviour is
# reversed so the output value is zero until the input meets the low threshold.
func scalar(value: float, is_press: bool = true) -> float:
  if _debounce(value, is_press):
    return value
  return 0


# Debounce a vector2 value. If `is_press` is false then the behaviour is
# reversed so the output value is zero until the input meets the low threshold.
func vector2(value: Vector2, is_press: bool = true) -> Vector2:
  if _debounce(value.length(), is_press):
    return value
  return Vector2.ZERO


func _debounce(value: float, is_press: bool) -> bool:
  if is_press:
    return _debounce_press(value)
  return _debounce_release(value)


func _debounce_press(value: float) -> bool:
  var is_low: bool = value <= _low_threshold
  var is_high: bool = value >= _high_threshold

  if is_low:
    _is_press_ready = true

  if _is_press_ready and is_high:
    _is_press_ready = false
    return true

  return false


func _debounce_release(value: float) -> bool:
  var is_low: bool = value <= _low_threshold
  var is_high: bool = value >= _high_threshold

  if _is_release_ready and is_low:
    _is_release_ready = false
    return true

  if is_high:
    _is_release_ready = true

  return false
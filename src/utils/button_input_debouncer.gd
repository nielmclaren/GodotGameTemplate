class_name ButtonInputDebouncer
extends Object

var _is_press_ready: bool = true
var _is_release_ready: bool = false


# The first call to `press()` returns true.
# The first call to `press()` after a call to `release()` returns true.
# Successive calls without first calling `release()` will return false.
func press() -> bool:
  if _is_press_ready:
    _is_press_ready = false
    _is_release_ready = true
    return true
  return false


# The first call to `release()` after a call to `press()` returns true.
# Successive calls without first calling `press()` will return false.
func release() -> bool:
  if _is_release_ready:
    _is_press_ready = true
    _is_release_ready = false
    return true
  return false
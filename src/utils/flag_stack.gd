class_name FlagStack
extends Object

#
# FlagStack tracks the number of times a flag is set to true and
# remains true until the flag is set to false an equal number of times.
# Useful for pausing, if multiple systems pause simultaneously.
#
# Usage:
# var _paused_fs: FlagStack = FlagStack.new()
# var paused: bool:
# 	get():
# 		return _paused_fs.value
# 	set(v):
# 		return _paused_fs.update(v)
#

signal changed(is_enabled: bool)

var value: bool:
	get():
		return _count > 0
	set(v):
		update(v)

var _count: int = 0


func update(v: bool = true) -> bool:
	if v:
		return _push()
	return _pop()


func _push() -> bool:
	_count += 1

	if _count <= 1:
		changed.emit(true)

	return true


func _pop() -> bool:
	_count -= 1

	if _count < 0:
		_count = 0

	if _count == 0:
		changed.emit(false)
		return false

	return true

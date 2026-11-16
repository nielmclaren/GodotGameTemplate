class_name Validation
extends RefCounted

var _invalid: bool
var _validate_callable: Callable


func _init(validate_: Callable) -> void:
	_validate_callable = validate_


func invalidate() -> void:
	if !_invalid:
		_validate.call_deferred()
		_invalid = true


func _validate() -> void:
	_validate_callable.call()
	_invalid = false

class_name AutoIncrement
extends RefCounted

var _value: int = -1


func next() -> StringName:
	_value += 1
	return str(_value)

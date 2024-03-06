extends Area2D

class_name Tackleable

signal tackled(tackler: Node2D)
signal tackle_finished(tackler: Node2D)

var _being_tackled := false
var _current_tackler: Node2D
var _last_tackler: Node2D

@export var target: Node2D

func is_being_tackled() -> bool:
	return _being_tackled

func get_current_tackler() -> Node2D:
	return _current_tackler

func tackle(tackler: Node2D) -> void:
	if _being_tackled:
		return
	_being_tackled = true
	_current_tackler = tackler
	tackled.emit(tackler)

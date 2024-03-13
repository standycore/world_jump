@tool
extends Control

signal transition_finished
signal fade_in_finished
signal fade_out_finished

enum State {
	FADED_IN,
	FADED_OUT
}

var _transitioning := false
var _fading_in := false
var _fading_out := false

@export var transition_time: float = 1

@export var state: State = State.FADED_OUT:
	set(v):
		if v == state:
			return
		state = v
		if state == State.FADED_IN:
			%ColorRect.color.a = 1
		elif state == State.FADED_OUT:
			%ColorRect.color.a = 0

func fade_in() -> void:
	if _transitioning:
		return
	_transitioning = true
	_fading_in = true
	var og_filter := mouse_filter
	mouse_filter = Control.MOUSE_FILTER_STOP
	
	var tween := get_tree().create_tween()
	tween.tween_property(%ColorRect, "color", Color(0,0,0,1), transition_time)
	await tween.finished
	_transitioning = false
	_fading_in = false
	mouse_filter = og_filter
	transition_finished.emit()
	fade_in_finished.emit()

func fade_out() -> void:
	if _transitioning:
		return
	_transitioning = true
	_fading_out = true
	var og_filter := mouse_filter
	mouse_filter = Control.MOUSE_FILTER_STOP
	
	var tween := get_tree().create_tween()
	tween.tween_property(%ColorRect, "color", Color(0,0,0,0), transition_time)
	await tween.finished
	_transitioning = false
	_fading_out = false
	mouse_filter = og_filter
	transition_finished.emit()
	fade_out_finished.emit()

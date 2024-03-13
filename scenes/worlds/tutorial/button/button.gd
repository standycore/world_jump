@tool
extends Node2D

signal pressed
signal released

@onready var sprite_released = %HandleReleased
@onready var sprite_pressed = %HandlePressed
@onready var viewport_container = $SubViewportContainer

@export var _pressed := false:
	set(v):
		if _pressed == v:
			return
		_pressed = v
		if _pressed:
			sprite_pressed.visible = true
			sprite_released.visible = false
			pressed.emit()
		else:
			sprite_pressed.visible = false
			sprite_released.visible = true
			released.emit()
	get:
		return _pressed

func _ready():
	viewport_container.material = viewport_container.material.duplicate()

func is_pressed() -> bool:
	return _pressed

func _on_interactable_interacted(_interactor):
	_pressed = true


func _on_interactable_range_entered(_interactor):
	pass
	#viewport_container.material.set_shader_parameter("visible", true)


func _on_interactable_range_exited(_interactor):
	pass
	#viewport_container.material.set_shader_parameter("visible", false)


func _on_interactable_interaction_ready(_interactor):
	viewport_container.material.set_shader_parameter("flashing", true)
	viewport_container.material.set_shader_parameter("visible", true)


func _on_interactable_interaction_unready(_interactor):
	viewport_container.material.set_shader_parameter("flashing", false)
	viewport_container.material.set_shader_parameter("visible", false)

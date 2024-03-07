extends Node

class_name NPCComponent

@export var speed := 100.0

@export var body: CharacterBody2D
@export var nav_agent: NavigationAgent2D
@export var auto_movement: bool = true

var _moving_finished := true
var _moving_enabled := true
var _next_pos := Vector2(0, 0)

func _ready():
	nav_agent.velocity_computed.connect(func(safe_velocity: Vector2):
		if not _moving_enabled:
			return
		body.velocity = safe_velocity
		body.move_and_slide()
	)

#func _physics_process(_delta):
	#if not auto_movement:
		#return
	#move_with_nav()

func get_position() -> Vector2:
	return body.global_position

func move_to_position(pos: Vector2) -> void:
	nav_agent.target_position = pos
	_moving_finished = false

func is_moving_enabled() -> bool:
	return _moving_enabled

func set_moving_enabled(v: bool) -> void:
	_moving_enabled = v

func is_move_finished() -> bool:
	if not _moving_enabled:
		return true
	return _moving_finished

func move_with_nav() -> void:
	if not _moving_enabled:
		return
	if not nav_agent.is_navigation_finished():
		_next_pos = nav_agent.get_next_path_position()
		var dir := _next_pos - body.position
		dir = dir.normalized()
		
		nav_agent.set_velocity(dir * speed)
	else:
		_moving_finished = true

extends Node

class_name NPCComponent

@export var speed := 100.0
@export var auto_process_move := false
@export var body: CharacterBody2D
@export var nav_agent: NavigationAgent2D
@export var bouncing_enabled := false
@export var bounce_node: Node2D

var _moving_finished := true
var _moving_enabled := true
var _next_pos := Vector2(0, 0)

var _bounce_progress: float = 0
@export var _bounce_curve: Curve

func _ready():
	nav_agent.velocity_computed.connect(func(safe_velocity: Vector2):
		if not _moving_enabled:
			return
		body.velocity = safe_velocity
		body.move_and_slide()
	)

func _physics_process(delta):
	if auto_process_move:
		move_with_nav()
	if bouncing_enabled and bounce_node:
		if not is_move_finished() and _bounce_progress >= 1.0:
			_bounce_progress = 0.0
		bounce_node.position.y = _bounce_curve.sample_baked(_bounce_progress) * -10
	if _bounce_progress < 1.0:
		_bounce_progress += delta * 5

func get_position() -> Vector2:
	return body.global_position

func move_to_position(pos: Vector2) -> void:
	nav_agent.target_position = pos
	_moving_finished = false

func stop_moving() -> void:
	nav_agent.target_position = body.global_position

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

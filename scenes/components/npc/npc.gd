extends CharacterBody2D

const SPEED := 100.0

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var _moving_enabled := false
var _next_pos := Vector2(0, 0)
var _crossing_link := false
var _link_exit_position := Vector2(0, 0)

func set_target_position(pos: Vector2):
	nav_agent.target_position = pos

func _ready():
	
	nav_agent.navigation_finished.connect(func():
		
		await get_tree().create_timer(randf() * 2).timeout
		nav_agent.target_position = position + (Vector2(randf(), randf()) - Vector2(.5, .5)) * 2 * 200
	)
	
	set_target_position(position + Vector2(randf() * 10, randf() * 10))

func _physics_process(_delta):
	
	#if nav_agent.target_position != get_global_mouse_position():
		#print("path changed")
		#nav_agent.target_position = get_global_mouse_position()
	
	#print(_moving_enabled)
	
	if not nav_agent.is_navigation_finished():
		_moving_enabled = true
		if _crossing_link:
			print("using link end position ", _link_exit_position)
			_next_pos = _link_exit_position
			if (_next_pos - position).length() < 5:
				_crossing_link = false
		else:
			_next_pos = nav_agent.get_next_path_position()
	else:
		_moving_enabled = false
	
	if _moving_enabled:
		var dir := _next_pos - position
		dir = dir.normalized()
		
		velocity = dir * SPEED
		
		move_and_slide()

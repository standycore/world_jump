extends CharacterBody2D


const SPEED := 100.0

func _physics_process(delta):
	
	var dir = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)
	if dir.length_squared() > 0:
		velocity = dir.normalized() * SPEED
	else:
		velocity = Vector2(0, 0)
	
	move_and_slide()

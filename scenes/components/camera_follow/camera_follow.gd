extends Camera2D

@export var target: Node2D

func _process(_delta):
	if not target:
		return
		
	position = target.position
	
	if Input.is_action_just_pressed("zoom_in"):
		zoom += Vector2(1,1) * .2
	elif Input.is_action_just_pressed("zoom_out"):
		zoom -= Vector2(1,1) * .2

extends CharacterBody2D

class_name Player

@export var speed: float = 100.0

@onready var tackle_area: Area2D = %TackleArea

func _physics_process(_delta):
	
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# dir is normalized
	if dir.length_squared() > 0:
		velocity = dir * speed
	else:
		velocity = Vector2(0, 0)
	
	move_and_slide()
	
	tackle_area.rotation = dir.angle()
	
	

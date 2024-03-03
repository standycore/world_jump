extends Area2D

@onready var Car = preload("res://scenes/worlds/world1/car/car.gd")

func _ready():
	body_entered.connect(func(body: PhysicsBody2D):
		if body.get_script() == Car:
			body.queue_free()
	)

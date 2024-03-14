extends Node

class_name ThiefComponent

@export var target: Node2D

func _ready():
	if not GameManager.is_world_ready():
		GameManager.world_ready.connect(func():
			GameManager.world_state.thief = target
			print("set world thief")
		)

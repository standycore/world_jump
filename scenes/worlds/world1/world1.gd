extends Node2D

func _ready():
	GameManager.reset_world_state()
	
	await get_tree().create_timer(10).timeout
	
	$YSort/Rock.global_position = $YSort/Player.global_position
	$AnimationPlayer.play("crush_player")

func lose_scene() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/lose_menu/lose_menu.tscn")

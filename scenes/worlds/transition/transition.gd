extends Node2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready():
	if GameManager.old_world_texture:
		print("setting world tex")
		$OldWorld.texture = GameManager.old_world_texture
	if GameManager.tackle_thief_texture:
		print("setting tackle tex")
		$Target.texture = GameManager.tackle_thief_texture
	anim_player.play("teleport")

func next_scene() -> void:
	if GameManager.next_world_scene:
		var error = get_tree().change_scene_to_packed(GameManager.next_world_scene)
		if error != OK:
			push_error("failed to change scene ", GameManager.next_world_scene)
	else:
		push_error("missing next scene")

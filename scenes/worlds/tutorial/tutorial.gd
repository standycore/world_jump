extends Node2D

@export var buttons: Array[Node2D] = []

@export var camera: Camera2D

@export var player: Player

@export var thief: Node2D

@export var remote: Node2D

@onready var anim_player: AnimationPlayer = $TutorialAnimationPlayer

enum Phase {
	START,
	CONSTRUCT,
	CONSTRUCTED,
	STEAL,
	CHASE,
	TELEPORT
}

@export var phase: Phase = Phase.START

func _ready():
	camera.target = player
	camera.position_smoothing_speed = 20
	player.enabled = true
	
	for b in buttons:
		b.pressed.connect(_on_button_pressed)
	
	GameManager.reset_world_state()

func _process(_delta):
	match phase:
		Phase.CONSTRUCTED:
			if remote and player:
				if remote.global_position.distance_to(player.global_position) < 60:
					phase = Phase.STEAL
					anim_player.play("steal_remote")

func _on_button_pressed() -> void:
	if phase != Phase.START:
		return
	
	var all_pressed := true
	for b in buttons:
		if not b.is_pressed():
			all_pressed = false
			break
	if not all_pressed:
		return
	
	# all buttons pressed
	phase = Phase.CONSTRUCT
	anim_player.play("construct_remote")


func _on_player_won():
	set_process(false)
	player.set_process(false)
	thief.set_process(false)
	var center := (player.global_position + thief.global_position) * .5
	#var viewport := SubViewport.new()
	var target_viewport := SubViewport.new()
	target_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	target_viewport.size = Vector2(256, 256)
	target_viewport.transparent_bg = true
	target_viewport.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	add_child(target_viewport)
	var container := Node2D.new()
	container.y_sort_enabled = true
	container.position = Vector2(128, 128)
	target_viewport.add_child(container)
	player.get_parent().remove_child(player)
	thief.get_parent().remove_child(thief)
	
	container.add_child(thief)
	container.add_child(player)
	thief.position -= center
	player.position -= center
	
	RenderingServer.force_draw(true)
	
	var background_texture := ImageTexture.create_from_image(get_viewport().get_texture().get_image())
	#var texture_rect := TextureRect.new()
	#texture_rect.texture = background_texture
	#texture_rect.size = Vector2(300,200)
	#texture_rect.stretch_mode = TextureRect.STRETCH_SCALE
	#add_child(texture_rect)
	
	var target_texture := ImageTexture.create_from_image(target_viewport.get_texture().get_image())
	var sprite := Sprite2D.new()
	sprite.texture = target_texture
	sprite.position = center
	add_child(sprite)
	
	camera.target = sprite
	phase = Phase.TELEPORT
	
	GameManager.old_world_texture = background_texture
	GameManager.tackle_thief_texture = target_texture
	GameManager.next_world_scene = preload("res://scenes/worlds/world1/world1.tscn")
	get_tree().change_scene_to_file("res://scenes/worlds/transition/transition.tscn")

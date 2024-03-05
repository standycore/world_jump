extends CharacterBody2D

class_name Player

@export var speed: float = 100.0

@onready var tackle_area: Area2D = %TackleArea
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var jump_sound: AudioStreamPlayer = $JumpSound
@onready var smack_sound: AudioStreamPlayer = $SmackSound

var _tackling: bool = false
var _last_dir: Vector2 = Vector2(0, 0)
var _last_visual_dir: Vector2 = Vector2(0, 0)

func _physics_process(_delta):
	
	if not _tackling:
		move()
		if Input.is_action_just_pressed("ui_accept"):
			tackle()

func move() -> void:
	var dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# dir is normalized
	if dir.length_squared() > 0:
		velocity = dir * speed
		_last_dir = dir
		if dir.x != 0:
			_last_visual_dir.x = dir.x
	else:
		velocity = Vector2(0, 0)
	
	move_and_slide()
	
	tackle_area.rotation = _last_dir.angle()
	
	if get_real_velocity().length_squared() > 0:
		animation_player.play("run")
	else:
		animation_player.play("idle")
	
	if _last_visual_dir.x > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

func tackle() -> void:
	if _tackling:
		return
	_tackling = true
	animation_player.play("tackle")
	jump_sound.play()
	await get_tree().create_timer(.1).timeout
	
	#var camera := get_viewport().get_camera_2d()
	#camera.zoom
	
	var tackle_target = get_tackle_target()
	if tackle_target:
		# check if target is the right target, else fail
		# for now, auto fail
		print("lose")
	
	else:
		print("miss")
		await get_tree().create_timer(1).timeout
		_tackling = false

func get_tackle_target():
	var bodies := tackle_area.get_overlapping_bodies()
	if bodies.is_empty():
		return
	for body in bodies:
		for child in body.get_children():
			if child is Tackleable:
				return body

func check_tackle_target() -> bool:
	return false

extends Node2D

@export var buttons: Array[Node2D] = []

@export var camera: Camera2D

@export var player: Player

@onready var anim_player: AnimationPlayer = $TutorialAnimationPlayer

enum Phase {
	START,
	CONSTRUCT
}

var phase: Phase = Phase.START

func _ready():
	camera.target = player
	camera.position_smoothing_speed = 20
	player.enabled = true
	
	for b in buttons:
		b.pressed.connect(_on_button_pressed)

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

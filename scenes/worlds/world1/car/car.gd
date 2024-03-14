@tool
extends CharacterBody2D

@onready var player_class = preload("res://scenes/player/player.gd")

@export var street_path: StreetPath

@export var speed: float = 40
@export var enabled: bool = false

@onready var front_area: Area2D = $FrontArea

var _blocked_by_life: bool = false

func _ready():
	if not Engine.is_editor_hint():
		enabled = true

func _physics_process(_delta):
	
	if not enabled:
		return

func get_closest_path_offset() -> float:
	return street_path.curve.get_closest_offset(street_path.to_local(global_position))

func is_blocked() -> bool:
	_blocked_by_life = false
	var overlapping_bodies := front_area.get_overlapping_bodies()
	if len(overlapping_bodies) > 0:
		for body in overlapping_bodies:
			if body != self:
				if body.get_script() == player_class:
					_blocked_by_life = true
				else:
					for child in body.get_children():
						if child is NPCComponent:
							_blocked_by_life = true
							break
				return true
	
	var overlapping_areas := front_area.get_overlapping_areas()
	var closest_offset := get_closest_path_offset()
	if len(overlapping_areas) > 0:
		for area in overlapping_areas:
			if area is TrafficLight:
				if area.state == TrafficLight.State.GO:
					if closest_offset < area.path_offset:
						return true
	
	return false

func move(delta) -> void:
	var closest_offset = get_closest_path_offset()
	var closest_pos = street_path.curve.sample_baked(closest_offset)
	var next_pos
	
	var diff = closest_pos - global_position
	if diff.length() > speed * delta:
		next_pos = closest_pos
	else:
		next_pos = street_path.curve.sample_baked(closest_offset + speed * delta)
	
	
	velocity = (next_pos - position).normalized() * speed
	
	move_and_slide()
	
	front_area.rotation = velocity.angle() - PI * .5

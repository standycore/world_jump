@tool
extends CharacterBody2D

@export var street_path: StreetPath

@export var speed: float = 40
@export var enabled: bool = false

@onready var front_area: Area2D = $FrontArea

enum State {
	STOPPED,
	MOVING,
	WAITING
}

#@export var moving_enabled: bool = false
@export var state = State.WAITING

var _next_stop_index: int = -1
var _stops_checked: bool = false

func _ready():
	if not Engine.is_editor_hint():
		enabled = true

func _physics_process(delta):
	
	if not enabled:
		return
	
	if street_path:
		
		var overlapping_bodies := front_area.get_overlapping_bodies()
		if len(overlapping_bodies) > 0:
			for body in overlapping_bodies:
				if body != self:
					return
		
		var overlapping_areas := front_area.get_overlapping_areas()
		if len(overlapping_areas) > 0:
			for area in overlapping_areas:
				if area is TrafficLight:
					if area.state == TrafficLight.State.GO:
						return
		
		var closest_offset = street_path.curve.get_closest_offset(street_path.to_local(global_position))
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


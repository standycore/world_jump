@tool
extends Area2D

class_name TrafficLight

@onready var light1: Node2D = %Light1
@onready var light2: Node2D = %Light2
@onready var timer: Timer = %Timer

@export var first_delay_time: float = 0
@export var stop_time: float = 5
@export var go_time: float = 5

@export var off_color: Color = Color.GRAY
@export var stop_color: Color = Color.RED
@export var go_color: Color = Color.GREEN

@export var cross_nav_region: NavigationRegion2D
@export var cross_area: Area2D

enum State {
	STOP,
	GO
}

@export var state: State = State.STOP:
	set(v):
		if state == v:
			return
		state = v
		update_state()
	get:
		return state

func _ready():
	if not Engine.is_editor_hint():
		
		if first_delay_time > 0:
			timer.start(first_delay_time)
			await timer.timeout
		
		while true:
			if state == State.GO:
				timer.start(go_time)
				await timer.timeout
				state = State.STOP
			elif state == State.STOP:
				timer.start(stop_time)
				await timer.timeout
				state = State.GO

func update_state():
	if not is_node_ready():
		await ready
	
	if state == State.STOP:
		light1.modulate = stop_color
		light2.modulate = off_color
		
		if cross_nav_region:
			cross_nav_region.enabled = false
	else:
		light1.modulate = off_color
		light2.modulate = go_color
		if cross_nav_region:
			cross_nav_region.enabled = true
	



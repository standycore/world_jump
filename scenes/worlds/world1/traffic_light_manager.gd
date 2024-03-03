@tool
extends Node

@onready var timer: Timer = $Timer

## Time for pedestrians to go
@export var go_time: float = 5
## Time for pedestrians to stop
@export var stop_time: float = 5

@export var active_group: int = 0:
	set(v):
		var light_groups := get_light_groups()
		
		v = clamp(v, 0, light_groups.size() - 1)
		if v == active_group:
			return
		active_group = v
		_on_active_group_changed()
	get:
		return active_group

func _ready():
	if not Engine.is_editor_hint():
		reset()

func get_light_groups() -> Array[TrafficLightGroup]:
	var groups: Array[TrafficLightGroup] = []
	for child in get_children():
		if child is TrafficLightGroup:
			groups.append(child)
	return groups

func reset():
	return
	var light_groups := get_light_groups()
	
	for group in light_groups:
		for t in group.traffic_lights:
			t.state = TrafficLight.State.STOP
	
	active_group = 0
	
	while true:
		timer.start(stop_time)
		await timer.timeout
		if active_group >= light_groups.size() - 1:
			active_group = 0
		else:
			active_group += 1


func _on_active_group_changed():
	var light_groups := get_light_groups()
	
	print("active group changed ", active_group)
	for i in range(len(light_groups)):
		var group = light_groups[i]
		if i == active_group:
			for t in group.traffic_lights:
				t.state = TrafficLight.State.GO
		else:
			for t in group.traffic_lights:
				t.state = TrafficLight.State.STOP

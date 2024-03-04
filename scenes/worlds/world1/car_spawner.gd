extends Area2D

signal all_bodies_exited

@export var street_path: Path2D

@export var min_time: float = 3
@export var max_time: float = 5

@onready var timer: Timer = $Timer

@export var car_scene: PackedScene
@export var spawn_container: Node2D

func _ready():
	if not street_path:
		push_error("missing street path")
		return
	
	if not car_scene:
		push_error("missing car scene")
		return
	
	if not spawn_container:
		push_error("missing spawn container")
		return
	
	while true:
		var wait_time = randf_range(min_time, max_time)
		timer.start(wait_time)
		await timer.timeout
		if get_overlapping_bodies().size() > 0:
			await all_bodies_exited
		
		var car := car_scene.instantiate()
		var start_pos := street_path.curve.sample_baked(0)
		car.position = start_pos
		car.street_path = street_path
		spawn_container.add_child(car)

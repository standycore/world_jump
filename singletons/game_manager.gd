extends Node

signal world_ready
signal game_lost

var world_state: WorldState = null

var _world_ready := false

#@onready var overlay: Control = preload("res://scenes/overlay/overlay.tscn").instantiate()

func _ready():
	#if not get_parent().is_node_ready():
		#await get_parent().ready
	#var canvas_layer := CanvasLayer.new()
	#get_parent().add_child(canvas_layer)
	#canvas_layer.add_child(overlay)
	#overlay.state = overlay.State.FADED_IN
	#overlay.fade_out()
	
	game_lost.connect(func():
		print("lost")
		
	)

#func _process(delta):
	#print(get_parent().get_children())

func is_world_ready() -> bool:
	return _world_ready

func reset_world_state() -> void:
	_world_ready = false
	world_state = WorldState.new()
	world_state.max_bad_tackle_count_reached.connect(func():
		#print("too many bad tackled, u lose!")
		game_lost.emit()
	)
	
	_world_ready = true
	world_ready.emit()

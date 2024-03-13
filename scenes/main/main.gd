extends Control

@onready var overlay = $Overlay
@onready var world_viewport = %WorldViewport
@onready var menu_container: Control = %MenuContainer

var main_menu_scene := preload("res://scenes/menu/main_menu/main_menu.tscn")
var lose_menu_scene := preload("res://scenes/menu/lose_menu/lose_menu.tscn")
var current_world: Node = null

func _ready():
	overlay.fade_out()
	var main_menu = main_menu_scene.instantiate()
	menu_container.add_child(main_menu)
	main_menu.start_pressed.connect(func():
		# go to tutorial
		GameManager.reset_world_state()
		
		GameManager.game_lost.connect(func():
			print("you lose")
			var lose_menu: Control = lose_menu_scene.instantiate()
			menu_container.add_child(lose_menu)
			#overlay.fade_in()
			print("pausing current world", current_world)
			current_world.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
			#current_world.set_physics_process(false)
			current_world.set_process(false)
			#current_world.paused = true
		)
		
		var scene := load("res://scenes/worlds/world1/world1.tscn")
		var world = scene.instantiate()
		world_viewport.add_child(world)
		current_world = world
		
		# remove main menu
		main_menu.queue_free()
	)

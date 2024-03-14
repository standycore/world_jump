extends CharacterBody2D

@onready var npc_component: NPCComponent = $NPCComponent

func _on_tackleable_tackled(_tackler):
	print(self, " oh gosh ive been tackled!")
	#npc_component.set_moving_enabled(false)


func _on_tackleable_tackle_finished(_tackler):
	pass
	#npc_component.set_moving_enabled(true)

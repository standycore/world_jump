extends AnimationPlayer

@export var animation_name: StringName = ""

func _ready():
	play(animation_name)

extends CanvasLayer

func _ready():
	visible = true
	$AnimationPlayer.play("detransition")

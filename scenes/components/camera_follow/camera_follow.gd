extends Camera2D

@export var target_position: Vector2 = Vector2(0, 0)
@export var target: Node2D
@export var follow_target := true

@export var shake_amount: float = 0
@export var shake_vector: Vector2 = Vector2(1, 1)

func _process(_delta):
	var sh_amt := sin(Time.get_ticks_msec() * .1) * shake_amount
	if target and follow_target:
		position = target.position + shake_vector * sh_amt
	else:
		position = target_position + shake_vector * sh_amt
	
	
	
	#if Input.is_action_just_pressed("zoom_in"):
		#zoom += Vector2(1,1) * .2
	#elif Input.is_action_just_pressed("zoom_out"):
		#zoom -= Vector2(1,1) * .2

func set_target(node_path: NodePath) -> void:
	var node = get_node(node_path)
	if node:
		target = node

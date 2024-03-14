extends CharacterBody2D

@export var npc_movement: NPCComponent

@export var player: Player

enum State {
	FROZEN,
	ESCAPING,
	TACKLED
}

@export var state: State = State.FROZEN

func _physics_process(_delta):
	match state:
		State.ESCAPING:
			if not player:
				return
			if not npc_movement:
				return
			
			var escape_vector := global_position - player.global_position
			if escape_vector.length() < 200:
				var escape_dir := escape_vector.normalized()
				var best_len: float = 0
				var best_escape_dir := escape_dir
				
				for i in range(-1, 2):
					var raycast_params := PhysicsRayQueryParameters2D.new()
					raycast_params.from = global_position
					var new_escape_dir := escape_dir.rotated(i * PI * .4)
					raycast_params.to = global_position + new_escape_dir * 40
					raycast_params.hit_from_inside = false
					var result := get_world_2d().direct_space_state.intersect_ray(raycast_params)
					if result:
						var diff_len := global_position.distance_to(result.position)
						if diff_len > best_len:
							best_len = diff_len
							best_escape_dir = new_escape_dir
					else:
						best_escape_dir = new_escape_dir
						break
				
				npc_movement.move_to_position(global_position + best_escape_dir * 50)


func _on_tackleable_tackled(_tackler):
	state = State.TACKLED
	npc_movement.set_moving_enabled(false)

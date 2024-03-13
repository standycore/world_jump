@tool
extends BTAction

# Task parameters.
#@export var parameter1: float
#@export var parameter2: Vector2
@export var npc: BBNode

var _npc: NPCComponent
var _sync_delayed: bool = false

## Note: Each method declaration is optional.
## At minimum, you only need to define the "_tick" method.


# Called to generate a display name for the task (requires @tool).
func _generate_name() -> String:
	return "MyTask"


# Called to initialize the task.
func _setup() -> void:
	_npc = agent.get_node(npc.saved_value)


# Called when the task is entered.
func _enter() -> void:
	_npc.move_to_position(_npc.get_position() + Vector2(randf_range(-100, 100), randf_range(-100, 100)))

# Called when the task is exited.
func _exit() -> void:
	#if _npc.get_parent().name == "tester":
		#print("exited")
	_npc.stop_moving()


# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
	if not _sync_delayed:
		_sync_delayed = true
		return RUNNING
	if not _npc.is_move_finished():
		_npc.move_with_nav()
		return RUNNING
	else:
		return SUCCESS


# Strings returned from this method are displayed as warnings in the editor.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings

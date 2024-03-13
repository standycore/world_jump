@tool
extends Node

class_name Interactable

signal interacted(interactor: Node2D)
signal range_entered(interactor: Node2D)
signal range_exited(interactor: Node2D)
signal interaction_ready(interactor: Node2D)
signal interaction_unready(interactor: Node2D)

#@export var interact_area: Area2D

@export var node: Node2D

@export var interact_radius: float = 50

@export var enabled: bool = true
@export var already_interacted: bool = false
var _in_range: bool = false
var _interaction_ready: bool = false

static var interactables: Array[Interactable] = []
static var range_reference: Node2D
static var in_range_interactables: Array[Interactable] = []
static var ready_interactables: Array[Interactable] = []

func _enter_tree():
	Interactable.interactables.append(self)

func _exit_tree():
	Interactable.interactables.remove_at(Interactable.interactables.find(self))
	Interactable.in_range_interactables.remove_at(Interactable.in_range_interactables.find(self))
	Interactable.ready_interactables.remove_at(Interactable.ready_interactables.find(self))

func _process(_delta):
	var ref = Interactable.range_reference
	if ref and is_instance_valid(ref):
		var r := false
		if is_ready_to_interact(ref.global_position, true):
			r = true
		if is_in_range(ref.global_position):
			enter_range(ref)
			set_interaction_ready(ref, r)
		else:
			exit_range(ref)
			set_interaction_ready(ref, false)

func is_ready_to_interact(pos: Vector2, ignore_range: bool = false) -> bool:
	if not enabled:
		return false
	if already_interacted:
		return false
	if ignore_range:
		return true
	return is_in_range(pos)

func is_in_range(pos: Vector2) -> bool:
	if node:
		return node.global_position.distance_to(pos) <= interact_radius
	return false

func set_interaction_ready(interactor: Node2D, value: bool) -> void:
	if value == _interaction_ready:
		return
	_interaction_ready = value
	if _interaction_ready:
		Interactable.ready_interactables.append(self)
		interaction_ready.emit(interactor)
	else:
		Interactable.ready_interactables.remove_at(Interactable.ready_interactables.find(self))
		interaction_unready.emit(interactor)

func enter_range(interactor: Node2D) -> void:
	if _in_range:
		return
	_in_range = true
	Interactable.in_range_interactables.append(self)
	range_entered.emit(interactor)

func exit_range(interactor: Node2D) -> void:
	if not _in_range:
		return
	_in_range = false
	Interactable.in_range_interactables.remove_at(Interactable.in_range_interactables.find(self))
	range_exited.emit(interactor)

func interact(interactor: Node2D) -> bool:
	if not enabled:
		return false
	if already_interacted:
		return false
	already_interacted = true
	interacted.emit(interactor)
	return true

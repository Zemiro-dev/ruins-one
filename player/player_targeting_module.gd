extends Node2D
class_name PlayerTargetingModule

@onready var targeting_area: Area2D = $TargetingArea


func get_next_target() -> Node2D:
	var targets := get_eligable_targets()
	if targets.size() > 0:
		return targets[0]
	return null


func get_eligable_targets() -> Array[Node2D]:
	return targeting_area.get_overlapping_bodies()

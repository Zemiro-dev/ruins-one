extends Node2D
class_name PlayerTargetingModule

@onready var targeting_area: Area2D = $TargetingArea
@export var max_range: float = 1000.
@export var angle_between_targets_tolerance: float = PI / 8.
@export var target_strategy: TargetBaseStrategy


var previous_targets: Array[Node2D] = []


func flush_memory() -> void:
	previous_targets = []


func get_next_target(targeter: Node2D, current_target: Node2D) -> Node2D:
	var targets := get_eligable_targets(targeter)
	if targets.size():
		for target in targets:
			if !previous_targets.has(target) and target != current_target:
				previous_targets.append(target)
				return target
		var i_start := previous_targets.find(current_target)
		if i_start >= 0:
			var cycled_indexes = range(i_start + 1, previous_targets.size())
			cycled_indexes.append_array(range(0, i_start))
			for i in cycled_indexes:
				var potential_target := previous_targets[i]
				if allowed_to_target(targeter, potential_target) and targets.has(potential_target):
					return potential_target
			
	flush_memory()
	return null


func get_eligable_targets(targeter: Node2D) -> Array[Node2D]:
	var targets := targeting_area.get_overlapping_bodies()
	targets.filter(func(target): allowed_to_target(targeter, target))
	targets.sort_custom(compare_targets)
	return targets


func compare_targets(a: Node2D, b: Node2D):
	var angle_a := absf(get_angle_to(a.global_position))
	var angle_b := absf(get_angle_to(b.global_position))
	if absf(angle_a - angle_b) < angle_between_targets_tolerance:
		# Angle is close enough base on distance
		var distance_a := global_position.distance_squared_to(a.global_position)
		var distance_b := global_position.distance_squared_to(b.global_position)
		return distance_a < distance_b
	else:
		# Angle is far enough apart to base on angle
		return angle_a < angle_b


func in_line_of_sight(target: Node2D) -> bool:
	return true


func in_range(targeting: Node2D, target: Node2D) -> bool:
	return targeting.global_position.distance_to(target.global_position) < max_range


func allowed_to_target(targeter:Node2D, target: Node2D) -> bool:
	return (
		(!target_strategy or target_strategy.can_target(targeter, target))
		and in_line_of_sight(target)
		and in_range(targeter, target)
	)

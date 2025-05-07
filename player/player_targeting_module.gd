extends Node2D
class_name PlayerTargetingModule

@onready var los_grace_timer: Timer = $LosGraceTimer
@onready var targeting_area: Area2D = $TargetingArea

@export var max_range: float = 1000.
@export var angle_between_targets_tolerance: float = PI / 8.
@export var target_strategy: TargetBaseStrategy
@export var los_ray_cast: RayCast2D


var previous_targets: Array[Node2D] = []
var is_losing_los: bool = false


func flush_memory() -> void:
	previous_targets = []
	is_losing_los = false
	los_grace_timer.stop()


func get_next_target(targeter: Node2D, current_target: Node2D) -> Node2D:
	var targets := get_eligable_targets(targeter)
	if targets.size():
		for target in targets:
			if !previous_targets.has(target) and target != current_target:
				if allowed_to_target(targeter, target):
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


func in_line_of_sight(target: Node2D, los_grace: bool) -> bool:
	if !los_ray_cast:
		return true
	los_ray_cast.global_position = global_position
	los_ray_cast.target_position = target.global_position - global_position
	los_ray_cast.force_raycast_update()
	var in_los: bool = !los_ray_cast.is_colliding() || los_ray_cast.get_collider() == target
	if los_grace:
		if !in_los and !is_losing_los:
			start_los_timer()
		if !in_los and is_losing_los and los_grace_timer.is_stopped():
			return false
		if in_los:
			stop_los_timer()
		return true
	
	return in_los


func start_los_timer() -> void:
	is_losing_los = true
	los_grace_timer.start()


func stop_los_timer() -> void:
	is_losing_los = false
	los_grace_timer.stop()


func in_range(targeting: Node2D, target: Node2D) -> bool:
	return targeting.global_position.distance_to(target.global_position) < max_range


func allowed_to_target(targeter:Node2D, target: Node2D, los_grace: bool = false) -> bool:
	return (
		(!target_strategy or target_strategy.can_target(targeter, target))
		and in_line_of_sight(target, los_grace)
		and in_range(targeter, target)
	)

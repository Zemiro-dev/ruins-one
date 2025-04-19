extends Node2D
class_name PlayerTargetingPivot


@export var rotation_rate: float = .2

var target_angle: float = 0.
var target_node: Node2D


func _physics_process(delta: float) -> void:
	rotation = lerp_angle(rotation, get_current_target_angle(), rotation_rate)


func get_current_target_angle() -> float:
	if target_node is Node2D:
		return global_position.angle_to_point(target_node.global_position)
	else:
		return target_angle


func set_target_angle(angle: float):
	target_angle = angle


func set_target_node(node: Node2D):
	target_node = node


func release_target_node():
	target_node = null
	target_angle = rotation

extends Node2D
class_name PlayerTargetingPivot

@onready var targeting_module: PlayerTargetingModule = $TargetingModule
@export var rotation_rate: float = .2

var target_angle: float = 0.
var target_node: Node2D
var player: Player

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
	node.tree_exited.connect(_handle_target_release)
	if target_node is Entity:
		target_node.on_death.connect(_handle_entity_death)
	GlobalSignals.player_target_requested.emit(target_node)


func release_target_node():
	if target_node:
		target_node.tree_exiting.disconnect(_handle_target_release)
		if target_node is Entity:
			target_node.on_death.disconnect(_handle_entity_death)
	target_node = null
	target_angle = rotation
	targeting_module.flush_memory()
	GlobalSignals.player_target_released.emit()


func _handle_target_request(node: Node2D) -> void:
	set_target_node(node)


func _handle_target_release() -> void:
	release_target_node()


func _handle_entity_death(entity: Entity) -> void:
	if target_node == entity:
		_handle_target_release()

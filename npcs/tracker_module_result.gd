extends Resource
class_name PositionModuleResult

@export var next_position: Vector2
@export var can_reach: bool


func _init(p_next_position: Vector2, p_can_reach: bool) -> void:
	next_position = p_next_position
	can_reach = p_can_reach

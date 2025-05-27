extends Node
class_name NavigationModule


@export var entity: Entity

func final_goal() -> Vector2:
	if entity:
		return entity.global_position
	return Vector2.ZERO


func current_goal(final_goal: Vector2) -> Vector2:
	if entity:
		return entity.global_position
	return Vector2.ZERO
	

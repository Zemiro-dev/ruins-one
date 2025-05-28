extends Node2D
class_name PositionModule


func get_goal_position(current_goal_position: Vector2) -> PositionModuleResult:
	return PositionModuleResult.new(current_goal_position, true)
	

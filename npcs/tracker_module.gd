extends PositionModule
class_name TrackerModule


@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D


func get_goal_position(current_goal_position: Vector2, fallback_position: Vector2) -> Vector2:
	navigation_agent.target_position = current_goal_position
	if !navigation_agent.is_navigation_finished():
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()
		if navigation_agent.is_target_reachable():
			return next_path_position
	
	return fallback_position

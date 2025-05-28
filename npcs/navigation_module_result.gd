extends Resource
class_name NavigationModuleResult

@export var goal: Vector2
@export var next: Vector2
@export var can_reach_goal: bool


func _init(p_goal: Vector2, p_next: Vector2, p_can_reach_goal: bool) -> void:
	goal = p_goal
	next = p_next
	can_reach_goal = p_can_reach_goal

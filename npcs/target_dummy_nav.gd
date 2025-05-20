extends Entity

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent
@export var target: Node2D

func _physics_process(delta: float) -> void:
	super(delta)
	
	if target:
		navigation_agent.target_position = target.global_position
	
	if !navigation_agent.is_navigation_finished():
		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()
		velocity = current_agent_position.direction_to(next_path_position) * 200.
	else:
		velocity = Vector2.ZERO

	move_and_resolve(delta)

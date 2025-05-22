extends Entity


@onready var los_ray_cast: RayCast2D = $LineOfSightRayCast
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent

@export var target: Node2D
@export var steer_force: float = 200.0

func _physics_process(delta: float) -> void:
	super(delta)
	
	var goal_position: Vector2
	if target:
		navigation_agent.target_position = target.global_position
		if (in_los(target.global_position)):
			goal_position = target.global_position
		else:
			if !navigation_agent.is_navigation_finished():
				var current_agent_position: Vector2 = global_position
				var next_path_position: Vector2 = navigation_agent.get_next_path_position()
				if navigation_agent.is_target_reachable():
					goal_position = next_path_position
	if goal_position:
		velocity += seek(goal_position) * delta
	move_and_resolve(delta)


func seek(target_position: Vector2) -> Vector2:
	var steer = Vector2.ZERO
	var desired = (target_position - global_position).normalized() * max_speed
	steer = (desired - velocity).normalized() * steer_force
	return steer


func in_los(los_target_position: Vector2) -> bool:
	los_ray_cast.global_position = global_position
	los_ray_cast.target_position = los_target_position - global_position
	los_ray_cast.force_raycast_update()
	return !los_ray_cast.is_colliding()

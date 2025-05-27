extends Entity


@onready var los_ray_cast: RayCast2D = $LineOfSightRayCast
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@export var target: Node2D
@export var steer_force: float = 500.0
@export var max_steer_speed: float = 500.0
@export var slow_down_distance: float = 50.0
@export var slow_down_curve: Curve
@export var kill_circle_radius: float = 200.0
var circle_rng: float = 1.0

func _ready() -> void:
	super()
	rng.randomize()
	circle_rng = rng.randf()
	

func _physics_process(delta: float) -> void:
	super(delta)
	
	var final_goal_position: Vector2 = get_kill_circle(target.global_position, circle_rng)
	var goal_position: Vector2
	if target:
		navigation_agent.target_position = final_goal_position
		if (in_los(final_goal_position)):
			goal_position = final_goal_position
		else:
			if !navigation_agent.is_navigation_finished():
				var next_path_position: Vector2 = navigation_agent.get_next_path_position()
				if navigation_agent.is_target_reachable():
					goal_position = next_path_position
	
	var acceleration: Vector2
	var distance_to_goal = goal_position.distance_to(global_position)
	if goal_position:
		var target_speed: float = max_steer_speed
		if goal_position.is_equal_approx(final_goal_position) and distance_to_goal < slow_down_distance:
			target_speed *= slow_down_curve.sample(1. - distance_to_goal / slow_down_distance)
		acceleration = seek(goal_position, target_speed)
	
	if acceleration:
		velocity += acceleration * delta
		
	move_and_resolve(delta)


func seek(target_position: Vector2, target_speed: float) -> Vector2:
	var steer = Vector2.ZERO
	var desired = (target_position - global_position).normalized() * target_speed
	steer = (desired - velocity).normalized() * steer_force
	return steer


func in_los(los_target_position: Vector2) -> bool:
	los_ray_cast.global_position = global_position
	los_ray_cast.target_position = los_target_position - global_position
	los_ray_cast.force_raycast_update()
	return !los_ray_cast.is_colliding()


func get_kill_circle(circle_center: Vector2, rand: float) -> Vector2:
	var angle = rand * PI * 2;
	var x = circle_center.x + cos(angle) * kill_circle_radius
	var y = circle_center.y + sin(angle) * kill_circle_radius
	return Vector2(x, y)

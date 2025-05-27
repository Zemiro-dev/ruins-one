extends AccelerationModule
class_name SimpleAccelerationModule


@export var steer_force: float = 500.0
@export var max_steer_speed: float = 500.0
@export var slow_down_distance: float = 50.0
@export var slow_down_curve: Curve


func get_frame_acceleration(
	current_velocity: Vector2,
	current_position: Vector2,
	current_goal: Vector2,
	final_goal: Vector2
) -> Vector2:
	var distance_to_goal = current_goal.distance_to(current_position)
	var target_speed: float = max_steer_speed
	if current_goal.is_equal_approx(final_goal) and distance_to_goal < slow_down_distance:
		target_speed *= slow_down_curve.sample(1. - distance_to_goal / slow_down_distance)
	return seek(current_goal, target_speed, current_velocity, current_position)


func seek(target_position: Vector2, target_speed: float, current_velocity: Vector2, current_position: Vector2) -> Vector2:
	var steer = Vector2.ZERO
	var desired = (target_position - current_position).normalized() * target_speed
	steer = (desired - current_velocity).normalized() * steer_force
	return steer

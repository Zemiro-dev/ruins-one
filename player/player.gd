extends Entity
class_name Player

@onready var thrust_emitter := $Thrust
@onready var proj_marker: Marker2D = $Pivot/ProjMarker
@export var current_projectile_scene: PackedScene
@export var shoot_style: ShootProjectileBaseStrategy

@export var impulse_acceleration: float = 500.0
@export var handling_multiplier: float = 3.0
@export var max_speed := 2000.0

func _physics_process(delta: float) -> void:
	super(delta)
	velocity += get_impulse_vector(delta)
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
		
	if not is_impulse_on():
		can_drag = true
		$Thrust.emitting = false
	else:
		can_drag = false
		$Thrust.emitting = true
	$Thrust.rotation = velocity.angle() + PI
	var aim = get_aim_vector()
	if !aim.is_zero_approx():
		var aim_angle = aim.angle()
		$Pivot.rotation = lerp_angle($Pivot.rotation, aim_angle, .1)
	
	if Input.is_action_just_pressed("fire"):
		var projectile: Projectile = current_projectile_scene.instantiate()
		shoot_style.shoot(projectile, self, proj_marker.global_transform)
	move_and_resolve(delta)


func is_impulse_on() -> bool:
	return not get_control_vector().is_zero_approx()


func get_impulse_vector(delta: float) -> Vector2:
	var control_vector := get_control_vector()
	var impulse := control_vector * impulse_acceleration * delta
	impulse = apply_handling_to_vector(impulse)
	return impulse


func apply_handling_to_vector(vector: Vector2) -> Vector2:
	var result := vector
	for component in range(2):
		if sign(vector[component]) != sign(velocity[component]):
			result[component] *= handling_multiplier
	return result


func get_control_vector() -> Vector2:
	return Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)


func get_aim_vector() -> Vector2:
	return Vector2(
		Input.get_axis("aim_left", "aim_right"),
		Input.get_axis("aim_up", "aim_down")
	)

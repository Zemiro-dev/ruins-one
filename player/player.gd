extends Entity
class_name Player

@onready var proj_marker: Marker2D = $Pivot/ProjMarker
@export var current_projectile_scene: PackedScene
@export var shoot_style: ShootProjectileBaseStrategy

func _physics_process(delta: float) -> void:
	velocity = get_control_vector() * 500.0
	if velocity.is_zero_approx():
		$Thrust.emitting = false
	else:
		$Thrust.emitting = true
	$Thrust.rotation = velocity.angle() + PI
	var aim = get_aim_vector()
	if !aim.is_zero_approx():
		var aim_angle = aim.angle()
		$Pivot.rotation = lerp_angle($Pivot.rotation, aim_angle, .1)
	
	if Input.is_action_just_pressed("fire"):
		var projectile: Projectile = current_projectile_scene.instantiate()
		shoot_style.shoot(projectile, self, proj_marker.global_transform)
	move_and_slide()


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

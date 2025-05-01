extends Resource
class_name ShootProjectileBaseStrategy

func shoot(proj: Projectile, shooter: Entity, global_transform: Transform2D, target: Node2D = null) -> void:
	proj.global_transform = global_transform
	proj.rotation += randf_range(-proj.radial_spread, proj.radial_spread)
	var spread: Vector2 = Vector2(0., randf_range(-proj.side_spread, proj.side_spread))
	spread = spread.rotated(global_transform.get_rotation())
	proj.position += spread
	proj.velocity = proj.transform.x * proj.initial_speed
	proj.velocity += proj.eject_velocity.rotated(proj.eject_velocity.angle_to(proj.transform.x))
	proj.set_target(target)
	proj.shooter = shooter	
	GlobalSignals.projectile_nest_requested.emit(proj)

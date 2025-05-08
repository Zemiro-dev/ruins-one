extends Resource
class_name ShootProjectileBaseStrategy

func shoot(proj: Projectile, shooter: Entity, global_transform: Transform2D, target: Node2D = null) -> void:
	proj.global_transform = global_transform
	proj.set_target(target)
	proj.shooter = shooter	
	GlobalSignals.projectile_nest_requested.emit(proj)

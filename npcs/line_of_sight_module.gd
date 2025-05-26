extends Node2D
class_name LineOfSightModule

@onready var los_ray_cast: RayCast2D = $LosRayCast


func in_los(los_target_position: Vector2) -> bool:
	los_ray_cast.global_position = global_position
	los_ray_cast.target_position = los_target_position - global_position
	los_ray_cast.force_raycast_update()
	return !los_ray_cast.is_colliding()

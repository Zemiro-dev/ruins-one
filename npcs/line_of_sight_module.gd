extends Node2D
class_name LineOfSightModule

@onready var los_ray_cast: RayCast2D = $LosRayCast
@export_flags_2d_physics var line_of_sight_collision_mask: int:
	set(value):
		if los_ray_cast:
			los_ray_cast.collision_mask = line_of_sight_collision_mask
		line_of_sight_collision_mask = value

func _ready() -> void:
	los_ray_cast.collision_mask = line_of_sight_collision_mask

func in_los(los_target_position: Vector2) -> bool:
	los_ray_cast.global_position = global_position
	los_ray_cast.target_position = los_target_position - global_position
	los_ray_cast.force_raycast_update()
	return !los_ray_cast.is_colliding()

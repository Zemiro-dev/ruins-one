extends Node


signal camera_shake_requested(duration: float, strength: float)
signal node_spawn_requested(node: Node2D)
signal projectile_spawn_requested(node: Projectile)
signal particle_spawn_requested(node: Entity)
signal breakable_spawn_requested(node: Entity)
signal collectable_spawn_requested(node: Entity)
signal enemy_spawn_requested(node: Entity)
signal player_spawn_requested(node: Player)
signal player_target_requested(node: Node2D)
signal player_target_released(node: Node2D)

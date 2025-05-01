extends Node


signal camera_shake_requested(duration: float, strength: float)
signal node_nest_requested(node: Node2D)
signal projectile_nest_requested(node: Projectile)
signal particle_nest_requested(node: Entity)
signal breakable_nest_requested(node: Entity)
signal collectable_nest_requested(node: Entity)
signal enemy_nest_requested(node: Entity)
signal player_nest_requested(node: Player)
signal player_target_requested(node: Node2D)
signal player_target_released(node: Node2D)

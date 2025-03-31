extends Node
class_name ProjectileManager


func _ready() -> void:
	GlobalSignals.projectile_spawn_requested


func spawn_projectile(projectile: Projectile):
	add_child(projectile)

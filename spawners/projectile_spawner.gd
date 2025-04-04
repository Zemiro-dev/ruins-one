extends NodeSpawner


func _ready() -> void:
	GlobalSignals.projectile_spawn_requested.connect(spawn)

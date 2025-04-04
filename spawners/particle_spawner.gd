extends NodeSpawner


func _ready() -> void:
	GlobalSignals.particle_spawn_requested.connect(spawn)

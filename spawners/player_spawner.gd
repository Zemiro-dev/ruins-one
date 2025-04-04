extends NodeSpawner


func _ready() -> void:
	GlobalSignals.player_spawn_requested.connect(spawn)

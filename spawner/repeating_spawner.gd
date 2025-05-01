extends Marker2D

@export var spawn_scene: PackedScene
@export var max_respawn_delay: float = 5.
@export var active: bool = true
@export var nest_signal_name: String = 'enemy_nest_requested'
var spawned_child: Node2D
var respawn_delay: float = 0.

func _physics_process(delta: float) -> void:
	if active:
		if (!is_instance_valid(spawned_child) and
			spawn_scene and 
			spawn_scene.can_instantiate() 
			and respawn_delay <= 0):
			spawn()
			is_instance_valid(spawned_child)
		if !is_instance_valid(spawned_child) and respawn_delay > 0:
			respawn_delay -= delta


func spawn() -> void:
	spawned_child = spawn_scene.instantiate()
	spawned_child.global_position = global_position
	GlobalSignals.get(nest_signal_name).emit(spawned_child)
	respawn_delay = max_respawn_delay

extends Node2D
class_name TrackingOrb


@export var tracking_rate: float = .2
@onready var orb_particles: CPUParticles2D = $OrbParticles

var target_node: Node2D
var host: Node2D
var follow_host: bool = true


func _ready() -> void:
	orb_particles.finished.connect(_orb_particles_finished)


func _physics_process(delta: float) -> void:
	if !target_node:
		orb_particles.emitting = false
		if follow_host:
			move_to_host()
	else:
		orb_particles.emitting = true
		follow_host = false
		position = lerp(position, target_node.global_position, tracking_rate)


func _orb_particles_finished() -> void:
	follow_host = true
	move_to_host()


func move_to_host() -> void:
	if host:
		global_position = host.global_position


func set_target_node(node: Node2D):
	target_node = node


func release_target_node():
	target_node = null
	

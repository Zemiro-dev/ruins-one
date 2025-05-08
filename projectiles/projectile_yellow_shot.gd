extends Projectile


@export var activation_speed: float = 510.
@export var trail_particle_scene: PackedScene
var trail_particle: ProjectileTrail

func _ready() -> void:
	super()
	trail_particle 	= trail_particle_scene.instantiate()
	trail_particle.global_transform = global_transform
	tree_exiting.connect(func() -> void: trail_particle.deactivate_and_fade())
	GlobalSignals.particle_nest_requested.emit(trail_particle)

func _physics_process(delta: float) -> void:
	super(delta)
	trail_particle.global_transform = global_transform
	if velocity.length() >= activation_speed:
		trail_particle.activate()

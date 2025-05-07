extends Entity

@onready var projectile_marker: Marker2D = $Pivot/ProjectileMarker
@export var current_projectile_scene: PackedScene
@export var shoot_style: ShootProjectileBaseStrategy
@export var max_weapon_cooldown: float = .5
var weapon_cooldown: float = 0

func _physics_process(delta: float) -> void:
	super(delta)
	if weapon_cooldown > 0:
		weapon_cooldown -= delta
	else:
		weapon_cooldown = max_weapon_cooldown
		var projectile: Projectile = current_projectile_scene.instantiate()
		shoot_style.shoot(projectile, self, projectile_marker.global_transform)
	move_and_resolve(delta)

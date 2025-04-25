extends Entity
class_name Player


@onready var thrust_particles: CPUParticles2D = $ThrustParticles
@onready var dash_particles: CPUParticles2D = $DashParticles
@onready var targeting_pivot: PlayerTargetingPivot = $TargetingPivot
@onready var proj_marker: Marker2D = $TargetingPivot/ProjMarker
@onready var targeting_module: PlayerTargetingModule = $TargetingPivot/TargetingModule
@onready var break_particles: CPUParticles2D = $BreakParticles
@onready var break_pad: Sprite2D = $BreakPad

@export var current_projectile_scene: PackedScene
@export var shoot_style: ShootProjectileBaseStrategy

@export var impulse_acceleration: float = 1000.0
@export var handling_multiplier: float = 3.0

@export var release_target_deadzone: float = .5
@export var release_target_angle: float = PI / 2.

var max_dash_cooldown: float = .1
var dash_cooldown: float = 0.0

@export var max_weapon_cooldown: float = .1
var weapon_cooldown: float = 0.0


func _physics_process(delta: float) -> void:
	super(delta)
	velocity += get_impulse_vector(delta)
		
	if not is_impulse_on():
		can_drag = true
		thrust_particles.emitting = false
	else:
		can_drag = false
		thrust_particles.emitting = true
	thrust_particles.rotation = velocity.angle() + PI
	var aim = get_aim_vector()
	if !aim.is_zero_approx():
		var aim_angle = aim.angle()
		targeting_pivot.set_target_angle(aim_angle)
	
	if Input.is_action_pressed("fire") and weapon_cooldown <= 0:
		weapon_cooldown = max_weapon_cooldown
		var projectile: Projectile = current_projectile_scene.instantiate()
		shoot_style.shoot(projectile, self, proj_marker.global_transform)
	
	if Input.is_action_just_pressed("dash") and dash_cooldown <= 0.:
		dash_particles.emitting = true
		dash_cooldown = max_dash_cooldown
		if is_impulse_on():
			velocity = get_impulse_vector(delta).normalized() * max_speed
		else:
			velocity = velocity.normalized() * max_speed
			
	if dash_cooldown > -.4:
		dash_cooldown -= delta
	else:
		dash_particles.emitting = false
	
	
	if Input.is_action_just_pressed("break"):
		break_particles.emitting = true		
	
	if Input.is_action_pressed("break"):
		drag_strategy.velocity_decay_rate = .16
		can_drag = true
		var tween: Tween = create_tween()
		tween.tween_property(break_pad, "modulate", Color(1, 1, 1, 1), .1)
	else:
		drag_strategy.velocity_decay_rate = .01
		var tween: Tween = create_tween()
		tween.tween_property(break_pad, "modulate", Color(1, 1, 1, 0), .1)
	
	if Input.is_action_just_pressed("target"):
		var target_node: Node2D = targeting_module.get_next_target(self, targeting_pivot.target_node)
		var release: bool = false
		if target_node and aim.length() > release_target_deadzone:
			var angle_to_target: float = global_position.angle_to(target_node.global_position) if target_node else 0.
			release = absf(angle_to_target - aim.angle()) > release_target_angle
		if target_node and !release:
			targeting_pivot.set_target_node(target_node)
		else:
			targeting_pivot.release_target_node()
	
	if (targeting_pivot.target_node
		and !targeting_module.allowed_to_target(self, targeting_pivot.target_node)):
		targeting_pivot.release_target_node()
		
	
	if weapon_cooldown > 0:
		weapon_cooldown -= delta
	
	move_and_resolve(delta)


func get_facing_rotation() -> float:
	return targeting_pivot.rotation


func is_impulse_on() -> bool:
	return not get_control_vector().is_zero_approx()


func get_impulse_vector(delta: float) -> Vector2:
	var control_vector := get_control_vector()
	var impulse := control_vector * impulse_acceleration * delta
	impulse = apply_handling_to_vector(impulse)
	return impulse


func apply_handling_to_vector(vector: Vector2) -> Vector2:
	var result := vector
	for component in range(2):
		if sign(vector[component]) != sign(velocity[component]):
			result[component] *= handling_multiplier
	return result


func get_control_vector() -> Vector2:
	return Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)


func get_aim_vector() -> Vector2:
	return Vector2(
		Input.get_axis("aim_left", "aim_right"),
		Input.get_axis("aim_up", "aim_down")
	)

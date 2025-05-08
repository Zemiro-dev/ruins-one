extends Area2D
class_name Projectile


@onready var lifetime: Timer = $Lifetime
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var detection_area: Area2D = $DetectionArea
@onready var det_proj_marker: Marker2D = $DetProjMarker
@onready var det_particle_marker: Marker2D = $DetParticleMarker

@export var detonate_projectile_scene: PackedScene
@export var detonate_particle_scene: PackedScene
@export var eject_velocity := Vector2(0., 0.)
@export var initial_speed := 500.
@export var acceleration := Vector2.ZERO
@export var natural_acceleration := Vector2.ZERO
@export var max_speed := 1500.0
@export var steer_force = 2000.0
@export var radial_spread := 0.
@export var side_spread := 0.
@export var cooldown := .5
@export var add_host_velocity: bool = false
@export var match_rotation_to_velocity: bool = true
@export var use_detection_area: bool = false

## Difficulty in targeting this projectile 0-10
@export var detection_difficulty: int = 5

@export var target_strategy: TargetBaseStrategy

## Max health this projectile will take before exploding.
@export var max_health: int = 1
var current_health: int

## Is this projectile able to take damage
var is_dead: bool = false

var velocity := Vector2.ZERO
var target: Node2D

var shooter: Node2D


func _ready() -> void:
	rotation += randf_range(-radial_spread, radial_spread)
	var spread: Vector2 = Vector2(0., randf_range(-side_spread, side_spread))
	spread = spread.rotated(global_transform.get_rotation())
	position += spread
	velocity = transform.x * initial_speed
	velocity += eject_velocity.rotated(eject_velocity.angle_to(transform.x))
	connect_signals()
	current_health = max_health


func connect_signals() -> void:
	#signal setup
	lifetime.timeout.connect(_on_lifetime_timeout)
	body_entered.connect(_on_body_entered)
	hurtbox.damage_dealt.connect(_on_damage_dealt)
	if detection_area != null && use_detection_area:
		detection_area.body_entered.connect(set_target)
		detection_area.area_entered.connect(set_target)

func _physics_process(delta: float) -> void:
	if target != null:
		acceleration += seek()
	else:
		acceleration += natural_acceleration.rotated(natural_acceleration.angle_to(velocity))
	velocity += acceleration * delta
	velocity = velocity.limit_length(max_speed)
	if match_rotation_to_velocity:
		rotation = velocity.angle()
	position += velocity * delta

func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.global_position - global_position).normalized() * max_speed
		steer = (desired - velocity).normalized() * steer_force
	return steer

# sets target 
func set_target(body:Node2D, overwrite: bool = false) -> void:
	if target == null || overwrite:
		if body != null and !body.get("is_dead") and (target_strategy == null or target_strategy.can_target(self, body)):
			target = body
			if target.has_signal("on_death"):	
				target.on_death.connect(
					func(dead_node: Node2D):
						if target == dead_node:
							release_target()
				)	


func release_target() -> void:
	target = null


func take_damage(damage: int, attacker: Node2D, hurtbox: Hurtbox):
	current_health -= damage
	if current_health <= 0:
		current_health = 0
		is_dead = true
		monitorable = false
		detonate()


func detonate():
	if !!detonate_particle_scene:
		var particle = detonate_particle_scene.instantiate()
		particle.global_transform = det_particle_marker.global_transform
		GlobalSignals.particle_nest_requested.emit(particle)
	if !!detonate_projectile_scene:
		pass
	fade()


func fade() -> void:
	queue_free()


func _on_lifetime_timeout() -> void:
	detonate()


func _on_body_entered(body: Node2D) -> void:
	if body == shooter:
		return
	if body is SquishButton:
		body.activate()
	detonate()


func _on_damage_dealt(body: Node2D) -> void:
	if !hurtbox.active_scan:
		detonate()


func _on_detection_zone_entered(body: Node2D) -> void:
	set_target(body)

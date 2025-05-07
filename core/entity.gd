extends CharacterBody2D
class_name Entity

signal on_damage_taken(attacker: Node2D)
signal on_health_changed(new_health: int, max_health: int)
signal on_shield_changed(new_shield: int, max_shield: int)
signal on_death(entity: Entity)

@export var max_health := 1
var current_health := 1
@export var max_shield := 0
var current_shield := 0
@export var max_speed: float = 1500.

@export var max_invulnerability_time := 0.0
var remaining_invulnerability_time := 0.0

@export var allow_knockback := true
@export var knockback_decay_rate := .1
var current_knockback: Vector2 = Vector2.ZERO

@export var drag_strategy: DragBaseStrategy
var can_drag := true

@export var move_resolve_strategy: MoveResolveStrategy

var is_dead := false
var is_invincible := false

@export var should_play_damage_tween: bool = true
@export var health_damage_tween_color := Color(1., .6, .6)
@export var shield_damage_tween_color := Color(.8, .8, 1.) 
var modulate_tween: Tween = null
var initial_modulate: Color

var collision_core: Node2D
var collision_shield: Node2D
var shield: Shield

@export var current_death_explosion_scene: PackedScene


func _ready() -> void:
	current_health = max_health
	current_shield = max_shield
	initial_modulate = modulate
	collision_core = get_node_or_null("CollisionCore")
	collision_shield = get_node_or_null("CollisionShield")
	shield = get_node_or_null("Shield")
	if shield:
		if current_shield > 0:
			shield.on()
		else:
			shield.off()
	updateCollisionShapes()


func _physics_process(delta: float) -> void:
	updateCollisionShapes()
	if remaining_invulnerability_time > 0.0:
		remaining_invulnerability_time -= delta
	if !current_knockback.is_zero_approx():
		velocity += current_knockback
		current_knockback = current_knockback.lerp(Vector2.ZERO, knockback_decay_rate)
	if can_drag and !!drag_strategy:
		velocity = drag_strategy.drag(velocity)


func move_and_resolve(delta: float) -> void:
	if !!move_resolve_strategy:
		move_resolve_strategy.move_and_resolve(self, delta)
	else:
		move_and_slide()

func is_invulnerable():
	return remaining_invulnerability_time > 0;


func can_knockback():
	return !is_invulnerable() and allow_knockback


func updateCollisionShapes() -> void:
	if collision_core != null:
		collision_core.set_deferred("disabled", current_health <= 0)	
	
	if collision_shield != null:
		collision_shield.set_deferred("disabled", current_shield <= 0)


func can_be_damaged() -> bool:
	return !is_dead && !is_invincible


func take_damage(damage: int, attacker: Node2D, hurtbox: Hurtbox):
	if !can_be_damaged():
		return
	var tween_color := health_damage_tween_color
	if current_shield > 0:
		current_shield -= damage
		if shield: shield.pulse()
		if current_shield <= 0:
			current_shield = 0
			if shield: shield.off()
		on_shield_changed.emit(current_shield, max_shield)
		tween_color = shield_damage_tween_color
	else:
		current_health -= damage
		on_health_changed.emit(current_health, max_health)
	
	on_damage_taken.emit(attacker)
	if can_knockback() and hurtbox.knockback_strategy:
		hurtbox.knockback_strategy.knockback(self, hurtbox.damage_source)
	
	if max_invulnerability_time > 0.0 and current_health > 0:
		remaining_invulnerability_time = max_invulnerability_time

	if current_health > 0:
		play_damage_tween(tween_color)
	
	if current_health <= 0:
		die()


func die() -> void:
	is_dead = true
	on_death.emit(self)


func restore_health(health: int):
	var previous_health = current_health
	current_health = clampi(current_health + health, current_health, max_health)
	if current_health != previous_health:
		on_health_changed.emit(current_health, max_health)


func restore_shield(amount: int):
	var previous_shield = current_shield
	current_shield = clampi(current_shield + amount, current_shield, max_shield)
	if current_shield != previous_shield:
		on_shield_changed.emit(current_shield, max_shield)
		if previous_shield <= 0 and shield: shield.on()


func play_damage_tween(color: Color) -> Tween:
	if not should_play_damage_tween: return null
	if modulate_tween != null: 
		modulate_tween.kill()
		modulate = initial_modulate
		
	modulate_tween = create_tween()
	modulate_tween.tween_property(self, "modulate", color, .2)
	modulate_tween.tween_property(self, "modulate", Color(1, 1, 1), .2)
	return modulate_tween


func cap_velocity() -> void:
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed


func death_explosion() -> bool:
	if current_death_explosion_scene:
		var explosion: CPUParticles2D = current_death_explosion_scene.instantiate()
		explosion.global_transform = global_transform
		explosion.rotation = velocity.angle()
		explosion.initial_velocity_min = velocity.length() / 8.
		explosion.initial_velocity_max = velocity.length() / 4.
		GlobalSignals.particle_nest_requested.emit(explosion)
		return true
	return false

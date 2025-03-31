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

var is_dead := false
var is_invincible := false


func _ready() -> void:
	current_health = max_health
	current_shield = max_shield


func can_be_damaged() -> bool:
	return !is_dead && !is_invincible


func take_damage(damage: int, attacker: Node2D):
	if !can_be_damaged():
		return
	if current_shield > 0:
		current_shield -= damage
		if current_shield <= 0:
			current_shield = 0
		on_shield_changed.emit(current_shield, max_shield)
	else:
		current_health -= damage
		on_health_changed.emit(current_health, max_health)
	
	on_damage_taken.emit(attacker)
	if current_health <=	 0:
		die()


func die() -> void:
	is_dead 	= true
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

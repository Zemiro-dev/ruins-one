extends State


var current_regenerating_time: float = 0.

func _enter(previous_state, host: ShieldControlModule) -> void:
	if host.regeneration_time > 0:
		current_regenerating_time = host.regeneration_time


func _exit(new_state, host: ShieldControlModule) -> void:
	current_regenerating_time = 0


func _execute(delta: float, host: ShieldControlModule) -> void:
	if current_regenerating_time <= 0:
		host.entity.restore_shield(host.regeneration_amount)
		current_regenerating_time = host.regeneration_time
	if current_regenerating_time > 0:
		current_regenerating_time -= delta


func _get_next_state(host: ShieldControlModule):
	var entity: Entity = host.entity
	if entity:
		if entity.current_shield == entity.max_shield:
			return host.States.IDLE
		if entity.current_shield <= 0:
			return host.States.DEAD
		if host.cycle_stun():
			return host.States.STUNNED
		
	return null

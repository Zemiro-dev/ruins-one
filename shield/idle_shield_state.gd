extends State

func _enter(previous_state, host: ShieldControlModule) -> void:
	pass


func _exit(new_state, host: ShieldControlModule) -> void:
	pass


func _execute(delta: float, host: ShieldControlModule) -> void:
	pass


func _get_next_state(host: ShieldControlModule):
	var entity: Entity = host.entity
	if entity:
		if entity.current_shield <= 0:
			return host.States.DEAD
		if host.cycle_stun():
			return host.States.STUNNED
		if (entity.current_shield < entity.max_shield
			and host.regeneration_time > 0
		):
			return host.States.REGENERATING			
	return null

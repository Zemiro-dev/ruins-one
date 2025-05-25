extends State


var current_reactivation_time: float = 0.

func _enter(previous_state, host: ShieldControlModule) -> void:
	current_reactivation_time = host.reactivation_time


func _exit(new_state, host: ShieldControlModule) -> void:
	pass


func _execute(delta: float, host: ShieldControlModule) -> void:
	if current_reactivation_time > 0:
		current_reactivation_time -= delta


func _get_next_state(host: ShieldControlModule):
	var entity: Entity = host.entity
	if entity:
		if host.cycle_stun():
			return host.States.REACTIVATING
		if entity.current_shield == 0 and current_reactivation_time <= 0:
			host.entity.restore_shield(host.reactivation_amount)
			host.shield.on()
			return host.States.IDLE
	return null

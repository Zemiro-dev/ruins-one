extends State

func _enter(previous_state, host: ShieldControlModule) -> void:
	host.shield.off()
	host.cycle_stun()


func _exit(new_state, host: ShieldControlModule) -> void:
	pass


func _execute(delta: float, host: ShieldControlModule) -> void:
	pass


func _get_next_state(host: ShieldControlModule):
	if host.reactivation_time > 0:
		return host.States.REACTIVATING
	return null

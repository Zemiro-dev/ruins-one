extends State


var current_stunned_timer: float = 0.

func _enter(previous_state, host: ShieldControlModule) -> void:
	current_stunned_timer = host.stunned_time


func _exit(new_state, host: ShieldControlModule) -> void:
	pass


func _execute(delta: float, host: ShieldControlModule) -> void:
	if current_stunned_timer > 0:
		current_stunned_timer -= delta


func _get_next_state(host: ShieldControlModule):
	var entity: Entity = host.entity
	if entity:
		if entity.current_shield <= 0:
			return host.States.DEAD
		if host.cycle_stun():
			return host.States.STUNNED
		if current_stunned_timer <= 0:
			return host.States.IDLE
	return null

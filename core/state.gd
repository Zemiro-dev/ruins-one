extends Node
class_name State

func _enter(previous_state: State, host) -> void:
	pass


func _exit(new_state: State, host) -> void:
	pass


func _execute(delta: float, host) -> void:
	pass


func _get_next_state(host):
	return null

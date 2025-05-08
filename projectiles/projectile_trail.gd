extends CPUParticles2D
class_name ProjectileTrail


func _ready() -> void:
	finished.connect(_handle_finished)


func activate() -> void:
	emitting = true


func deactivate_and_fade() -> void:
	emitting = false

func _handle_finished() -> void:
	queue_free()

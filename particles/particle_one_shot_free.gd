extends GPUParticles2D

func _ready() -> void:
	finished.connect(clear)
	emitting = true


func clear() -> void:
	queue_free()

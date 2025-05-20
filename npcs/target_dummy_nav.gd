extends Entity


func _physics_process(delta: float) -> void:
	super(delta)
	move_and_resolve(delta)

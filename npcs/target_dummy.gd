extends Entity


func _physics_process(delta: float) -> void:
	super(delta)
	$Marker2D/Label.text = str(current_health)
	move_and_slide()

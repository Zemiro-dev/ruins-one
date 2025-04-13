extends Entity


func _physics_process(delta: float) -> void:
	super(delta)
	$Marker2D/Label.text = str(current_health)
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		current_knockback = current_knockback.bounce(collision.get_normal())
		#velocity = velocity.slide(collision.get_normal())
		#current_knockback = current_knockback.slide(collision.get_normal())

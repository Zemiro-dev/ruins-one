extends Entity


func _physics_process(delta: float) -> void:
	super(delta)
	$Marker2D/Label.text = str(current_health)
	var collision = move_and_collide(velocity * delta)
	if collision:
		if !velocity.is_zero_approx():
			velocity = velocity.bounce(collision.get_normal())
			current_knockback = current_knockback.bounce(collision.get_normal())
		else:
			velocity = collision.get_normal() * 10.
		#velocity = velocity.slide(collision.get_normal())
		#current_knockback = current_knockback.slide(collision.get_normal())

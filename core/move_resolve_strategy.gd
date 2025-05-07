extends Resource
class_name MoveResolveStrategy


## Move the entity and resolve any collisions
func move_and_resolve(entity: Entity, delta: float) -> void:
	entity.cap_velocity()
	var collision = entity.move_and_collide(
		entity.velocity * delta,
		true
	)
	if collision:
		# TODO need to ripple not pulse
		#if entity.shield: entity.shield.pulse()
		if !entity.velocity.is_zero_approx():
			entity.velocity = entity.velocity.bounce(
				collision.get_normal()
			)
			entity.current_knockback = entity.current_knockback.bounce(
				collision.get_normal()
			)
		var collider = collision.get_collider()
		if collider is Entity:
			# TODO Need to ripple not pulse
			#if collider.shield: collider.shield.pulse()
			# TODO The enemy should inform the collision partner of an impact 
			# TODO weight ratio
			# TODO the bounce code below is messing it up
			if !collider.velocity.is_zero_approx():
				var collision_velocity = collider.velocity.length() * collision.get_normal() * 1.
				entity.velocity += collision_velocity
				collider.velocity -= collision_velocity
	entity.cap_velocity()
	entity.move_and_collide(entity.velocity * delta)

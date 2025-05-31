extends Resource
class_name MoveResolveStrategy


## Move the entity and resolve any collisions
## Stolen from https://www.youtube.com/watch?app=desktop&v=1L2g4ZqmFLQ
## There is an issue with movement due to the calculated normal and the hex
## shields. Might need to fuck with it based on best feed.
## look at https://web.archive.org/web/20160418004153/http://freespace.virgin.net/hugo.elias/models/m_snokr.htm
## I put a screenshot in the docs too
func move_and_resolve(entity: Entity, delta: float) -> void:
	entity.cap_velocity()
	var collision: KinematicCollision2D = entity.move_and_collide(
		entity.velocity * delta,
		true
	)
	if collision:
		var collider: Object = collision.get_collider()
		if collider is Entity:
			var rel_velocity = entity.velocity - collider.velocity
			var impulse_magnitude = -rel_velocity.dot(collision.get_normal()) / 2 # TODO mass based/ (1/m1 + 1/m2) 
			var impulse_direction = collision.get_normal()
			var impulse = impulse_direction * impulse_magnitude
			entity.velocity = impulse
			collider.velocity = -impulse
			# TODO what should I actually do with knockback?
			var pause_drag_time: float = .0
			entity.pause_drag(pause_drag_time)
			collider.pause_drag(pause_drag_time)
			entity.current_knockback = Vector2.ZERO
			collider.current_knockback = Vector2.ZERO
			pass
		else:
			if !entity.velocity.is_zero_approx():
				entity.velocity = entity.velocity.bounce(
					collision.get_normal()
				)
				entity.velocity += entity.velocity.normalized() * collision.get_depth()
			else:
				entity.velocity = collision.get_normal() * collision.get_depth()
			if !entity.current_knockback.is_zero_approx():
				entity.current_knockback = entity.current_knockback.bounce(
					collision.get_normal()
				)
	entity.cap_velocity()
	entity.move_and_collide(entity.velocity * delta)

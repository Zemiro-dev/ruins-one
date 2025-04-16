extends Resource
class_name MoveResolveStrategy


## Returnes a dragged velocity based on the strategy
func move_and_resolve(entity: Entity, delta: float) -> void:
	var collision = entity.move_and_collide(
		entity.velocity * delta,
		true
	)
	if collision:
		if !entity.velocity.is_zero_approx():
			entity.velocity = entity.velocity.bounce(
				collision.get_normal()
			)
			entity.current_knockback = entity.current_knockback.bounce(
				collision.get_normal()
			)
	entity.move_and_collide(entity.velocity * delta)

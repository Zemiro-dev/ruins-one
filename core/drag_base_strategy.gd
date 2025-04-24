extends Resource
class_name DragBaseStrategy

@export var velocity_decay_rate := .01

## Returnes a dragged velocity based on the strategy
func drag(velocity: Vector2) -> Vector2:
	var dragged_velocity := velocity.lerp(Vector2.ZERO, velocity_decay_rate)
	return dragged_velocity

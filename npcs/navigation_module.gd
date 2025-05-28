extends Node
class_name NavigationModule


@export var entity: Entity

func navigate() -> NavigationModuleResult:
	if entity:
		return NavigationModuleResult.new(
			entity.global_position,
			entity.global_position,
			true
		)
	return NavigationModuleResult.new(Vector2.ZERO, Vector2.ZERO, false)

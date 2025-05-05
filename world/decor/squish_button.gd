extends StaticBody2D
class_name SquishButton


@export var activation_target_node: Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var is_activated: bool = false

func activate() -> void:
	if is_activated:
		return
	is_activated = true
	animation_player.play("activate")
	if activation_target_node and activation_target_node.has_method("activate"):
		activation_target_node.activate()

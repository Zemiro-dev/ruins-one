extends Camera2D
class_name CoreCamera


@export var base_offset := Vector2(0., 0.)
@export var offset_tracking_rate := 2.
@export var zoom_tracking_rate := 2.

var player: Player

var shake_offset := Vector2.ZERO
var shake_strength := 0.0

@onready var shake_timer: Timer = $ShakeTimer


func _ready() -> void:
	offset = base_offset
	GlobalSignals.camera_shake_requested.connect(shake)


func assignToPlayer(playerToWatch: Player):
	player = playerToWatch
	reparent(player)


func shake(duration: float, strength: float):
	shake_timer.start(duration)
	shake_strength = strength


func next_shake_offset() -> Vector2:
	if not shake_timer.is_stopped():
		return Vector2(
			randf_range(-1, 1) * shake_strength,
			randf_range(-1, 1) * shake_strength
		)
	else:
		return shake_offset.lerp(Vector2.ZERO, 0.5)


func next_base_offset() -> Vector2:
	if player != null:
		var player_rotation = player.get_facing_rotation()
		return base_offset.rotated(player_rotation)
	return base_offset


func next_zoom(delta: float) -> Vector2:
	var target_zoom := Vector2.ONE
	if player != null:
		var speed := player.velocity.length()
		if speed > 1500.:
			var zoom_component := 1. - ((speed - 1500.) / 1500. * .5)
			target_zoom = Vector2(zoom_component, zoom_component)
	target_zoom = zoom.lerp(target_zoom, zoom_tracking_rate * delta)
	return target_zoom


func _process(delta: float) -> void:
	shake_offset = next_shake_offset()
	var target_offset := next_base_offset() + shake_offset
	offset = offset.lerp(target_offset, offset_tracking_rate * delta)
	zoom = next_zoom(delta)

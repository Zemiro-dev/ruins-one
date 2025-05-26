extends Entity
class_name Enemy


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var explode_audio: ExtendedAudioStreamPlayer2D = $Audio/ExplodeAudio
@onready var audio: Node2D = $Audio
@export var target: Entity
@export var steer_force: float = 500.0

func _physics_process(delta: float) -> void:
	super(delta)
	# Remember to turn off drag if we have a goal velocity
	move_and_resolve(delta)


func seek(target_position: Vector2, target_speed: float) -> Vector2:
	var steer = Vector2.ZERO
	var desired = (target_position - global_position).normalized() * target_speed
	steer = (desired - velocity).normalized() * steer_force
	return steer


func die() -> void:
	super()
	current_knockback = Vector2.ZERO
	if animation_player.has_animation("die"):
		animation_player.play("die")


func play_explosion_audio() -> void:
	if is_ancestor_of(explode_audio):
		audio.remove_child(explode_audio)
		explode_audio.global_position = global_position
		GlobalSignals.audio_nest_requested.emit(explode_audio)

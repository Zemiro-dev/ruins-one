extends Entity

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var explode_audio: AudioStreamPlayer2D = $Audio/ExplodeAudio
@onready var audio: Node = $Audio

func _ready() -> void:
	super()
	#shield_refill.timeout.connect(
		#func() -> void:
			#shield.on()
			#current_shield = max_shield
	#)
 
func _physics_process(delta: float) -> void:
	super(delta)
	#velocity += Vector2(0, 1000. * delta)
	#if current_shield <= 0 and shield_refill.is_stopped():
		#shield_refill.start()
	if current_shield > 0:
		$Marker2D/Label.text = str(current_shield)
		$Marker2D/Label.modulate = Color(.5, .5, 1.)
	else:
		$Marker2D/Label.text = str(current_health)
		$Marker2D/Label.modulate = Color(1., 1., 1.)
	move_and_resolve(delta)


func die() -> void:
	super()
	current_knockback = Vector2.ZERO
	animation_player.play("die")


func play_explosion_audio() -> void:
	if is_ancestor_of(explode_audio):
		audio.remove_child(explode_audio)
		explode_audio.global_position = global_position
		GlobalSignals.audio_nest_requested.emit(explode_audio)

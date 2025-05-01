extends NodeNest


func _ready() -> void:
	GlobalSignals.audio_nest_requested.connect(nest)


func nest(node: Node2D) -> void:
	super(node)
	if node is ExtendedAudioStreamPlayer2D:
		node.play_at_random_pitch()
	elif node is AudioStreamPlayer2D:
		node.play()

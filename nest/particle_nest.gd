extends NodeNest


func _ready() -> void:
	GlobalSignals.particle_nest_requested.connect(nest)

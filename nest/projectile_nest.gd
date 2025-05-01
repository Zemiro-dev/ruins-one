extends NodeNest


func _ready() -> void:
	GlobalSignals.projectile_nest_requested.connect(nest)

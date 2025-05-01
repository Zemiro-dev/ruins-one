extends NodeNest


func _ready() -> void:
	GlobalSignals.enemy_nest_requested.connect(nest)

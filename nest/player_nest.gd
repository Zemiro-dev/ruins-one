extends NodeNest


func _ready() -> void:
	GlobalSignals.player_nest_requested.connect(nest)

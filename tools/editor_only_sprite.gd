@tool
extends Sprite2D

func _ready() -> void:
	if !Engine.is_editor_hint():
		hide()

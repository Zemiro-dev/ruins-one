extends Node2D
class_name Door

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_open: bool = false


func activate() -> void:
	if is_open: 
		close()
	else: 
		open()


func open() -> void:
	if is_open: return
	if animation_player.is_playing():
		animation_player.stop()
	is_open = true
	animation_player.play("open")


func close() -> void:
	if !is_open: return
	if animation_player.is_playing():
		animation_player.stop()
	is_open = false
	animation_player.play("close")

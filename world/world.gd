extends Node2D
class_name World

@export var player_scene : PackedScene

@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var main_camera: CoreCamera = $MainCamera
@onready var player_nest: Node = $PlayerNest

func _ready() -> void:
	spawn_player()

func spawn_player() -> void:
	if player_scene:
		var player: Player = player_scene.instantiate()
		main_camera.assignToPlayer(player)
		player.global_transform = player_spawn.global_transform
		GlobalSignals.player_spawn_requested.emit(player)
	

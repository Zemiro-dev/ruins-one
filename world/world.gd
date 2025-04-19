extends Node2D
class_name World

@export var player_scene : PackedScene

@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var main_camera: CoreCamera = $MainCamera
@onready var player_nest: Node = $PlayerNest
@onready var player_tracking_orb: TrackingOrb = $IndicatorNext/PlayerTrackingOrb

func _ready() -> void:
	spawn_player()

func spawn_player() -> void:
	if player_scene:
		var player: Player = player_scene.instantiate()
		main_camera.assignToPlayer(player)
		player.global_transform = player_spawn.global_transform
		GlobalSignals.player_spawn_requested.emit(player)
		GlobalSignals.player_target_requested.connect(
			player_tracking_orb.set_target_node
		)
		GlobalSignals.player_target_released.connect(
			player_tracking_orb.release_target_node
		)
		player_tracking_orb.host = player
	

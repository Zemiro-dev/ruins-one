extends Node2D
class_name World

@export var player_scene : PackedScene

@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var main_camera: CoreCamera = $MainCamera
@onready var player_nest: Node = $PlayerNest
@onready var player_tracking_orb: TrackingOrb = $IndicatorNest/PlayerTrackingOrb
@onready var health_bar: TexturedResourceBar = $CanvasLayer/HealthBar
@onready var shield_bar: TexturedResourceBar = $CanvasLayer/ShieldBar
@onready var target_dummy_nav: CharacterBody2D = $EnemyNest/TargetDummyNav

func _ready() -> void:
	spawn_player()

# TODO Spawners should likely be it's own thing inside its own node
# TODO that way we can just run through and spawn stuff.
# TODO How does a spawn point know which signal to trigger?
func spawn_player() -> void:
	if player_scene:
		var player: Player = player_scene.instantiate()
		main_camera.assignToPlayer(player)
		player.global_transform = player_spawn.global_transform
		GlobalSignals.player_nest_requested.emit(player)
		GlobalSignals.player_target_requested.connect(
			player_tracking_orb.set_target_node
		)
		GlobalSignals.player_target_released.connect(
			player_tracking_orb.release_target_node
		)
		player_tracking_orb.host = player
		health_bar.initialize(player.on_health_changed, player.current_health, player.max_health)
		shield_bar.initialize(player.on_shield_changed, player.current_shield, player.max_shield)
		target_dummy_nav.target = player
	

extends Node2D
class_name SmallNavigationModule


@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@export var enabled: bool = false :
	set(value):
		if !enabled and value:
			_reset()
		enabled = value	

@export var delta_velocity: Vector2
var can_reach_final: bool = false
var next_position: Vector2
var safe_velocity: Vector2

func _ready() -> void:
	_reset()


func set_final_position(movement_target: Vector2):
	navigation_agent.set_target_position(movement_target)


func _physics_process(delta: float) -> void:
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer2D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		_reset()
	if navigation_agent.is_navigation_finished():
		_reset()
	_navigate(delta)


func _reset() -> void:
	can_reach_final = false
	next_position = global_position


func _navigate(delta: float) -> void:
	next_position = navigation_agent.get_next_path_position()

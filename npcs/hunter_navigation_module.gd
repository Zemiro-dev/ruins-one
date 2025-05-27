extends NavigationModule


@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@export var los_module: LineOfSightModule
@export var tracker_module: TrackerModule
@export var circle_radius: float = 200.0
var circle_rng: float = 1.0


func _ready() -> void:
	rng.randomize()
	circle_rng = rng.randf()


func final_goal() -> Vector2:
	var goal: Vector2 = entity.global_position
	if entity.target:
		goal = get_rng_circle(
			entity.target.global_position, circle_radius, circle_rng
		)
	elif entity is Enemy and entity.spawn_position:
		goal = entity.spawn_position
	return goal


func current_goal(final_goal: Vector2) -> Vector2:
	var navigation_goal: Vector2 = tracker_module.get_goal_position(final_goal, entity.global_position)
	if !los_module.in_los(final_goal):
		return navigation_goal
	return final_goal


func get_rng_circle(circle_center: Vector2, radius: float, rand: float) -> Vector2:
	var angle = rand * PI * 2;
	var x = circle_center.x + cos(angle) * radius
	var y = circle_center.y + sin(angle) * radius
	return Vector2(x, y)

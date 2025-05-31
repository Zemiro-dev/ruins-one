extends Entity
class_name Enemy


@export var acceleration_module: AccelerationModule
@export var target: Entity
@export var steer_force: float = 500.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var explode_audio: ExtendedAudioStreamPlayer2D = $Audio/ExplodeAudio
@onready var audio: Node2D = $Audio
@onready var small_navigation_module: SmallNavigationModule
@onready var line_of_sight_module: LineOfSightModule

var spawn_position: Vector2


func _ready() -> void:
	super()
	spawn_position = global_position
	small_navigation_module = get_node_or_null("BottomModules/SmallNavigationModule")
	line_of_sight_module = get_node_or_null('BottomModules/LineOfSightModule')
	if small_navigation_module:
		small_navigation_module.enabled = true


func _physics_process(delta: float) -> void:
	super(delta)
	can_drag = true
	var in_los: bool = line_of_sight_module.in_los(target.global_position) if target and line_of_sight_module else false
	if target and !in_los and small_navigation_module:
		small_navigation_module.set_final_position(target.global_position)
		var next_position: Vector2 = small_navigation_module.next_position
		var acceleration = acceleration_module.get_frame_acceleration(
			velocity,
			global_position,
			next_position,
			target.global_position
		)
		if !acceleration.is_zero_approx():
			velocity += acceleration * delta
			can_drag = false
	
	move_and_resolve(delta)


func seek(target_position: Vector2, target_speed: float) -> Vector2:
	var steer = Vector2.ZERO
	var desired = (target_position - global_position).normalized() * target_speed
	steer = (desired - velocity).normalized() * steer_force
	return steer


func die() -> void:
	super()
	current_knockback = Vector2.ZERO
	if animation_player.has_animation("die"):
		animation_player.play("die")


func play_explosion_audio() -> void:
	if is_ancestor_of(explode_audio):
		audio.remove_child(explode_audio)
		explode_audio.global_position = global_position
		GlobalSignals.audio_nest_requested.emit(explode_audio)

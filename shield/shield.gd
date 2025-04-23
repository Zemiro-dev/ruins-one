extends Node2D
class_name Shield


@onready var shell: Sprite2D = $Shell
@onready var pulse_particles: CPUParticles2D = $PulseParticles

@export var on_off_time: float = .2
var scale_tween: Tween
var modulate_tween: Tween
var active: bool = true


func on() -> void:
	if active: return
	active = true
	var tween_time = stop_on_off_tween()
	on_off_tween(tween_time, Vector2(1., 1.), Color(1., 1., 1., 1.))


func off() -> void:
	if !active: return 
	active =	 false
	var tween_time = stop_on_off_tween()
	on_off_tween(tween_time, Vector2(0., 0.), Color(1., 1., 1., 0.))

func on_off_tween(time: float, final_scale: Vector2, final_modulate: Color) -> void:
	scale_tween = create_tween()
	modulate_tween = create_tween()
	scale_tween.tween_property(shell, 'scale', final_scale, time)
	modulate_tween.tween_property(shell, 'modulate', final_modulate, time)

## Stops the on/off tween set and returns the run time of the next on/off cycle
## which will be the on_off_time is the tweens completed, or amount of
## time that did elapse otherwise 
func stop_on_off_tween() -> float:
	if scale_tween == null or modulate_tween == null:
		return on_off_time
	if scale_tween.is_running() or modulate_tween.is_running():
		var run_time: float = minf(
			scale_tween.get_total_elapsed_time(),
			modulate_tween.get_total_elapsed_time()
		)
		scale_tween.kill()
		modulate_tween.kill()
		return minf(run_time, on_off_time)
	return on_off_time


func pulse() -> void:
	if active: pulse_particles.emitting = true

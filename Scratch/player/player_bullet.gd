extends Node2D

var ejection_speed := 1000.0
var velocity := Vector2.ZERO


func _ready() -> void:
	$Area2D.body_entered.connect(_on_body_entered)
	$CPUParticles2D.finished.connect(clear)

func _physics_process(delta: float) -> void:
	position += velocity * delta

func shoot(initial_transform: Transform2D) -> void:
	global_transform = initial_transform
	velocity = transform.x.normalized() * ejection_speed


func clear() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	$Body.visible = false
	$CPUParticles2D.emitting = true

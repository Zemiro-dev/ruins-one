extends CharacterBody2D

var bullet := preload("res://Scratch/player/player_bullet.tscn")

func _physics_process(delta: float) -> void:
	velocity = get_control_vector() * 500.0
	if velocity.is_zero_approx():
		$Thrust.emitting = false
	else:
		$Thrust.emitting = true
	$Thrust.rotation = velocity.angle() + PI
	var aim = get_aim_vector()
	if !aim.is_zero_approx():
		var aim_angle = aim.angle()
		$Pivot.rotation = lerp_angle($Pivot.rotation, aim_angle, .1)
	
	if Input.is_action_just_pressed("fire"):
		var bullet_instance := bullet.instantiate()
		bullet_instance.shoot($Pivot/ProjMarker.global_transform)
		bullet_instance.z_index = -10
		get_tree().root.add_child(bullet_instance)
	move_and_slide()


func get_control_vector() -> Vector2:
	return Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)


func get_aim_vector() -> Vector2:
	return Vector2(
		Input.get_axis("aim_left", "aim_right"),
		Input.get_axis("aim_up", "aim_down")
	)

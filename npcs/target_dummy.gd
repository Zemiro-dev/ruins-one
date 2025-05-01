extends Entity

@onready var shield_refill: Timer = $ShieldRefill
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	super()
	shield_refill.timeout.connect(
		func():
			shield.on()
			current_shield = max_shield
	)
 
func _physics_process(delta: float) -> void:
	super(delta)
	#velocity += Vector2(0, 1000. * delta)
	if current_shield <= 0 and shield_refill.is_stopped():
		shield_refill.start()
	$Marker2D/Label.text = str(current_health)
	move_and_resolve(delta)


func die() -> void:
	super()
	animation_player.play("die")

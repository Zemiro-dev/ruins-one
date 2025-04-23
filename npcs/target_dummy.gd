extends Entity

@onready var shield_refill: Timer = $ShieldRefill

func _ready() -> void:
	super()
	on_damage_taken.connect(func(attacker: Node2D): shield.pulse())
	shield_refill.timeout.connect(
		func():
			shield.on()
			current_shield = max_shield
	)
 
func _physics_process(delta: float) -> void:
	super(delta)
	if current_shield <= 0 and shield_refill.is_stopped():
		shield_refill.start()
	$Marker2D/Label.text = str(current_health)
	move_and_resolve(delta)

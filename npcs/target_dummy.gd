extends Entity


@onready var shield_pulser: CPUParticles2D = $ShieldPulser


func _ready() -> void:
	super()
	on_damage_taken.connect(func(attacker: Node2D): shield_pulser.emitting = true)
 
func _physics_process(delta: float) -> void:
	super(delta)
	$Marker2D/Label.text = str(current_health)
	move_and_resolve(delta)

extends Node
class_name ShieldControlModule


@onready var state_machine: StateMachine = $StateMachine
@export var shield: Shield 
@export var entity: Entity
@export var reactivation_time: float = 10
@export var regeneration_time: float = 1
@export var stunned_time: float = 5
@export var reactivation_amount: int = 1
@export var regeneration_amount: int = 1
var is_stunned: bool = false

enum States { IDLE, DEAD, REGENERATING, REACTIVATING, STUNNED }


func activate(_shield: Shield, _entity: Entity):
	shield = _shield
	entity = _entity
	state_machine.add_state(States.IDLE, $StateMachine/Idle)
	state_machine.add_state(States.DEAD, $StateMachine/Dead)
	state_machine.add_state(States.REGENERATING, $StateMachine/Regenerating)
	state_machine.add_state(States.REACTIVATING, $StateMachine/Reactivating)
	state_machine.add_state(States.STUNNED, $StateMachine/Stunned)
	state_machine.initialize(self, States.IDLE)
	if entity.current_shield > 0:
		shield.on()
	entity.on_damage_taken.connect(
		func(attacker: Node2D):
			is_stunned = true
	)


## Resets is_stunned to false and returns its value before doing so.
func cycle_stun():
	var result: bool = is_stunned
	is_stunned = false
	return result

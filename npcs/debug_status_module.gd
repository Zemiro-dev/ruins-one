@tool
extends VBoxContainer


@onready var shield: Label = $Shield
@onready var health: Label = $Health
@export var entity: Entity :
	set(value):
		entity = value
		update_configuration_warnings()


func _ready() -> void:
	update_text()


func _process(delta: float) -> void:
	update_text()

func update_text() -> void:
	if Engine.is_editor_hint():
		return
	if entity:
		shield.text = str(entity.current_shield)
		health.text = str(entity.current_health)


func _get_configuration_warnings():
	var warnings: PackedStringArray = PackedStringArray()
	if !entity:
		warnings.append('Entity to monitor for status not set.')
	return warnings

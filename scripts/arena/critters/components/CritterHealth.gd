class_name CritterHealth extends CritterComponent

static var component_name: String

signal health_changed(_previous_value, _current_value)

var _critter_health: int:
	get:
		return _critter_health
	set(value):
		if value < 0:
			value = 0
		health_changed.emit(_critter_health, value)
		_critter_health = value
		if _critter_health == 0:
			die()

func _ready():
	component_name = "CritterHealth"

func take_damage(damage):
	_critter_health -= damage
	pass

func die():
	critter.queue_free()
	pass

static func get_custom_class_name() -> String:
	return component_name

class_name ClickerManager extends Node

signal resource_changed(resource_name, current_value)
signal resource_strength_changed(resource_name, current_value)

static var instance: ClickerManager

enum RESOURCE {
	TCOIN,
	TAP
}

var taps = 0 :
	get:
		return taps
	set(value):
		taps = value
		#taps_changed.emit(value)
var strength = 1
var tapssecond = 0
var auto = 0
var resource_dict: Dictionary = {}
var current_resource_key: int

func _ready():
	instance = self
	for resource_button: ResourceButton in get_tree().get_nodes_in_group("resource_buttons"):
		if !resource_dict.has(resource_button.resource_name):
			resource_dict[resource_button.resource_name] = {"amount": 0, "strength": { "full":1 } }
		resource_button.gain_resource.connect(_on_resource_gained)

func get_resource_value(resource_name):
	return resource_dict.get(resource_name).amount

func update_resource_value(resource_name, value):
	resource_dict.get(resource_name).amount += value
	resource_changed.emit(resource_name, resource_dict.get(resource_name).amount)

func update_resource_strength(resource_name, source, value):
	resource_dict.get(resource_name).strength[str(source)] = value
	for strength_key in resource_dict.get(resource_name).strength:
		if strength_key == "full":
			resource_dict.get(resource_name).strength.full = 1
			continue
		resource_dict.get(resource_name).strength.full += resource_dict.get(resource_name).strength.get(strength_key)
		
	resource_strength_changed.emit(resource_name, resource_dict.get(resource_name).strength.full)

func _on_resource_gained(resource_name):
	current_resource_key = resource_name
	update_resource_value(resource_name, resource_dict.get(resource_name).strength.full)

func _exit_tree():
	instance = null

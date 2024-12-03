class_name Action

extends Resource

enum TARGET {
	SELF = 1,
	ALLY = 2,
	ENEMY = 4,
	OBJECT = 8
}

signal action_selected(_action)
signal action_canceled()
signal action_activated()

@export var action_name: String = "default"
@export var _effects: Array[ActionEffect]
@export var _conditions: Array[Condition]

@export var action_button_scene: PackedScene

@export var _area: int
@export var _range: int
@export var _actionHintText: String
@export var _animation: Critter.State
@export var _action_cost: int = 1
@export var max_targets: int = 1

@export var require_visual: bool = true
@export var end_turn: bool = true

var component_list: Dictionary

func _init():
	for effect in _effects:
		component_list[effect.effect_name] = effect
		
	for condition in _conditions:
		component_list[condition.condition_name] = condition

func get_component_list():
	return component_list

func get_component_list_size():
	return component_list.size() + 1;

func can_apply_to_component(component_key, target):
	if component_key != action_name:
		return component_list.get(component_key).validate_effect(target)
	else:
		for component in component_list:
			if component == action_name or component_list.get(component).has_own_targets:
				continue
			if !component_list.get(component).validate_effect(target):
				return false
	return true

func get_component_targets(component_key):
	if component_key != action_name:
		return component_list.get(component_key).max_targets
	
	return max_targets
		

func activate_action(target_list, owner):
	
	action_activated.emit()
	
	for effect in _effects:
		if effect.has_own_targets:
			pass
		else:
			for target in target_list.get(action_name):
				effect.apply_effect(target, owner)
	for condition in _conditions:
		if condition.has_own_targets:
			pass
		else:
			for target in target_list.get(action_name):
				condition.apply_condition(target, owner)
	
	if end_turn:
		pass

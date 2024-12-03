class_name ActionEffect extends Resource

signal wrong_target(message: String)
signal effect_error()

@export var effect_name: StringName = "default"
@export var is_targeting: Action.TARGET = Action.TARGET.SELF
@export var has_own_range: bool = false
@export var has_own_area: bool = false
@export var has_own_targets: bool = false

var range: int = 1
var area: int = 0
var max_targets: int = 1

func validate_effect(possible_target):
	pass

func apply_effect(action_target, action_owner):
	pass


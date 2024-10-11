class_name Condition extends Resource

@export var condition_name: StringName = "default"
@export var duration: int = -1 ##Длительность состояния. -1 означает мгновенное действие.
@export var has_own_targets: bool = false

func apply_condition(condition_target, owner):
	pass

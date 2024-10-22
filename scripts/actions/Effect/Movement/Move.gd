class_name Move extends ActionEffect

@export var move_distance: int = 0: ##Дистанция движения в клетках
	get:
		return move_distance
	set(value):
		move_distance = abs(value)
@export var move_type: MovementType: ##Тип перемещения, совершаемый воздействием
	get:
		return move_type
	set(value):
		move_type = value
		notify_property_list_changed() 

func validate_effect(possible_target):
	print(possible_target)
	if move_type.validate_movement(possible_target):
		return true
	else:
		wrong_target.emit("Can't move to this cell")
		return false

func apply_effect(action_target, action_owner):
	move_type.move(action_target, move_distance, action_owner, is_targeting)

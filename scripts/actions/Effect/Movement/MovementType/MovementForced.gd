class_name MovementForced extends MovementType

enum MOVE_DIRECTION {
	UP = 1, ##Вверх
	LEFT = 2,
	RIGHT = 4,	
	DOWN = 8,
	TO_ACTOR = 16,
	FROM_ACTOR = 32,
	ANY = UP & LEFT & RIGHT & DOWN
}

@export var move_direction: MOVE_DIRECTION = MOVE_DIRECTION.FROM_ACTOR ##Направление движения
@export var _push_speed: float

func validate_movement(possible_target):
	print(possible_target)
	if possible_target is Vector2i or !possible_target.has_critter_component(CritterMovement.get_custom_class_name()):
		return false
	return true

func move(target, _distance, owner: Critter, is_targeting):
	if is_targeting == Action.TARGET.SELF:
		pass
	else:
		var push_target = target
		var push_origin = owner._current_tile
		push_target.get_critter_component(CritterMovement.get_custom_class_name()).force_move_critter(push_origin, move_direction, _distance, _push_speed)
	pass


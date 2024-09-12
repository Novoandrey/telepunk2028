class_name MovementWilling extends MovementType

func validate_movement(possible_target):
	if !TileMapManager.instance.has_nav_point(possible_target):
		return false
	return true

func move(target, distance, owner: Critter, is_targeting):
	print(target)
	if is_targeting == Action.TARGET.SELF:
		if owner.has_critter_component(CritterMovement.get_custom_class_name()):
			owner.get_critter_component(CritterMovement.get_custom_class_name()).move_critter(target)
	elif is_targeting == Action.TARGET.OBJECT:
		pass

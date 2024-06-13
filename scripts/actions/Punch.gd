extends Action

func activate(target: Vector2i, user = null):
	var target_critter = _owner.gameManager.get_critter_at_cell(target)
	if target_critter != null:
		_owner.animation_tree["parameters/conditions/isPunching"] = true
		_owner._currentActionPoints -= _cost
		target_critter._currentHealth -= _damage
		self.queue_free()
	pass

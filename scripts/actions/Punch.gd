extends Action

func activate(_target: Vector2i, _user = null):
	var target_critter = _owner.gameManager.get_critter_at_cell(_target)
	if target_critter != null:
		super(_target, _user)
		_owner.animation_tree["parameters/conditions/isPunching"] = true
		_owner._currentActionPoints -= _cost
		target_critter._currentHealth -= _damage
		self.queue_free()
	pass

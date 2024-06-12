extends Action

func activate(target: Critter):
	_player.animation_tree["parameters/conditions/isPunching"] = true
	_player._currentActionPoints -= _cost
	target._currentHealth -= _damage
	self.queue_free()
	pass

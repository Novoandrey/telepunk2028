extends Action


func activate(target: Vector2i, user:Critter = null):
	var tilemap: TileMap = _owner.tilemap
	_owner.animation_tree["parameters/conditions/isPunching"] = true
	_owner._currentActionPoints -= _cost
	if _owner.gameManager.get_critter_at_cell(target) != null:
		_owner.gameManager.get_critter_at_cell(target)._currentHealth -= _damage
	var tiles_damaged : Array[Vector2i]
	var current_tiles_to_damage : Array[Vector2i] = [target]
	var current_tiles_to_damage_continue : Array[Vector2i]
	for i in range(_area):
		for tile in current_tiles_to_damage:
			for cell in tilemap.get_surrounding_cells(tile):
				if tiles_damaged.has(cell):
					continue
				if _owner.gameManager.get_critter_at_cell(cell) != null:
					_owner.gameManager.get_critter_at_cell(cell)._currentHealth -= _damage
				tiles_damaged.append(cell)
				current_tiles_to_damage_continue.append(cell)
		current_tiles_to_damage = current_tiles_to_damage_continue
		current_tiles_to_damage_continue = []
	self.queue_free()

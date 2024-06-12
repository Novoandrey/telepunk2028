extends Tile

func deal_damage(body: Node2D):
	body._currentHealth -= 5

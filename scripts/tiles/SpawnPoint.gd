class_name SpawnPoint extends Node2D

@export var critter: PackedScene
@export var critter_type: Critter.CRITTER_TYPE = Critter.CRITTER_TYPE.PLAYER
func _ready():
	add_to_group("spawners")
	hide()

func spawn_critter(player_info: Dictionary = {}):
	var object: Critter = critter.instantiate()
	object.global_position = global_position
	if player_info != {}:
		print(player_info.id)
		print(player_info.name)
		object.critter_side = player_info.side
		object.owner_id = player_info.id
	else:
		object.critter_side = GameManager.SIDE.ENEMY
		object.owner_id = -1
	get_node("../../../").add_child(object, true)
	object.update_shader()
	queue_free()
	pass

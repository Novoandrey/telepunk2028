extends Node2D

@export var critter: PackedScene
@export var point_owner_id: int

func _ready():
	hide()
	spawn_critter()
	MultiplayerManager.players_loaded

func spawn_critter():
	var object = critter.instantiate()
	object.owner
	object.tilemap = get_parent()
	object.global_position = global_position
	get_node("../../../").add_child(object, true)
	self.queue_free()
	pass

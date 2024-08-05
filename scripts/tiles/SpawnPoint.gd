extends Node2D

@export var critter: PackedScene
@export var point_owner_id: int

func _ready():
	var object = critter.instantiate()
	object.tilemap = get_parent()
	object.global_position = global_position
	get_node("../../../").add_child(object)
	self.queue_free()

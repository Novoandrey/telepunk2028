extends Node2D

@export var critter: PackedScene

func _ready():
	var object = critter.instantiate()
	object.global_position = global_position
	get_node("/root/ArenaScene").add_child(object)
	self.queue_free()

class_name SceneManager

extends Node

@export var first_scene: PackedScene
@onready var root = get_node("/root")
@export var level_list: Array[PackedScene]

func _ready():
	root.add_child.call_deferred(first_scene.instantiate())

func switch_scenes(_scene_to_load, _scene_to_destroy):
	root.add_child(_scene_to_load.instantiate())
	_scene_to_destroy.queue_free()
	pass
	

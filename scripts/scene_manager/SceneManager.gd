class_name SceneManager

extends Node

@export var first_scene: PackedScene
@onready var root = get_node("/root")
@export var level_list: Array[PackedScene]

var scene_stack: Array[Node]

func _ready():
	if first_scene == null:
		return
	var main_menu = first_scene.instantiate()
	root.add_child.call_deferred(main_menu)
	scene_stack.append(main_menu)

func switch_scenes(_scene_to_load, _scene_to_destroy):
	var _current_scene
	if !_scene_to_load.is_class("Node"):
		_current_scene = _scene_to_load.instantiate()
	else:
		_current_scene = _scene_to_load
	root.add_child(_current_scene)
	if !scene_stack.has(_current_scene):
		scene_stack.append(_current_scene)
	if scene_stack.has(_scene_to_destroy) and scene_stack.find(_scene_to_destroy) != -1:
		if scene_stack.find(_scene_to_destroy) > scene_stack.find(_current_scene):
			scene_stack.erase(_scene_to_destroy)
			_scene_to_destroy.queue_free()
			print("returned")
			return
	root.remove_child(_scene_to_destroy)
	

func add_scene(_scene_to_load):
	root.add_child(_scene_to_load.instantiate())
	scene_stack.append(_scene_to_load)

func return_to_scene():
	switch_scenes(scene_stack[-2], scene_stack[-1])

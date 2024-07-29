class_name SceneManager

extends Node
@onready var root = get_node("/root")

@export var first_scene: PackedScene
@export var keep_first: bool = true
@export var level_list: Array[PackedScene]

var scene_stack: Array[Node]

func _ready():
	if first_scene == null:
		return
	var main_menu = first_scene.instantiate()
	root.add_child.call_deferred(main_menu)
	if keep_first:
		scene_stack.append(main_menu)

func switch_scenes(_scene_to_load, _scene_to_destroy, keep_scene: bool = true, clear_previous: bool = false):
	var _current_scene
	print(_scene_to_destroy)
	if _scene_to_load.is_class("PackedScene"):
		_current_scene = _scene_to_load.instantiate()
	else:
		_current_scene = _scene_to_load
	root.remove_child(_scene_to_destroy)
	root.add_child(_current_scene)
	if !scene_stack.has(_current_scene) and keep_scene:
		print("what3")
		scene_stack.append(_current_scene)
	if scene_stack.has(_scene_to_destroy) and scene_stack.find(_scene_to_destroy) != -1:
		if scene_stack.find(_scene_to_destroy) > scene_stack.find(_current_scene):
			print("what2")
			scene_stack.erase(_scene_to_destroy)
			_scene_to_destroy.queue_free()
			print("returned")
			return
	if clear_previous:
		scene_stack[-2].queue_free()
		scene_stack.erase(scene_stack[-2])
	

func add_scene(_scene_to_load):
	root.add_child(_scene_to_load.instantiate())
	scene_stack.append(_scene_to_load)

func return_to_scene():
	switch_scenes(scene_stack[-2], scene_stack[-1])

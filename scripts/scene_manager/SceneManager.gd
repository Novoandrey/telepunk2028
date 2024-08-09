extends Node

@onready var root = get_tree().root

var main_menu_scene: PackedScene = preload("res://scenes/game.tscn")
var scene_stack: Array[Node]
var _current_scene

func switch_scenes(_scene_to_load, _scene_to_destroy: Node, keep_scene: bool = true, parent_scene: Node = root):
	if parent_scene == null:
		parent_scene = root
	if _scene_to_load is PackedScene:
		_current_scene = _scene_to_load.instantiate()
	else:
		_current_scene = _scene_to_load
	if _scene_to_destroy != null:
		_scene_to_destroy.get_parent().remove_child(_scene_to_destroy)
	parent_scene.add_child(_current_scene)
	if !scene_stack.has(_current_scene) and keep_scene:
		scene_stack.append(_current_scene)
	if scene_stack.has(_scene_to_destroy):
		if scene_stack.find(_scene_to_destroy) > scene_stack.find(_current_scene):
			scene_stack.erase(_scene_to_destroy)
			_scene_to_destroy.queue_free()
			print("returned")
			return

func add_scene(_scene_to_load, parent_scene = root):
	root.add_child(_scene_to_load.instantiate())
	scene_stack.append(_scene_to_load)

func add_scene_to_parent(_scene_to_load, _scene_parent):
	_scene_parent.add_child(_scene_to_load.instantiate())
	scene_stack.append(_scene_to_load)
	pass

func return_to_scene():
	switch_scenes(scene_stack[-2], scene_stack[-1])

func return_to_main_menu():
	root.get_child(2).queue_free()
	scene_stack.clear()
	var main_menu = main_menu_scene.instantiate()
	root.add_child(main_menu)
	scene_stack.append(main_menu)
	pass

class_name SceneManager

extends Node
@onready var root = get_node("/root")

@export var first_scene: PackedScene
@export var main_menu_scene: PackedScene
@export var keep_first: bool = true

var scene_stack: Array[Node]
var _current_scene

func _ready():
	if first_scene == null:
		return
	var main_menu = first_scene.instantiate()
	root.add_child.call_deferred(main_menu)
	if first_scene == main_menu_scene:
		scene_stack.append(main_menu)

func switch_scenes(_scene_to_load, _scene_to_destroy, keep_scene: bool = true, scene_root: Node = root):
	if scene_root == null:
		scene_root = root
	if _scene_to_load is PackedScene:
		_current_scene = _scene_to_load.instantiate()
	else:
		_current_scene = _scene_to_load
	if _scene_to_destroy != null:
		_scene_to_destroy.get_parent().remove_child(_scene_to_destroy)
	scene_root.add_child(_current_scene)
	if !scene_stack.has(_current_scene) and keep_scene:
		scene_stack.append(_current_scene)
	if scene_stack.has(_scene_to_destroy):
		if scene_stack.find(_scene_to_destroy) > scene_stack.find(_current_scene):
			print("what2")
			scene_stack.erase(_scene_to_destroy)
			_scene_to_destroy.queue_free()
			print("returned")
			return

func switch_chapter():
	pass

func add_scene(_scene_to_load, scene_root: Node = root):
	scene_root.add_child(_scene_to_load.instantiate())
	scene_stack.append(_scene_to_load)

func add_scene_to_parent(_scene_to_load, _scene_parent):
	_scene_parent.add_child(_scene_to_load.instantiate())
	scene_stack.append(_scene_to_load)
	pass

func return_to_scene():
	if scene_stack.size() <= 1:
		print("Only 1 scene in a scene stack. Unable to return.")
		return
	
	switch_scenes(scene_stack[-2], scene_stack[-1])

func return_to_main_menu():
	root.get_child(1).queue_free()
	scene_stack.clear()
	var main_menu = main_menu_scene.instantiate()
	root.add_child(main_menu)
	scene_stack.append(main_menu)
	pass

class_name LoadButton

extends Button

@onready var scene_manager: SceneManager = get_node("/root/SceneManager")
@onready var parent_scene: Node = get_node("/root").get_child(1)

@export var scene_to_load: PackedScene
@export var keep_loaded_scene: bool = true
@export var clear_previous_scene: bool = false

func _on_pressed():
	scene_manager.switch_scenes(scene_to_load, parent_scene, keep_loaded_scene, clear_previous_scene)

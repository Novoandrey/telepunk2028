class_name LoadButton

extends Button

@onready var scene_manager: SceneManager = get_node("/root/SceneManager")
@onready var parent_scene: Node = get_node("/root/Game")

@export var scene_to_load: PackedScene

func _on_pressed():
	scene_manager.switch_scenes(scene_to_load, parent_scene)

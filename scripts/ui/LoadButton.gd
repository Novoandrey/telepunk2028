class_name LoadButton

extends Button

@onready var scene_manager: SceneManager = get_node("/root/SceneManager")

@export var scene_to_load: PackedScene ##Сцена для загрузки
@export var keep_current_scene: bool = false ##Сохранить текущую сцену в стэке сцен для возможного возвращения
@export var scene_to_unload: Node

func _on_pressed():
	scene_manager.switch_scenes(scene_to_load, scene_to_unload, keep_current_scene)

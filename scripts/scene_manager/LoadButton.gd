class_name LoadButton

extends Button

@export var scene_to_load: PackedScene : ##Сцена для загрузки
	get:
		return scene_to_load
	set(value):
		scene_to_load = value
@export var keep_current_scene: bool = false ##Сохранить текущую сцену в стэке сцен для возможного возвращения
@export var scene_to_unload: Node ##Сцена для выгрузки
@export var scene_root: Node ##Родитель новой сцены, является root поумолчанию

func _on_pressed():
	SceneManager.switch_scenes(scene_to_load, scene_to_unload, keep_current_scene, scene_root)

func set_scene_to_load(new_scene: PackedScene):
	scene_to_load = new_scene

class_name LoadButton

extends Button

@export var scene_path: String
@export var scene_to_load: PackedScene : ##Сцена для загрузки
	get:
		return scene_to_load
	set(value):
		scene_to_load = value
@export var keep_current_scene: bool = false ##Сохранить текущую сцену в стэке сцен для возможного возвращения
@export var scene_to_unload: Node ##Сцена для выгрузки
@export var scene_root: Node ##Родитель новой сцены, является root поумолчанию

func _ready():
	if scene_root == null:
		scene_root = get_tree().root

func _on_pressed():
	SceneManager.switch_scenes(scene_to_load.resource_path, scene_to_unload.get_path(), keep_current_scene, scene_root.get_path())
	

func _on_pressed_network():
	SceneManager.switch_scenes.rpc(scene_to_load.resource_path, scene_to_unload.get_path(), keep_current_scene, scene_root.get_path())

func set_scene_to_load(new_scene: PackedScene):
	scene_to_load = new_scene	

class_name LoadLevel

extends Button


var level_to_load: PackedScene
@onready var scene_manager: SceneManager = get_node("/root/SceneManager")

func on_click():
	scene_manager.switch_scenes(level_to_load, get_node("/root/Game"))

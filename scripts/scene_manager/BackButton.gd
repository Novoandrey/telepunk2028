extends Button

@onready var scene_manager: SceneManager = get_node("/root/SceneManager")
#@onready var level_manager: LevelManager = get_node("/root/Chapter")

func _return_to_main_menu():
	scene_manager.return_to_main_menu()
	pass

#func _return_to_level_selection():
#	level_manager.return_to_level_selection()

func _return_to_previous_level():
	scene_manager.return_to_scene()
	pass


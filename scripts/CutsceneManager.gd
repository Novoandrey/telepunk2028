extends Node2D

@onready var scene_manager: SceneManager = get_node("/root/SceneManager")

@export var scenes_to_play: Array[PackedScene]
@export var next_game_scene: PackedScene #Сцена для загрузки после завершения последовательности сцен

var current_scene_index = 0
var current_scene

func _ready():
	current_scene = scenes_to_play[current_scene_index].instantiate()
	add_child(current_scene)
	current_scene.timer.timeout.connect(switch_scene)
	

func switch_scene():
	current_scene_index+=1
	if current_scene_index == scenes_to_play.size():
		current_scene.timer.timeout.disconnect(switch_scene)
		if next_game_scene != null:
			remove_child(current_scene)
			scene_manager.switch_scenes(next_game_scene, self, true, true)
		return
	current_scene.timer.timeout.disconnect(switch_scene)
	remove_child(current_scene)
	current_scene = scenes_to_play[current_scene_index].instantiate()
	add_child(current_scene)
	current_scene.timer.timeout.connect(switch_scene)

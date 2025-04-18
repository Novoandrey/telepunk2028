class_name LevelManager

extends Node2D

@export var stage_name: String = "default"
@export var level_sequence: Array[PackedScene]
@export var next_stage: PackedScene #Сцена для загрузки после завершения главы

@onready var scene_manager: SceneManager = get_node("/root/SceneManager")

signal on_chapter_completed()

var chapter_completed: bool = false :
	get:
		return chapter_completed
	set(value):
		chapter_completed = value
		if chapter_completed:
			on_chapter_completed.emit()
			scene_manager.switch_levels(next_stage,self,true,true)

var level_buttons: Array[LevelButton]

var level_selection
var current_scene
var current_scene_packed

func _ready():
	if level_sequence.size() > 0:
		current_scene_packed = level_sequence[0]
		current_scene = current_scene_packed.instantiate()
		level_selection = current_scene
		add_child(current_scene)
	elif next_stage != null:
		scene_manager.switch_scenes(next_stage, self, true, true)

# Смена уровня внутри главы/stage
func switch_level(level_to_load = null, finish_stage = false):
	if finish_stage:
		if next_stage != null:
			remove_child(current_scene)
			scene_manager.switch_scenes(next_stage, self, true, true)
		return
	#Смена уровней. Уровень должен быть в списке уровней главы/stage LevelManager'a
	if level_sequence.has(level_to_load): #Смена текущего уровня на указанный уровень
		remove_child(current_scene)
		current_scene_packed = level_to_load
		current_scene = current_scene_packed.instantiate()
	elif level_to_load == null: #Смена уровня на следующий за текущим уровнем в списке
		if level_sequence.find(current_scene_packed)+1 < level_sequence.size():
			remove_child(current_scene)
			current_scene_packed = level_sequence[level_sequence.find(current_scene_packed) + 1]
			current_scene = current_scene_packed.instantiate()
		else:
			print("Last level in level list, cant autoload next one")
			return
	else: #Уровень не был найден в списке
		print("Level was not found in level list")
		return
	add_child(current_scene) #Добавление уровня на сцену

func return_to_level_selection():
	remove_child(current_scene)
	current_scene = level_selection
	add_child(level_selection)

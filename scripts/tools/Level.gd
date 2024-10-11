class_name Level

extends Node

signal on_objective_completed(auto_end)

@export var level_name: String = "default"
@export var auto_end_on_objective_completion: bool = false

#@onready var level_holder: LevelManager = get_parent()

var objective_completed: bool = false :
	get:
		return objective_completed
	set(value):
		objective_completed = value
		if objective_completed:
			on_objective_completed.emit(auto_end_on_objective_completion)
			#Цель уровня завершена
			pass


func return_to_main_menu():
	SceneManager.return_to_main_menu()

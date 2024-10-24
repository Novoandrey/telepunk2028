class_name Level
extends Node

# Сигнал, который срабатывает при завершении цели уровня.
# Параметр auto_end указывает, нужно ли автоматически завершить уровень.
signal on_objective_completed(auto_end)

# Параметры уровня
@export var level_name: String = "default"  # Имя уровня по умолчанию
@export var auto_end_on_objective_completion: bool = false  # Автоматически завершать уровень при выполнении цели

#@onready var level_holder: LevelManager = get_parent()

# Флаг, указывающий, завершена ли цель уровня
var objective_completed: bool = false :
	get:
		return objective_completed  # Возвращаем текущее состояние
	set(value):
		objective_completed = value  # Устанавливаем новое значение
		if objective_completed:
			# Если цель завершена, отправляем сигнал с параметром auto_end_on_objective_completion
			on_objective_completed.emit(auto_end_on_objective_completion)
			# Здесь можно добавить дополнительную логику при завершении цели
			pass

func _ready():
	SceneManager._current_scene = self

func return_to_main_menu():
	SceneManager.return_to_main_menu()
	#LoggerG.rich_text_label.text = ""
	LoggerG.add_log("Переход в главное меню.")

class_name CritterComponent extends Node2D

@onready var critter: Critter = get_parent()

func refresh(): ##Обновление компонента
	pass

static func get_custom_class_name() -> String: 
	return ""

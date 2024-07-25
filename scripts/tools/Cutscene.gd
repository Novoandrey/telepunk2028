class_name Cutscene

extends Node

@export var scene_time: float #Время длительности сцены
@export var is_timed: bool = true #Переключается ли сцена автоматически при окончании таймера

@onready var timer: Timer = $Timer

func _ready():
	if is_timed:
		timer.start(scene_time)

extends Timer

@export var level_to_autoload: PackedScene ## Следующий уровень для загрузки, после истечения таймера.
@export var keep_current_level: bool = false ## Сохранить текущий уровень в стэке сцен SceneManager'a для возвращения
@export var level_to_unload: Node
@export var scene_root: Node ##Родитель новой сцены, является root поумолчанию

@onready var scene_manager: SceneManager = get_tree().root.get_child(0)

func _ready():
	timeout.connect(auto_load_level)
	pass	
	
func _exit_tree():
	timeout.disconnect(auto_load_level)
	pass

func auto_load_level():
	if level_to_autoload != null:
		scene_manager.switch_scenes(level_to_autoload, level_to_unload, keep_current_level, scene_root)
	pass

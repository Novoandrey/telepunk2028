extends Node

# Ссылка на корневую сцену
@onready var root = get_tree().root

# Главная сцена меню
var main_menu_scene: PackedScene = preload("res://scenes/main_menu.tscn")
# Стек сцен для отслеживания текущих и предыдущих сцен
var scene_stack: Array[Node] = []
# Текущая активная сцена
var _current_scene: Node

func return_to_main_menu():
	# Проверяем, есть ли текущая сцена, и если да, удаляем её
	if _current_scene != null:
		_current_scene.queue_free()  # Удаляем текущую сцену

	# Загружаем сцену главного меню
	var main_menu_instance = main_menu_scene.instantiate()
	root.add_child(main_menu_instance)
	_current_scene = main_menu_instance  # Обновляем текущую сцену

# RPC функция для переключения между сценами
@rpc("call_local", "reliable")
func switch_scenes(_scene_to_load_path: String, _scene_to_destroy_path: String, keep_scene: bool = true, _parent_scene_path: String = "/root"):
	log_scene_change(_scene_to_destroy_path, _scene_to_load_path)

	var has_scene: bool = false
	for _scene in scene_stack:
		if str(_scene.get_path()) == _scene_to_load_path:
			has_scene = true
			_current_scene = _scene
			break
	# Если сцена не найдена в стеке, загружаем новую
	if !has_scene:
		var _scene_to_load: PackedScene = load(_scene_to_load_path)
		_current_scene = _scene_to_load.instantiate()
	# Находим и удаляем сцену, которую нужно уничтожить
	var _scene_to_destroy: Node = root.get_node(_scene_to_destroy_path)
	var _parent_scene: Node = root.get_node(_parent_scene_path)
	
	if _parent_scene == null:
		_parent_scene = root
	
	if _scene_to_destroy != null:
		_scene_to_destroy.get_parent().remove_child(_scene_to_destroy)
	# Добавляем новую сцену в иерархию
	_parent_scene.add_child(_current_scene)
	# Добавляем сцену в стек, если необходимо её сохранить
	if !scene_stack.has(_current_scene) and keep_scene:
		scene_stack.append(_current_scene)
	# Удаляем сцену из стека, если она больше не нужна
	if scene_stack.has(_scene_to_destroy):
		if scene_stack.find(_scene_to_destroy) > scene_stack.find(_current_scene):
			scene_stack.erase(_scene_to_destroy)
			_scene_to_destroy.queue_free()
			print("returned")
			return

# Функция добавления новой сцены
func add_scene(_scene_to_load, _parent_scene = root):
	# Добавляем новую сцену в корневой узел
	root.add_child(_scene_to_load.instantiate())
	# Добавляем сцену в стек
	scene_stack.append(_scene_to_load)

# Функция добавления сцены в конкретный родительский узел
func add_scene_to_parent(_scene_to_load, _scene_parent):
	# Добавляем новую сцену в указанный родительский узел
	_scene_parent.add_child(_scene_to_load.instantiate())
	# Добавляем сцену в стек
	scene_stack.append(_scene_to_load)

# Функция возврата к предыдущей сцене
func return_to_scene():
	if scene_stack.size() > 0:
		var current_scene = scene_stack.pop_back()
		if current_scene:
			current_scene.queue_free()
		if scene_stack.size() > 0:
			var previous_scene = scene_stack.back()
			get_tree().root.add_child(previous_scene)
	else:
		print("Нет доступных сцен для возврата.")

func log_scene_change(old_scene: String, new_scene: String):
	var log_message = "Смена сцены: " + old_scene + " -> " + new_scene
	LoggerG.add_log(log_message)

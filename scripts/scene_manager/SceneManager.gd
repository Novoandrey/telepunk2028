extends Node

# Хранение ссылки на корневую сцену дерева
@onready var root = get_tree().root

# Предзагрузка главного меню для быстрого переключения
var main_menu_scene: PackedScene = preload("res://scenes/main_menu.tscn")
var scene_stack: Array[Node] = []  # Стек для хранения сцен
var _current_scene: Node  # Текущая активная сцена

# Функция для переключения сцен с возможностью сохранить текущую сцену
@rpc("call_local", "reliable")
func switch_scenes(_scene_to_load_path: String, _scene_to_destroy_path: String, keep_scene: bool = true, _parent_scene_path: String = "/root"):
	var has_scene: bool = false
	
	# Проверяем, загружена ли уже сцена, которую нужно загрузить
	for _scene in scene_stack:
		if str(_scene.get_path()) == _scene_to_load_path:
			has_scene = true
			_current_scene = _scene
			break
	
	# Если сцена еще не загружена, загружаем её
	if not has_scene:
		var _scene_to_load: PackedScene = load(_scene_to_load_path)
		_current_scene = _scene_to_load.instantiate()

	# Удаление текущей сцены
	var _scene_to_destroy: Node = root.get_node(_scene_to_destroy_path)
	var _parent_scene: Node = root.get_node(_parent_scene_path)
	if _parent_scene == null:
		_parent_scene = root  # Если родитель не указан, используем корневой узел
	
	if _scene_to_destroy != null:
		_scene_to_destroy.get_parent().remove_child(_scene_to_destroy)
	
	# Добавляем новую сцену в дерево
	_parent_scene.add_child(_current_scene)
	
	# Сохраняем сцену в стеке, если нужно сохранить
	if not scene_stack.has(_current_scene) and keep_scene:
		scene_stack.append(_current_scene)
	
	# Удаляем старую сцену из стека, если она больше не используется
	if scene_stack.has(_scene_to_destroy):
		if scene_stack.find(_scene_to_destroy) > scene_stack.find(_current_scene):
			scene_stack.erase(_scene_to_destroy)
			_scene_to_destroy.queue_free()  # Очищаем сцену
			print("returned")
			return

# Добавление новой сцены в корневой узел (root)
func add_scene(_scene_to_load, _parent_scene = root):
	_parent_scene.add_child(_scene_to_load.instantiate())
	scene_stack.append(_scene_to_load)

# Добавление новой сцены в указанный родительский узел
func add_scene_to_parent(_scene_to_load, _scene_parent):
	_scene_parent.add_child(_scene_to_load.instantiate())
	scene_stack.append(_scene_to_load)

# Возврат к предыдущей сцене
func return_to_scene():
	switch_scenes(str(scene_stack[-2].get_path()), str(scene_stack[-1].get_path()))

# Возврат в главное меню
func return_to_main_menu():
	root.get_child(2).queue_free()  # Удаляем текущую сцену (предположим, она 3-я по порядку)
	scene_stack.clear()  # Очищаем стек сцен
	var main_menu = main_menu_scene.instantiate()
	root.add_child(main_menu)  # Добавляем главное меню в root
	scene_stack.append(main_menu)

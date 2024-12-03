@tool class_name UpgradeTreeManager extends Node2D

# Массив для хранения узлов дерева и их данных
var tree_nodes: Dictionary = {}
var synaps_template: PackedScene = preload("res://scenes/game_chapters/prequel_clicker/clicker_nodes/story_node_template.tscn")

# Функция, вызываемая при готовности узла
func _ready():
	# Рекурсивное получение всех дочерних узлов, являющихся частью дерева
	get_children_rec(self, tree_nodes)
	
	var level_data = CSVParser.read_csv("res://assets/clicker_level_data/defs_export.csv")
	for node in level_data["def"]:
		if !tree_nodes.has(node):
			var new_synaps = synaps_template.instantiate()
			new_synaps.initialize_node(level_data.get(node))
			add_child(new_synaps)
	
	for node in tree_nodes:
		if !level_data.get("def").has(node):
			tree_nodes.get(node).queue_free()
	# Вывод полученных узлов в лог для проверки

# Рекурсивная функция для получения всех дочерних узлов
func get_children_rec(node, arr):
	# Получаем количество дочерних узлов
	var num_children = node.get_child_count()
	if num_children > 0:
		# Проходим по всем дочерним узлам
		for i in num_children:
			var child = node.get_child(i)
			# Если узел является экземпляром SkillNode
			if child is SynapsNode:
				# Подключаемся к сигналу изменения уровня узла
				child.node_level_changed.connect(on_node_level_changed)
				# Если узел также является генератором (GeneratorNode)
				if child is GeneratorNode:
					# Подключаемся к сигналу генерации ресурса
					child.resource_generated.connect(on_resource_generated)
				# Добавляем узел и его данные в массив
				arr[child.name] = child
			# Рекурсивно вызываем функцию для всех дочерних узлов
			get_children_rec(child, arr)
	else:
		# Если нет дочерних узлов, выходим
		return

# Обработчик события изменения уровня узла
func on_node_level_changed(_node):
	pass

# Обработчик события генерации ресурса
func on_resource_generated(resource_name, amount):
	# Обновляем количество ресурса в менеджере кликера
	ClickerManager.instance.update_resource_value(resource_name, amount)
	pass

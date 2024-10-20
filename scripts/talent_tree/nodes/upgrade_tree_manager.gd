
class_name UpgradeTreeManager extends Node2D

# Массив для хранения узлов дерева и их данных
var tree_nodes: Array[Dictionary]
# Словарь для данных узла
var node_data: Dictionary

# Функция, вызываемая при готовности узла
func _ready():
	# Рекурсивное получение всех дочерних узлов, являющихся частью дерева
	get_children_rec(self, tree_nodes)
	ClickerManager.instance.update_clicker_nodes(name, tree_nodes)
	# Вывод полученных узлов в лог для проверки
	print(tree_nodes)

# Рекурсивная функция для получения всех дочерних узлов
func get_children_rec(node, arr):
	# Получаем количество дочерних узлов
	var num_children = node.get_child_count()
	if num_children > 0:
		# Проходим по всем дочерним узлам
		for i in num_children:
			var child = node.get_child(i)
			# Если узел является экземпляром SkillNode
			if child is SkillNode:
				# Подключаемся к сигналу изменения уровня узла
				child.node_level_changed.connect(on_node_level_changed)
				# Если узел также является генератором (GeneratorNode)
				if child is GeneratorNode:
					# Подключаемся к сигналу генерации ресурса
					child.resource_generated.connect(on_resource_generated)
				# Добавляем узел и его данные в массив
				arr.append({"node": child, "node_data": child.node_data})
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

class_name ClickerManager
extends Node

# Сигналы для уведомления об изменении ресурса и его силы.
signal resource_changed(resource_name, current_value)
signal resource_strength_changed(resource_name, current_value)
signal node_revealed(node, visibility) # Узел открывается

# Статическая переменная для хранения экземпляра ClickerManager.
static var instance: ClickerManager

# Перечисление доступных ресурсов.
enum RESOURCE {
	TCOIN,
	TAP
}

# Переменные для отслеживания состояния кликов и силы.
var taps = 0 :
	get:
		return taps  # Возвращаем текущее количество кликов.
	set(value):
		taps = value  # Устанавливаем новое количество кликов.
		#taps_changed.emit(value)  # Возможно, это может быть использовано для отдельного сигнала.

var strength = 1  # Сила кликов.
var tapssecond = 0  # Клики в секунду (для авто-кликов).
var auto = 0  # Количество автоматических кликов.
var resource_dict: Dictionary = {}  # Словарь для хранения информации о ресурсах.
var current_resource_key: int  # Текущий ресурс, с которым работает игрок.
var clicker_nodes: Dictionary = {} # словарь для всех узлов

# Функция, вызываемая при готовности узла.
func _ready():
	instance = self  # Сохраняем ссылку на текущий экземпляр.
	
	# Ищем все кнопки ресурсов в сцене.
	for resource_button: ResourceButton in get_tree().get_nodes_in_group("resource_buttons"):
		# Проверяем, есть ли данный ресурс в словаре. Если нет, добавляем его.
		if !resource_dict.has(resource_button.resource_name):
			resource_dict[resource_button.resource_name] = {
				"amount": 0,  # Начальное количество ресурса.
				"strength": { "full": 1 }  # Начальная сила ресурса.
			}
		# Подключаем сигнал к кнопке ресурса для обработки получения ресурса.
		resource_button.gain_resource.connect(_on_resource_gained)
	
# Получение текущего значения ресурса по его имени.
func get_resource_value(resource_name):
	# Проверяем наличие ресурса перед возвратом значения
	return resource_dict.get(resource_name).amount

func update_resource_value(resource_name, value):
	if resource_dict.has(resource_name):
		resource_dict[resource_name].amount += value # Увеличиваем значение ресурса.
		resource_changed.emit(resource_name, resource_dict[resource_name].amount) # Излучаем сигнал об изменении ресурса.

# Обновление силы ресурса на основе источника и нового значения.
func update_resource_strength(resource_name, source, value):
	# Обновляем силу ресурса для конкретного источника.
	resource_dict.get(resource_name).strength[str(source)] = value
	
	# Пересчитываем полную силу ресурса, суммируя значения всех источников.
	for strength_key in resource_dict.get(resource_name).strength:
		if strength_key == "full":
			resource_dict.get(resource_name).strength.full = 1
		else:
			# Добавляем силу от каждого источника к полному значению.
			resource_dict.get(resource_name).strength.full += resource_dict.get(resource_name).strength.get(strength_key)
	
	# Излучаем сигнал об изменении силы ресурса.
	resource_strength_changed.emit(resource_name, resource_dict.get(resource_name).strength.full)

# Обработчик сигнала получения ресурса.
func _on_resource_gained(resource_name):
	current_resource_key = resource_name  # Устанавливаем текущий ключ ресурса.
	# Обновляем количество ресурса с учетом его полной силы.
	update_resource_value(resource_name, resource_dict.get(resource_name).strength.full)

# Функция чтобы доставать из словаря силу клика. Например, чтобы всплывала нужная циферка
func get_resource_strength(resource_name):
	return resource_dict.get(resource_name).strength.full

# Очистка экземпляра при выходе из сцены.
func _exit_tree():
	instance = null

# Обработчик события, когда нода становится видимой.
# Генерирует сигнал о том, что нода была раскрыта.
func _on_node_revealed(node, visibility):
	# Излучаем сигнал о раскрытии ноды, передавая саму ноду и её видимость.
	node_revealed.emit(node, visibility)
	pass  # Заглушка на случай, если нужно будет добавить логику позже.

# Обновляет структуру нод для указанного дерева и подключает обработчики видимости.
func update_clicker_nodes(tree_name, tree_nodes):
	# Сохраняем массив нод для указанного дерева в словаре clicker_nodes.
	clicker_nodes[tree_name] = tree_nodes

	# Для каждой ноды в дереве подключаем сигнал изменения видимости.
	for node_data in tree_nodes:
		# Подключаем сигнал, чтобы вызывать _on_node_revealed при изменении видимости ноды.
		node_data["node"].node_visibility_changed.connect(_on_node_revealed)

		

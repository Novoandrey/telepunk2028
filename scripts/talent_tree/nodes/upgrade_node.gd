@tool class_name SkillNode extends TextureButton 

# Определяем сигналы для отслеживания событий, связанных с узлами
signal node_level_changed(node)  # Срабатывает при изменении уровня узла
signal node_strength_changed(value)  # Срабатывает при изменении силы узла
signal node_visibility_changed(node, visibility)  # Срабатывает при изменении видимости узла
signal node_error(message)  # Вызывает сообщение об ошибке

# Константы для ключей, используемых при работе с данными узлов
const node_key: String = "NODE"  # Идентификатор узла
const path_key: String = "NODE_PATH"  # Путь к узлу
const relationship_key: String = "NODE_RELATIONSHIP"  # Связь между узлами

# Ключи для условий раскрытия и разблокировки узлов
const reveal_resource_amount_required_key: StringName = "Reveal Conditions/Resource Amount Required"
const reveal_nodes_level_required_key: StringName = "Reveal Conditions/Level Required"
const unlock_resource_amount_required_key: StringName = "Unlock Conditions/Resource Amount Required"
const unlock_nodes_level_required_key: StringName = "Unlock Conditions/Level Required"

# Массив ключей для свойств, которые могут быть изменены пользователем
const exposed_properties_keys: Array[StringName] = [
	reveal_resource_amount_required_key, 
	reveal_nodes_level_required_key, 
	unlock_resource_amount_required_key,
	unlock_nodes_level_required_key
]

# Перечисление ключей для хранения данных узлов
enum NODE_DATA_KEYS {
	NODE_DESCRIPTION,  # Описание узла
	CURRENT_COST,  # Текущая стоимость узла
	CURRENT_STRENGTH,  # Текущая сила узла
	LEVEL,  # Уровень узла
	MAX_LEVEL  # Максимальный уровень узла
}

# Перечисление типов связей между узлами
enum CONNECTION_TYPE {
	PREVIOUS,  # Предыдущий узел
	NEXT  # Следующий узел
}

# Перечисление модификаторов для увеличения силы и стоимости узла
enum INCREASE_MODIFIER {
	NO_INCREASE,  # Узел не увеличивает значения при повышении уровня
	MULTIPLICATIVE,  # Умножение значения на модификатор при каждом уровне
	ADDITIVE  # Добавление модификатора к значению при каждом уровне
}

# Инициализация ссылок на UI-элементы узла
@onready var node_level_label = $NodeLevel/Label  # Метка уровня узла
@onready var node_cost_label = $NodeCost/HBoxContainer/Label  # Метка стоимости узла
@onready var node_name_label = $NodeName/Label  # Метка имени узла
@onready var panel = $Panel  # Панель узла
@onready var curve: PackedScene = preload("res://scenes/scene_managment/level_selection/curved_line.tscn")  # Кривая для связи узлов

# Экспортируемые переменные для настройки узлов через редактор
@export var node_id: int  # Уникальный ID узла
@export var node_name: StringName = "default"  # Имя узла
@export var node_description: String  # Описание узла
@export var max_level: int = 10  # Максимальный уровень узла
@export var is_hidden: bool = false:  # Скрыт ли узел
	set(value):
		is_hidden = value
		visible = !is_hidden  # Изменяем видимость
		node_visibility_changed.emit(self, visible)  # Вызываем сигнал изменения видимости
@export var is_unlocked: bool = false  # Разблокирован ли узел для покупки

# Группа переменных, связанных с силой узла
@export_group("Node Strength")
@export var strength: int = 1	# Начальная сила узла при первой покупке
@export var strength_increase: int = 1	# Увеличение силы при повышении уровня
@export var strength_modifier: INCREASE_MODIFIER = INCREASE_MODIFIER.ADDITIVE	# Модификатор роста силы
@export var mult_bool: bool = true	# Флаг для мультипликативного эффекта

# Параметры для разблокировки узлов
@export_group("Unlock Parameters")
@export var resource_required: ClickerManager.RESOURCE = ClickerManager.RESOURCE.TCOIN	# Ресурс для покупки
@export var unlock_cost: int = 1	# Начальная стоимость покупки
@export var unlock_increase: int = 1	# Увеличение стоимости при апгрейде
@export var unlock_cost_modifier: INCREASE_MODIFIER = INCREASE_MODIFIER.ADDITIVE	# Модификатор увеличения стоимости

# Условия раскрытия узлов
@export_group("Reveal Conditions", "reveal_")
@export var reveal_on_nodes_revealed: bool = true:	# Раскрыть при раскрытии предшествующих узлов
	set(value):
		reveal_on_nodes_revealed = value

@export var reveal_on_resource_amount_reached: bool = false:	# Раскрытие по количеству ресурсов
	set(value):
		reveal_on_resource_amount_reached = value
		notify_property_list_changed()	# Уведомить о смене свойств

@export var reveal_on_nodes_level_reached: bool = false:	# Раскрытие по уровню узлов
	set(value):
		reveal_on_nodes_level_reached = value
		notify_property_list_changed()

# Условия разблокировки узлов
@export_group("Unlock Conditions", "unlock_")
@export var unlock_on_resource_amount_reached: bool:	# Возможность разблокировки при достижении ресурсов
	set(value):
		unlock_on_resource_amount_reached = value
		notify_property_list_changed()

@export var unlock_on_nodes_level_reached: bool = true:	# Разблокировка по уровню
	set(value):
		unlock_on_nodes_level_reached = value
		notify_property_list_changed()

@export var next_nodes: Array[SkillNode]	# Следующие узлы
@export var previous_nodes: Array[SkillNode]	# Предыдущие узлы

# Основные данные узла и текущие параметры
var exposed_properties: Dictionary = {}	# Свойства для изменения через редактор
var node_data_arr: Dictionary	# Массив данных узлов
var node_data: Dictionary	# Текущие данные узла

# Уровень узла с обработчиком изменения
var level: int = 0:
	set(value):
		if level != value:
			level = value
			increase_cost()	# Увеличение стоимости
			increase_strength()	# Увеличение силы
			increase_level(value)	# Обновление уровня
			node_data[NODE_DATA_KEYS.LEVEL] = level	# Обновление данных узла
			node_level_changed.emit(self)	# Сигнал об изменении уровня

# Текущая стоимость узла
var current_cost: int:
	set(value):
		current_cost = value
		node_cost_label.text = str(current_cost)	# Обновить текст стоимости
		node_data[NODE_DATA_KEYS.CURRENT_COST] = current_cost

# Текущая сила узла
var current_strength: int:
	set(value):
		current_strength = value
		node_data[NODE_DATA_KEYS.CURRENT_STRENGTH] = current_strength
		node_strength_changed.emit(value)	# Сигнал об изменении силы

# Функция, вызываемая при запуске узла
func _ready():
	if is_hidden:
		hide()	# Скрыть узел, если он скрыт
	node_level_label.text = "0/" + str(max_level)	# Установить текст уровня
	node_name_label.text = node_name	# Установить имя узла
	current_cost = unlock_cost	# Установить начальную стоимость
	initialize_node_data()	# Инициализировать данные узла
	create_connections(next_nodes, CONNECTION_TYPE.NEXT)	# Создать связи с последующими узлами
	create_connections(previous_nodes, CONNECTION_TYPE.PREVIOUS)	# Создать связи с предыдущими узлами
	ClickerManager.instance.resource_changed.connect(_on_resource_amount_changed)	# Подключение к изменению ресурсов

# Инициализация данных узла
func initialize_node_data():
	node_data[NODE_DATA_KEYS.NODE_DESCRIPTION] = node_description  # Установка описания узла
	node_data[NODE_DATA_KEYS.CURRENT_COST] = current_cost  # Установка текущей стоимости
	node_data[NODE_DATA_KEYS.CURRENT_STRENGTH] = current_strength  # Установка текущей силы
	node_data[NODE_DATA_KEYS.LEVEL] = level  # Установка уровня
	node_data[NODE_DATA_KEYS.MAX_LEVEL] = max_level  # Установка максимального уровня

# Создание соединений между узлами
func create_connections(nodes_to_connect, connection_type):
	for node: SkillNode in nodes_to_connect:
		if node == null:
			continue  # Пропуск, если узел отсутствует
		print(str(self) + " has " + str(node))  # Логирование соединения
		if connection_type == CONNECTION_TYPE.NEXT:
			var _current_curve = draw_connection(node)  # Создание кривой связи
			node_data_arr[node.node_id] = {node_key: node, path_key: _current_curve, relationship_key: "next"}
		else:
			node_data_arr[node.node_id] = {node_key: node, relationship_key: "previous"}
		node.node_visibility_changed.connect(on_node_visibility_changed)  # Подключение сигнала видимости
		node.node_level_changed.connect(on_node_level_changed)  # Подключение сигнала изменения уровня

# Отрисовка кривой для соединения узлов
func draw_connection(_node: SkillNode):
	var _current_curve = curve.instantiate()  # Создание экземпляра кривой
	add_child(_current_curve)  # Добавление кривой как дочернего объекта
	_current_curve._path.curve.set_point_position(0, Vector2(0, 0))  # Начальная точка кривой
	_current_curve._path.curve.set_point_position(1, Vector2(_node.global_position.x - position.x, _node.global_position.y - position.y))
	_current_curve._path.curve.set_point_out(0, Vector2(0, (_node.position.y - position.y) / 2))
	_current_curve._path.curve.set_point_in(1, Vector2(0, -(_node.position.y - position.y) / 2))
	_current_curve.redraw()  # Перерисовка кривой
	if _node.is_hidden:
		_current_curve.hide()  # Скрытие кривой, если узел скрыт
	return _current_curve

# Обработчик изменения количества ресурсов
func _on_resource_amount_changed(resource_type, value):
	if resource_type == resource_required:
		if reveal_on_resource_amount_reached and value >= _get(reveal_resource_amount_required_key):
			is_hidden = false  # Раскрыть узел, если достигнуто нужное количество ресурсов
		if unlock_on_resource_amount_reached and value >= _get(unlock_resource_amount_required_key):
			is_unlocked = true  # Разблокировать узел

# Обработчик изменения видимости узла
func on_node_visibility_changed(node_changed, visibility):
	if node_data_arr.has(node_changed.node_id) and visibility:
		if node_data_arr.get(node_changed.node_id).get(relationship_key) == "next":
			var _current_curve = node_data_arr.get(node_changed.node_id).get(path_key)
			_current_curve.show()  # Показать кривую, если узел стал видимым
		elif node_data_arr.get(node_changed.node_id).get(relationship_key) == "previous" and reveal_on_nodes_revealed:
			for previous_node in previous_nodes:
				if previous_node.is_hidden:
					return  # Прерывание, если предыдущий узел скрыт
			is_hidden = false  # Раскрыть узел

# Обработчик изменения уровня узла
func on_node_level_changed(node):
	if node_data_arr.has(node.node_id) and node_data_arr.get(node.node_id).get(relationship_key) == "previous":
		if unlock_on_nodes_level_reached and node.level >= _get(unlock_nodes_level_required_key):
			is_unlocked = true  # Разблокировать узел
		else:
			print("Not enough levels")  # Сообщение о недостаточном уровне
		if reveal_on_nodes_level_reached and node.level >= _get(reveal_nodes_level_required_key):
			is_hidden = false  # Раскрыть узел
		else:
			print("Not enough levels")
	else:
		print("Does not exist in nodes_arr")  # Узел не найден

# Обработчик нажатия на узел
func _on_skill_node_pressed():
	print("Pressed")  # Логирование нажатия
	ClickerUI.instance.open_node_window(self)  # Открытие окна узла

# Покупка узла
func buy_node():
	if is_unlocked:
		if current_cost <= ClickerManager.instance.get_resource_value(resource_required) and level < max_level:
			ClickerManager.instance.update_resource_value(resource_required, -current_cost)  # Списать ресурсы
			level = min(level + 1, max_level)  # Увеличить уровень
			return true
		else:
			print("Not enough resources")  # Сообщение о нехватке ресурсов
			return false
	else:
		print("This node can't be bought")  # Сообщение о невозможности покупки
		return false

# Увеличение стоимости узла
func increase_cost():
	match unlock_cost_modifier:
		INCREASE_MODIFIER.ADDITIVE:
			current_cost += unlock_increase  # Добавление стоимости
		INCREASE_MODIFIER.MULTIPLICATIVE:
			current_cost = unlock_cost * unlock_increase * level  # Мультипликативное увеличение

# Увеличение силы узла
func increase_strength():
	if level != 1:
		match strength_modifier:
			INCREASE_MODIFIER.ADDITIVE:
				current_strength += strength_increase  # Добавление силы
			INCREASE_MODIFIER.MULTIPLICATIVE:
				current_strength = strength * strength_increase * level  # Мультипликативное увеличение
	else:
		current_strength = strength

# Обновление текста уровня
func increase_level(_value):
	node_level_label.text = str(level) + "/" + str(max_level)  # Обновление метки уровня

# Список свойств узла
func _get_property_list() -> Array[Dictionary]:
	var ret: Array[Dictionary] = []
	
	if reveal_on_resource_amount_reached:
		ret.append({"name": reveal_resource_amount_required_key, "type": TYPE_INT})
	if reveal_on_nodes_level_reached:
		ret.append({"name": reveal_nodes_level_required_key, "type": TYPE_INT})
	if unlock_on_resource_amount_reached:
		ret.append({"name": unlock_resource_amount_required_key, "type": TYPE_INT})
	if unlock_on_nodes_level_reached:
		ret.append({"name": unlock_nodes_level_required_key, "type": TYPE_INT})
	return ret

# Установка значения свойства
func _set(prop_name: StringName, value):
	if exposed_properties_keys.has(prop_name):
		exposed_properties[prop_name] = value
		return true

# Получение значения свойства
func _get(prop_name: StringName):
	if exposed_properties_keys.has(prop_name):
		return exposed_properties.get(prop_name)



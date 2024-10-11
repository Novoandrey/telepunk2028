@tool class_name SkillNode extends TextureButton 

signal node_level_changed(node)
signal node_strength_changed(value)
signal node_visibility_changed(node, visiblity)
signal node_error(message)

const node_key: String = "NODE"
const path_key: String = "NODE_PATH"
const relationship_key: String = "NODE_RELATIONSHIP"

const reveal_resource_amount_required_key: StringName = "Reveal Conditions/Resource Amount Required"
const reveal_nodes_level_required_key: StringName = "Reveal Conditions/Level Required"
const unlock_resource_amount_required_key: StringName = "Unlock Conditions/Resource Amount Required"
const unlock_nodes_level_required_key: StringName = "Unlock Conditions/Level Required"

const exposed_properties_keys: Array[StringName] = [reveal_resource_amount_required_key, 
			reveal_nodes_level_required_key, unlock_resource_amount_required_key,
			unlock_nodes_level_required_key]

enum NODE_DATA_KEYS {
	NODE_DESCRIPTION,
	CURRENT_COST,
	CURRENT_STRENGTH,
	LEVEL,
	MAX_LEVEL,
}

enum CONNECTION_TYPE {
	PREVIOUS,
	NEXT
}

enum INCREASE_MODIFIER {
	NO_INCREASE, ##Нод не увеличивает базовое значение при увеличении уровня
	MULTIPLICATIVE, ##Уможение базового значения на модификатор за каждый уровень
	ADDITIVE ##Добавлении модификатора к базовому значению за каждый уровень
}

@onready var node_level_label = $NodeLevel/Label
@onready var node_cost_lable = $NodeCost/HBoxContainer/Label
@onready var node_name_label = $NodeName/Label
@onready var panel = $Panel
@onready var curve: PackedScene = preload("res://scenes/scene_managment/level_selection/curved_line.tscn")

@export var node_id: int ##Уникальный id нода на уровне (пока вручную :P)
@export var node_name: StringName = "default" ##Имя нода на уровне
@export var node_description: String
@export var max_level : int = 10 ##Максимальный уровень нода
@export var is_hidden: bool = false: ##Спрятан ли данный нод на уровне
	set(value):
		is_hidden = value
		visible = !is_hidden
		node_visibility_changed.emit(self, visible)
@export var is_unlocked: bool = false ##Можно ли купить этот нод

@export_group("Node Strength")
@export var strength : int = 1 ##Начальная сила нода при первой покупке
@export var strength_increase: int = 1 ##Увеличение силы нода после покупки
@export var strength_modifier: INCREASE_MODIFIER = INCREASE_MODIFIER.ADDITIVE ##Формат увеличения силы нода при повышении уровня выше 1
@export var mult_bool : bool = true

@export_group("Unlock Parameters")
@export var resource_required: ClickerManager.RESOURCE = ClickerManager.RESOURCE.TCOIN
@export var unlock_cost: int = 1 ##Начальная стоимость нода при 1 покупке
@export var unlock_increase: int = 1 ##Увеличение стоимости нода после покупки
@export var unlock_cost_modifier: INCREASE_MODIFIER = INCREASE_MODIFIER.ADDITIVE ##Формат увеличения стоимости нода при повышении уровня выше 1

@export_group("Reveal Conditions", "reveal_")
@export var reveal_on_nodes_revealed: bool = true: ##Раскрыть нод, если его ведущий к нему нод был раскрыт
	set(value):
		reveal_on_nodes_revealed = value
@export var reveal_on_resource_amount_reached: bool = false: ##Раскрыть нод, если количество ресурса, необходимого для покупки этого нода достигло определенного значения
	set(value):
		reveal_on_resource_amount_reached = value
		notify_property_list_changed()
@export var reveal_on_nodes_level_reached: bool = false: ##Раскрыть нод, если его ведущий(ие) к нему нод(ы) достиг(ли) определенного уровня
	set(value):
		reveal_on_nodes_level_reached = value
		notify_property_list_changed()		

@export_group("Unlock Conditions", "unlock_") ##Возможно прибрести нод при условии
@export var unlock_on_resource_amount_reached: bool : ##Возможно приобрести нод при достижении определенного количества ресурсов
	set(value):
		unlock_on_resource_amount_reached = value
		notify_property_list_changed()
@export var unlock_on_nodes_level_reached: bool = true : ##Возможно приобрести нод, если ведущий(ие) к нему нод(ы) достиг(ли) определенного уровня
	set(value):
		unlock_on_nodes_level_reached = value
		notify_property_list_changed()
@export var next_nodes: Array[SkillNode] ##Этот нод ведет к следующим нодам
@export var previous_nodes: Array[SkillNode] ##К этому ноду ведут следующие ноды

var exposed_properties: Dictionary = {}

var node_data_arr: Dictionary
var node_data: Dictionary

var level : int = 0:
	set(value):
		if level != value:
			level = value
			increase_cost()
			increase_strength()
			increase_level(value)
			node_data[NODE_DATA_KEYS.LEVEL] = level
			node_level_changed.emit(self)

var current_cost: int:
	set(value):
		current_cost = value
		node_cost_lable.text = str(current_cost)
		node_data[NODE_DATA_KEYS.CURRENT_COST] = current_cost

var current_strength: int:
	set(value):
		current_strength = value
		node_data[NODE_DATA_KEYS.CURRENT_STRENGTH] = current_strength
		node_strength_changed.emit(value)

func _ready():
	if is_hidden:
		hide()
	node_level_label.text = "0/" + str(max_level)
	node_name_label.text = node_name
	current_cost = unlock_cost
	initialize_node_data()
	create_connections(next_nodes, CONNECTION_TYPE.NEXT)
	create_connections(previous_nodes, CONNECTION_TYPE.PREVIOUS)
	ClickerManager.instance.resource_changed.connect(_on_resource_amount_changed)

func initialize_node_data():
	node_data[NODE_DATA_KEYS.NODE_DESCRIPTION] = node_description
	node_data[NODE_DATA_KEYS.CURRENT_COST] = current_cost
	node_data[NODE_DATA_KEYS.CURRENT_STRENGTH] = current_strength
	node_data[NODE_DATA_KEYS.LEVEL] = level
	node_data[NODE_DATA_KEYS.MAX_LEVEL] = max_level

func create_connections(nodes_to_connect, connection_type):
	for node: SkillNode in nodes_to_connect:
		print(str(self) + " has " + str(node))
		if connection_type == CONNECTION_TYPE.NEXT:
			var _current_curve = draw_connection(node)
			node_data_arr[node.node_id] = {node_key: node, path_key: _current_curve, relationship_key: "next"}
		else:
			node_data_arr[node.node_id] = {node_key: node, relationship_key: "previous"}
		node.node_visibility_changed.connect(on_node_visibility_changed)
		node.node_level_changed.connect(on_node_level_changed)

func draw_connection(_node: SkillNode):
	var _current_curve = curve.instantiate()
	add_child(_current_curve)
	_current_curve._path.curve.set_point_position(0, Vector2(0,0))
	_current_curve._path.curve.set_point_position(1, Vector2(_node.global_position.x - position.x, _node.global_position.y - position.y))
	_current_curve._path.curve.set_point_out(0, Vector2(0,(_node.position.y - position.y)/2))
	_current_curve._path.curve.set_point_in(1, Vector2(0,-(_node.position.y - position.y)/2))
	_current_curve.redraw()
	if _node.is_hidden:
		_current_curve.hide()
	return _current_curve

func _on_resource_amount_changed(resource_type, value):
	if resource_type == resource_required:
		if reveal_on_resource_amount_reached and value >= _get(reveal_resource_amount_required_key):
			is_hidden = false
		if unlock_on_resource_amount_reached and value >= _get(unlock_resource_amount_required_key):
			is_unlocked = true

func on_node_visibility_changed(node_changed, visibility):
	if node_data_arr.has(node_changed.node_id) and visibility:
		if node_data_arr.get(node_changed.node_id).get(relationship_key) == "next":
			var _current_curve = node_data_arr.get(node_changed.node_id).get(path_key)
			_current_curve.show()
		elif node_data_arr.get(node_changed.node_id).get(relationship_key) == "previous" and reveal_on_nodes_revealed:
			for previous_node in previous_nodes:
				if previous_node.is_hidden:
					return
			is_hidden = false
			

func on_node_level_changed(node):
	if node_data_arr.has(node.node_id) and node_data_arr.get(node.node_id).get(relationship_key) == "previous":
		if unlock_on_nodes_level_reached and node.level >= _get(unlock_nodes_level_required_key):
			is_unlocked = true
		else:
			print("Not enough levels")
		if reveal_on_nodes_level_reached and node.level >= _get(reveal_nodes_level_required_key):
			is_hidden = false
		else:
			print("Not enough levels")
	else:
		print("Does not exist in nodes_arr")

func _on_skill_node_pressed():
	print("Pressed")
	ClickerUI.instance.open_node_window(self)

func buy_node():
	if is_unlocked:
		if current_cost <= ClickerManager.instance.get_resource_value(resource_required) and level < max_level:
			ClickerManager.instance.update_resource_value(resource_required, -current_cost)
			level = min( level + 1, max_level) 
			return true
		else:
			pass
			print("not enough resources")
			return false
	else:
		print("This node can't be bought")
		pass

func increase_cost():
	match unlock_cost_modifier:
		INCREASE_MODIFIER.ADDITIVE:
			current_cost += unlock_increase
		INCREASE_MODIFIER.MULTIPLICATIVE:
			current_cost = unlock_cost * unlock_increase * level
	
func increase_strength():
	if level != 1:
		match strength_modifier:
			INCREASE_MODIFIER.ADDITIVE:
				current_strength += strength_increase
			INCREASE_MODIFIER.MULTIPLICATIVE:
				current_strength = strength * strength_increase * level
	else:
		current_strength = strength

func increase_level(_value):
	node_level_label.text = str(level) + "/" + str(max_level)

func _get_property_list() -> Array[Dictionary]:
	var ret: Array[Dictionary] = []
	
	if reveal_on_resource_amount_reached:
		ret.append({
		"name": reveal_resource_amount_required_key,
		"type": TYPE_INT,
	})
	if reveal_on_nodes_level_reached:
		ret.append({
		"name": reveal_nodes_level_required_key,
		"type": TYPE_INT,
	})
	if unlock_on_resource_amount_reached:
		ret.append({
		"name": unlock_resource_amount_required_key,
		"type": TYPE_INT,
	})
	if unlock_on_nodes_level_reached:
		ret.append({
		"name": unlock_nodes_level_required_key,
		"type": TYPE_INT,
	})
	return ret


func _set(prop_name: StringName, value):
	if exposed_properties_keys.has(prop_name):
		exposed_properties[prop_name] = value
		return true

func _get(prop_name: StringName):
	if exposed_properties_keys.has(prop_name):
		return exposed_properties.get(prop_name)


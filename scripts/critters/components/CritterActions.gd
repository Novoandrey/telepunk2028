class_name CritterActions extends CritterComponent

static var component_name: String

signal action_points_changed(_previous_value, _current_value)

@export var _actions: Array[Action]
@export var _action_points: int

var _current_action_points: int :
	get:
		return _current_action_points
	set(value):
		action_points_changed.emit(_current_action_points, value)
		_current_action_points = value
var _current_action: Action :
	get:
		return _current_action
	set(value):
		_current_action = value
var _current_action_targets: Dictionary = {}
var _current_action_key: String
var _current_action_component

func _ready():
	component_name = "CritterActions"
	_current_action_points = _action_points
	for action: Action in _actions:
		action.action_canceled.connect(_on_action_canceled)
		action.action_selected.connect(_on_action_selected)
		action.action_activated.connect(_on_action_activated)
		pass

static func get_custom_class_name() -> String:
	return component_name

func _on_action_canceled(): ##Событие отмены способности
	_current_action = null
	_current_action_targets = {}

func _on_action_selected(_action): ##Событие выбора способности
	_current_action = _action
	print("Action selected")
	_current_action_key = _action.action_name
	_current_action_targets[_current_action_key] = []
	GameManager.instance.can_select_critters = false

func _on_action_activated(): ##Событие активации способности
	_current_action_points -= _current_action._action_cost
	_current_action = null
	_current_action_targets = {}
	GameManager.instance.can_select_critters = true

func ready_action(target):
	print("Try to activate action")
	if _current_action != null:
		prepare_targets(target)
		if is_action_ready():
			execute_action()	
	else:
		print("No action selected")

func execute_action_early(): ##Использовать способность не дожидаясь выбора всех возможных целей
	if _current_action_targets.size() >= _current_action.get_component_list_size():
		_current_action.activate_action(_current_action_targets, critter)
	pass

func next_action_component():
	var is_next: bool = false
	for action_component in _current_action.get_component_list():
		if is_next:
			if _current_action.component_list.get(action_component).has_own_targets:
				return action_component
			else:
				_current_action_targets[action_component] = _current_action_targets[_current_action.action_name]
		if action_component == _current_action_key:
			is_next = true
	return _current_action_key

func prepare_targets(target):
	if _current_action_targets.get(_current_action_key).size() < _current_action.get_component_targets(_current_action_key):
			print("Prepare current action")
			if _current_action.can_apply_to_component(_current_action_key, target):
				print("Added target to list")
				_current_action_targets[_current_action_key].append(target)
				if _current_action_targets[_current_action_key].size() >= _current_action.get_component_targets(_current_action_key):
					print("Selecting next component")
					_current_action_key = next_action_component()

func is_action_ready():
	return _current_action_targets.size() >= _current_action.get_component_list_size() and _current_action_targets.get(_current_action_key).size() >= _current_action.get_component_targets(_current_action_key)

func execute_action():
	print("Activate current action")
	_current_action.activate_action(_current_action_targets, critter)

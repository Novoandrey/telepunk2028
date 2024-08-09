class_name ActionController

extends Control

@export var _action: PackedScene
@export var _action_text_hint: String
@export var _cost: int
@export var max_usage: int = -1

signal current_usage_on_value_changed(previousValue, currentValue)

@onready var _actionHint: Label = get_node("../../ActionHint")
@onready var _button: TextureButton = get_child(0).get_child(0)
@onready var _usage_bar: ProgressBar = get_child(0).get_child(1)
var current_usage: int :
	get:
		return current_usage
	set(value):
		current_usage_on_value_changed.emit(current_usage, value)
		current_usage = value
		if current_usage == 0:
			#_button.disabled = true
			pass
		else: 
			#_button.disabled = false
			pass

var _player: Critter
var created_action: Action
var is_active: bool = false

func _ready():
	get_node("../../../../GameManager").Player_Critter_Added.connect(On_Player_Critter_Spawned)
	if max_usage == -1:
		_usage_bar.hide()
	current_usage = max_usage

func On_Player_Critter_Spawned(_playerCritter):
	_playerCritter.current_action_on_value_changed.connect(set_is_active)
	_player = _playerCritter

func _on_texture_button_pressed():
	if _action != null:
		if current_usage == 0:
			_actionHint.text = "Не хватает использований"
			return
		if !is_active:
			if _cost > _player._currentActionPoints:
				_actionHint.text = "Не хватает очков действий"
				return
			else:
				created_action = _action.instantiate()
				created_action.action_resource = self
				created_action.on_action_used.connect(use_action)
				_player.add_child(created_action)
				is_active = true
		else:
			created_action.on_action_used.disconnect(use_action)
			_player.remove_child(created_action)
			is_active = false
		print("created")

func set_is_active(previousValue, currentValue):
	if currentValue == null:
		is_active = false
	

func use_action():
	if current_usage > 0:
		current_usage -= 1

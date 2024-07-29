class_name ActionController

extends Control

@export var _action: PackedScene
@export var max_usage: int = -1

signal On_Current_Usage_Value_Changed(previousValue, currentValue)

@onready var _actionHint: Label = get_node("/root/ArenaScene/CanvasLayer/UI/ActionHint")
@onready var _button: TextureButton = get_child(0).get_child(0)
@onready var _usage_bar: ProgressBar = get_child(0).get_child(1)
var current_usage: int :
	get:
		return current_usage
	set(value):
		On_Current_Usage_Value_Changed.emit(current_usage, value)
		current_usage = value
		if current_usage == 0:
			#_button.disabled = true
			pass
		else: 
			_button.disabled = false

var _player
var created_action: Action
var is_active: bool = false

func _ready():
	get_node("/root/ArenaScene/GameManager").Player_Critter_Added.connect(On_Player_Critter_Spawned)
	if max_usage == -1:
		_usage_bar.hide()
	current_usage = max_usage

func On_Player_Critter_Spawned(_playerCritter):
	_playerCritter.Current_Action_On_Value_Changed.connect(set_is_active)
	_player = _playerCritter

func _on_texture_button_pressed():
	if _action != null:
		if current_usage == 0:
			_actionHint.text = "Не хватает использований"
			return
		if !is_active:
			created_action = _action.instantiate()
			if _player._currentActionPoints > created_action._cost:
				created_action.OnActionUsed.connect(use_action)
				_player.add_child(created_action)
				is_active = true
		else:
			created_action.OnActionUsed.disconnect(use_action)
			_player.remove_child(created_action)
			is_active = false
		print("created")

func set_is_active(previousValue, currentValue):
	if currentValue == null:
		is_active = false
	

func use_action():
	if current_usage > 0:
		current_usage -= 1

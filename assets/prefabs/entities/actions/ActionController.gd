extends Control

@export var _action: PackedScene
@onready var _player = get_node("/root/ArenaScene/Player")
var created_action
var is_active: bool = false

func _ready():
	_player.Current_Action_On_Value_Changed.connect(set_is_active)

func _on_texture_button_pressed():
	if !is_active:
		created_action = _action.instantiate()
		if _player._currentActionPoints > created_action._cost:
			_player.add_child(created_action)
			is_active = true
	else:
		_player.remove_child(created_action)
		is_active = false
	print("created")

func set_is_active(previousValue, currentValue):
	if currentValue == null:
		is_active = false
	

extends Control

@export var _action: PackedScene

var _player
var created_action
var is_active: bool = false

func _ready():
	get_node("/root/ArenaScene/GameManager").Player_Critter_Added.connect(On_Player_Critter_Spawned)
	pass

func On_Player_Critter_Spawned(_playerCritter):
	_playerCritter.Current_Action_On_Value_Changed.connect(set_is_active)
	_player = _playerCritter

func _on_texture_button_pressed():
	if _action != null:
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
	

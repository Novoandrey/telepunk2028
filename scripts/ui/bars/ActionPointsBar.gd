extends ProgressBar

@onready var label: Label = get_node("APCount")

var _player: CharacterBody2D

func On_Player_Critter_Spawned(_playerCritter):
	_player = _playerCritter
	_player.current_actionPoints_on_value_changed.connect(Current_ActionPoints)
	max_value = _player._actionPoints
	value = _player._actionPoints
	label.text = "{current}/{max}".format({"current": value, "max": max_value})

func Current_ActionPoints(previousValue, currentValue):
	value = currentValue;
	label.text = "{current}/{max}".format({"current": value, "max": max_value})

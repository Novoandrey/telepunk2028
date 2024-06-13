extends ProgressBar


@onready var label: Label = get_node("MPCount")

var _player: CharacterBody2D

func On_Player_Critter_Spawned(_playerCritter):
	_player = _playerCritter
	_player.Current_MovePoints_On_Value_Changed.connect(Current_MovePoints)
	max_value = _player._movePoints
	value = _player._movePoints
	label.text = "{current}/{max}".format({"current": value, "max": max_value})

func Current_MovePoints(previousValue, currentValue):
	value = currentValue;
	label.text = "{current}/{max}".format({"current": value, "max": max_value})

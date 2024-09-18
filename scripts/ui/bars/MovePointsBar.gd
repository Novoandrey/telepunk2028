extends ProgressBar

@onready var gameManager: GameManager = get_node("../../../../GameManager")
@onready var label: Label = get_node("MPCount")

var _player: CharacterBody2D

func _ready():
	gameManager.critter_selected.connect(on_critter_selected)
	pass

func on_critter_selected(_previous_critter, _selected_critter):
	_player = _selected_critter
	if _previous_critter != null:
		_previous_critter.current_movePoints_on_value_changed.disconnect(current_movePoints)
	_player.current_movePoints_on_value_changed.connect(current_movePoints)
	max_value = _player._movePoints
	value = _player._movePoints
	label.text = "{current}/{max}".format({"current": value, "max": max_value})

func current_movePoints(_previousValue, currentValue):
	value = currentValue;
	label.text = "{current}/{max}".format({"current": value, "max": max_value})

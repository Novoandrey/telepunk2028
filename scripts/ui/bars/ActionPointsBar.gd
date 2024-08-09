extends ProgressBar

@onready var label: Label = get_node("APCount")
@onready var gameManager: GameManager = get_node("../../../../GameManager")


var _player: CharacterBody2D

func _ready():
	gameManager.critter_selected.connect(on_critter_selected)
	pass

func on_critter_selected(_previous_critter, _selected_critter):
	_player = _selected_critter
	if _previous_critter != null:
		_previous_critter.current_actionPoints_on_value_changed.disconnect(current_actionPoints)
	_player.current_actionPoints_on_value_changed.connect(current_actionPoints)
	max_value = _player._actionPoints
	value = _player._actionPoints
	label.text = "{current}/{max}".format({"current": value, "max": max_value})

func current_actionPoints(previousValue, currentValue):
	value = currentValue;
	label.text = "{current}/{max}".format({"current": value, "max": max_value})

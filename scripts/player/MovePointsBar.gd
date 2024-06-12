extends ProgressBar

@onready var _char: CharacterBody2D = get_node("/root/ArenaScene/Player")
@onready var label: Label = get_node("MPCount")

func _ready():
	_char.Current_MovePoints_On_Value_Changed.connect(Current_MovePoints)
	max_value = _char._movePoints
	value = _char._movePoints
	label.text = "{current}/{max}".format({"current": value, "max": max_value})

func Current_MovePoints(previousValue, currentValue):
	value = currentValue;
	label.text = "{current}/{max}".format({"current": value, "max": max_value})

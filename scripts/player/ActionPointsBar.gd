extends ProgressBar

@onready var _char: CharacterBody2D = get_node("/root/ArenaScene/Player")
@onready var label: Label = get_node("APCount")

func _ready():
	_char.Current_ActionPoints_On_Value_Changed.connect(Current_ActionPoints)
	max_value = _char._actionPoints
	value = _char._actionPoints
	label.text = "{current}/{max}".format({"current": value, "max": max_value})

func Current_ActionPoints(previousValue, currentValue):
	value = currentValue;
	label.text = "{current}/{max}".format({"current": value, "max": max_value})

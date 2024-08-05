extends TextureProgressBar

@onready var _char: CharacterBody2D = get_node("../")
@onready var label: Label = get_node("HPCount")
func _ready():
	max_value = _char._health
	value = _char._health
	_char.current_health_on_value_changed.connect(Current_Health)
	label.text = "{current}/{max}".format({"current": value, "max": max_value})

func Current_Health(previousValue, currentValue):
	value = currentValue;
	label.text = "{current}/{max}".format({"current": value, "max": max_value})

extends TextureProgressBar

@export var _char: CharacterBody2D

func _ready():
	max_value = _char._health
	value = _char._currentHealth

func Current_Health(previousValue, currentValue):
	value = currentValue;
	var label: Label = get_node("Label")
	label.text = "{current}/{max}".format({"current": value, "max": max_value})

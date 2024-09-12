extends ProgressBar

@onready var label: Label = get_node("APCount")

func _ready():
	GameManager.instance.critter_selected.connect(on_critter_selected)

func on_critter_selected(_previous_critter, _selected_critter):
	if _previous_critter != null and _previous_critter.has_critter_component(CritterActions.get_custom_class_name()):
		var critter_action_component: CritterActions = _previous_critter.get_critter_component(CritterActions.get_custom_class_name())
		critter_action_component.action_points_changed.disconnect(current_action_points)
	if _selected_critter.has_critter_component(CritterActions.get_custom_class_name()):
		show()
		var critter_action_component: CritterActions = _selected_critter.get_critter_component(CritterActions.get_custom_class_name())
		critter_action_component.action_points_changed.connect(current_action_points)
		max_value = critter_action_component._action_points
		value = critter_action_component._current_action_points
		label.text = "{current}/{max}".format({"current": value, "max": max_value})
	else:
		hide()

func current_action_points(previousValue, currentValue):
	value = currentValue;
	label.text = "{current}/{max}".format({"current": value, "max": max_value})

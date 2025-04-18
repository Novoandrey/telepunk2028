extends ProgressBar

@onready var label: Label = $Label
@onready var action: ActionController = $"../.."

func _ready():
	max_value = action.max_usage
	value = action.current_usage
	label.text = str(action.current_usage) + "/" + str(action.max_usage)
	action.current_usage_on_value_changed.connect(current_uses)

func current_uses(previousValue, currentValue):
	max_value = action.max_usage
	value = currentValue
	label.text = str(currentValue) + "/" + str(action.max_usage)

class_name StoryNode extends SynapsNode

# Экспортируемая переменная для увеличения силы при нажатии на ресурс
@export var resource_tap_strength_increase: ClickerManager.RESOURCE = ClickerManager.RESOURCE.TCOIN

# Функция, вызываемая при готовности узла
func _ready():
	pass
	# Вызов родительской функции _ready() для инициализации

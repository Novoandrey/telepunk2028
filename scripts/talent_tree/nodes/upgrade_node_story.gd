@tool
class_name StoryNode extends SkillNode

# Экспортируемая переменная для увеличения силы при нажатии на ресурс
@export var resource_tap_strength_increase: ClickerManager.RESOURCE = ClickerManager.RESOURCE.TCOIN

# Функция, вызываемая при готовности узла
func _ready():
	# Вызов родительской функции _ready() для инициализации
	super()
	# Подключение к сигналу изменения силы узла
	node_strength_changed.connect(on_node_strength_changed)

# Обработчик события изменения силы узла
func on_node_strength_changed(_value):
	# Вывод текущей силы узла в лог для отладки
	print(current_strength)
	# Обновление силы ресурса в менеджере кликера
	ClickerManager.instance.update_resource_strength(resource_tap_strength_increase, node_id, current_strength)

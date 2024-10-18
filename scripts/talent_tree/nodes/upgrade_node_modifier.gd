@tool
class_name ModifierNode extends SkillNode

# Экспортируемая переменная для ссылки на родительский узел, который будет усилен
@export var parent_node: SkillNode ## Родительский узел для усиления
# Тип усиления, который будет применен к родительскому узлу (добавочный или мультипликативный)
@export var power_up_type: INCREASE_MODIFIER = INCREASE_MODIFIER.ADDITIVE ## Формат усиления родительского узла

# Функция, вызываемая при готовности узла
func _ready():
	# Вызов родительской функции _ready() для инициализации узла
	super()
	# Создание соединения с родительским узлом
	create_connections([parent_node], CONNECTION_TYPE.PREVIOUS)

# Увеличение уровня узла
func increase_level(value):
	# Вызов родительской функции для увеличения уровня
	super(value)
	# Усиление родительского узла
	power_up_parent()

# Усиление родительского узла
func power_up_parent(type: INCREASE_MODIFIER = power_up_type):
	# Определение типа усиления узла (добавочный или мультипликативный)
	match power_up_type:
		INCREASE_MODIFIER.ADDITIVE:
			# Добавление текущей силы к силе родительского узла
			print(parent_node.current_strength)
			print(current_strength)
			parent_node.current_strength = parent_node.current_strength + current_strength
		INCREASE_MODIFIER.MULTIPLICATIVE:
			# Мультипликативное усиление силы родительского узла
			parent_node.current_strength += parent_node.strength * current_strength
			pass

# Закомментированная функция для валидации свойств (можно использовать для исключения свойств из редактора)
# func _validate_property(property):
# 	if property.name == "previous_nodes" or property.name == "next_nodes":
# 		property.usage &= ~PROPERTY_USAGE_EDITOR

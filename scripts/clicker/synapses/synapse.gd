@tool class_name SynapsNode extends TextureButton 

# Определяем сигналы для отслеживания событий, связанных с узлами
signal node_level_changed(node)  # Срабатывает при изменении уровня узла
signal node_strength_changed(value)  # Срабатывает при изменении силы узла
signal node_visibility_changed(node, visibility)  # Срабатывает при изменении видимости узла
signal node_error(message)  # Вызывает сообщение об ошибке

var synaps_data

# Функция, вызываемая при запуске узла
func _ready():
	pass
	
func initialize_node(synaps_data) -> void:
	self.synaps_data = synaps_data
	print(synaps_data)
	name = synaps_data.get("def")

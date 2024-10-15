class_name ResourceButton extends TextureButton

# Сигнал для передачи ресурса при нажатии кнопки.
# Параметр resource_name указывает тип ресурса, который будет добавлен.
signal gain_resource(resource_name)

# Название ресурса, связанного с кнопкой, по умолчанию TCOIN.
@export var resource_name: ClickerManager.RESOURCE = ClickerManager.RESOURCE.TCOIN

# Подключение сигнала при готовности кнопки.
func _ready():
	pressed.connect(on_button_pressed)  # Привязка сигнала к функции нажатия
	pass  # Заглушка для возможности добавления логики в будущем

# Функция, вызываемая при нажатии на кнопку.
# Генерирует сигнал для добавления ресурса.
func on_button_pressed():
	gain_resource.emit(resource_name)  # Отправляем сигнал с названием ресурса

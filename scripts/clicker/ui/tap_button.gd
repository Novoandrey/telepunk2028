class_name ResourceButton extends TextureButton

# Сигнал для передачи ресурса при нажатии кнопки.
# Параметр resource_name указывает тип ресурса, который будет добавлен.
signal gain_resource(resource_name)

# Название ресурса, связанного с кнопкой, по умолчанию TCOIN.
@export var resource_name: ClickerManager.RESOURCE = ClickerManager.RESOURCE.TCOIN

# Загрузка сцены с плавающим текстом 
@onready var floating_text_scene: PackedScene = preload("res://scenes/game_chapters/prequel_clicker/DynamicLabels/ResourceGainLabel.tscn")

# Подключение сигнала при готовности кнопки.
func _ready():
	# Привязка сигнала к функции нажатия кнопки.
	pressed.connect(on_button_pressed)

# Функция для отображения всплывающего текста с ресурсом.
func show_floating_text(resource_amount: int, click_position: Vector2):
	# Инстанцируем сцену всплывающего текста.
	var floating_text_instance = floating_text_scene.instantiate()
	floating_text_instance.position = click_position - get_parent().position
	
	add_child(floating_text_instance)

	# Обновляем текст с количеством полученного ресурса.
	floating_text_instance.text = "+" + str(resource_amount)
	
	# Запускаем анимацию исчезновения.
	floating_text_instance.get_node("AnimationPlayer").play("disappear")

# Функция, вызываемая при нажатии на кнопку.
# Генерирует сигнал для добавления ресурса и отображает всплывающий текст.
func on_button_pressed():
	# Получаем силу клика из ClickerManager.
	var resource_amount = ClickerManager.instance.get_resource_strength(resource_name)
	
	# Генерируем сигнал для добавления ресурса (например, золота).
	gain_resource.emit(resource_name)
	
	# Отображаем всплывающий текст на месте клика.
	show_floating_text(resource_amount, get_global_mouse_position())

	

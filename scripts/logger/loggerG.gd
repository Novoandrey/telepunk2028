extends CanvasLayer

var rich_text_label
var button  # Переменная для кнопки
var icon  # Переменная для иконки
var icon_texture_rect  # Переменная для TextureRect иконки
var is_dragging = false  # Флаг для отслеживания состояния перетаскивания
var drag_offset = Vector2.ZERO  # Смещение при перетаскивании
var control  # Узел для логгера

# Функция для инициализации элементов
func _ready():
	# Получаем размеры экрана
	var viewport_size = get_viewport().get_visible_rect().size

	# Создаем узел Control для управления позиционированием
	control = Control.new()
	add_child(control)

	# Настраиваем якоря для Control
	control.anchor_left = 0
	control.anchor_top = 0.5
	control.anchor_right = 0
	control.anchor_bottom = 0.5

	# Устанавливаем смещение от левого края и центрируем по вертикали
	control.position = Vector2(20, viewport_size.y / 2)

	# Создаем контейнер для вертикального расположения
	var vbox = VBoxContainer.new()
	control.add_child(vbox)

	# Создаем и настраиваем RichTextLabel
	rich_text_label = RichTextLabel.new()
	rich_text_label.bbcode_enabled = true
	rich_text_label.text = "Это RichTextLabel"
	rich_text_label.custom_minimum_size = Vector2(400, 300)
	vbox.add_child(rich_text_label)

	# Создаем и настраиваем кнопку
	button = Button.new()
	button.custom_minimum_size = Vector2(50, 50)
	button.text = "Логгер"  # Текст кнопки
	vbox.add_child(button)

	# Загружаем иконку Godot
	icon = load("res://icon.svg")
	if icon:
		icon_texture_rect = TextureRect.new()
		icon_texture_rect.texture = icon
		icon_texture_rect.scale = Vector2(0.5, 0.5)
		icon_texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		button.add_child(icon_texture_rect)
	else:
		print("Не удалось загрузить иконку!")

	# Убираем текст кнопки
	button.text = ""

	# Подключаем событие нажатия кнопки
	button.pressed.connect(_on_button_pressed)

	# Подключаем события для управления перетаскиванием
	control.connect("gui_input", _on_control_input)

# Функция, вызываемая при нажатии на кнопку
func _on_button_pressed():
	if rich_text_label.visible:
		rich_text_label.hide()
		icon_texture_rect.texture = load("res://icon.svg")  # Замените на правильный путь к другой иконке
	else:
		rich_text_label.show()
		icon_texture_rect.texture = icon  # Возвращаем оригинальную иконку

func add_log(message: String):
	rich_text_label.text += "[color=yellow]" + message + "[/color]\n"
	rich_text_label.scroll_to_line(rich_text_label.get_line_count() - 1)

func _on_control_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Начинаем перетаскивание
				is_dragging = true
				drag_offset = event.position  # Сохраняем смещение относительно текущей позиции мыши
			else:
				is_dragging = false

	if event is InputEventMouseMotion and is_dragging:
		# Перемещаем контейнер во время перетаскивания
		control.position += event.relative  # Перемещаем контейнер

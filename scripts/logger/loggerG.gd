extends CanvasLayer

var rich_text_label
var button  # Переменная для кнопки
var clear_button  # Переменная для кнопки очистки
var is_dragging = false  # Флаг для отслеживания состояния перетаскивания
var drag_offset = Vector2.ZERO  # Смещение при перетаскивании
var control  # Узел для логгера

# Функция для инициализации элементов
func _ready():
	var viewport_size = get_viewport().get_visible_rect().size

	control = Control.new()
	add_child(control)

	control.anchor_left = 0
	control.anchor_top = 0.5
	control.anchor_right = 0
	control.anchor_bottom = 0.5

	control.position = Vector2(20, viewport_size.y / 2)

	var vbox = VBoxContainer.new()
	control.add_child(vbox)

	rich_text_label = RichTextLabel.new()
	rich_text_label.bbcode_enabled = true
	rich_text_label.custom_minimum_size = Vector2(400, 300)
	vbox.add_child(rich_text_label)

	button = Button.new()
	button.custom_minimum_size = Vector2(50, 50)
	vbox.add_child(button)

	clear_button = Button.new()
	clear_button.custom_minimum_size = Vector2(50, 50)
	clear_button.text = "Очистить лог"  # Текст кнопки очистки
	clear_button.connect("pressed", _on_clear_button_pressed)
	vbox.add_child(clear_button)

	# Убираем текст кнопки и иконку
	button.text = "Открыть логгер"

	button.pressed.connect(_on_button_pressed)

	# Подключаем события для управления перетаскиванием на кнопку
	button.connect("gui_input", _on_button_input)

	# Скрываем элементы
	rich_text_label.hide()
	clear_button.hide()

# Функция, вызываемая при нажатии на кнопку
func _on_button_pressed():
	if rich_text_label.visible:
		rich_text_label.hide()
		clear_button.hide()
		button.text = "Открыть логгер"
	else:
		rich_text_label.show()
		clear_button.show()
		button.text = "Закрыть логгер"

func add_log(message: String):
	rich_text_label.text += "[color=yellow]" + message + "[/color]\n"
	rich_text_label.scroll_to_line(rich_text_label.get_line_count() - 1)

func _on_clear_button_pressed():
	rich_text_label.clear()  # Очищаем текст в логгере

# Обработка ввода для перетаскивания
func _on_button_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_dragging = true
				drag_offset = event.position
			else:
				is_dragging = false

	if event is InputEventMouseMotion and is_dragging:
		# Перемещаем контейнер во время перетаскивания
		control.position += event.relative

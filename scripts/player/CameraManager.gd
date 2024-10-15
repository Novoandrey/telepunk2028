class_name CameraManager
extends Camera2D

# Статическая переменная для хранения экземпляра CameraManager.
static var instance: CameraManager

# Параметры управления камерой.
@export var max_zoom = 2  # Максимальное приближение.
@export var min_zoom = 0.25  # Минимальное отдаление.
@export var zoom_speed = 0.1  # Скорость изменения масштаба.
@export var pan_speed: float = 1.0  # Скорость панорамирования (перемещения камеры).
@export var boundsUpperOffset = 0  # Верхнее смещение границ карты.
@export var can_pan: bool  # Разрешено ли панорамирование.
@export var can_zoom: bool  # Разрешено ли масштабирование.
@export var can_rotate: bool  # Разрешено ли вращение.

# Ссылки на узлы, необходимые для управления камерой.
@onready var tile_map: TileMap = TileMapManager.instance
@onready var point_a = get_node("../PointA")
@onready var point_b = get_node("../PointB")
@onready var point_center = get_node("../PointCenter")
@onready var drag_timer

# Переменные для работы с перемещением и зумом камеры.
var drag_start_pos = Vector2.ZERO  # Начальная позиция для перемещения камеры.
var drag_camera_pos = Vector2.ZERO  # Позиция камеры в момент начала перемещения.
var is_dragging = false :
	get:
		return is_dragging  # Проверяем, выполняется ли перемещение.
	set(value):
		is_dragging = value  # Устанавливаем статус перемещения.

var start_zoom: Vector2  # Начальный зум при касании на мобильных устройствах.
var start_dist: float  # Начальная дистанция между точками касания для зума.
var _touches: Dictionary = {}  # Словарь для отслеживания касаний экрана.

# Функция, вызываемая при готовности узла.
func _ready():
	instance = self  # Сохраняем ссылку на текущий экземпляр.
	
	create_drag_timer()  # Создаём таймер для перетаскивания камеры.
	
	# Определяем границы карты.
	var top_bound = 0
	var left_bound = 0
	var right_bound = get_viewport_rect().size.x
	var bottom_bound = get_viewport_rect().size.y
	
	if tile_map != null:
		# Выводим информацию о положении и размере карты.
		print("Tilemap start" + str(tile_map.get_used_rect().position))
		print("Tilemap end" + str(tile_map.get_used_rect().end))
		print("Tilemap size" + str(tile_map.get_used_rect().size))
		
		var boundsStart = tile_map.to_global(tile_map.map_to_local(tile_map.get_used_rect().position))
		var boundsEnd = tile_map.to_global(tile_map.map_to_local(tile_map.get_used_rect().end))
		
		# Устанавливаем границы с учётом верхнего смещения.
		top_bound = boundsStart.y - boundsUpperOffset
		left_bound = boundsStart.x
		right_bound = boundsEnd.x
		bottom_bound = boundsEnd.y
	
	# Делаем камеру активной.
	make_current()

# Создание таймера для отслеживания начала перемещения камеры.
func create_drag_timer():
	drag_timer = Timer.new()
	add_child(drag_timer)
	drag_timer.one_shot = true  # Таймер срабатывает один раз.
	drag_timer.wait_time = 0.2  # Задержка перед началом перемещения.
	drag_timer.timeout.connect(_on_timer_timeout)

# Обработка не перехваченных событий ввода.
func _unhandled_input(event):
	mobile_camera_control(event)  # Обрабатываем ввод для мобильных устройств.
	pc_camera_control(event)  # Обрабатываем ввод для ПК.

# Управление камерой для ПК.
func pc_camera_control(event):
	if event is InputEventScreenTouch:
		return
	
	if event is InputEventMouseButton:
		# Обработка масштабирования с помощью колеса мыши.
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if zoom.x < max_zoom:
				zoom *= 1.1
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if zoom.x > min_zoom:
				zoom *= 0.9
		
		# Обработка начала перемещения камеры при нажатии левой кнопки мыши.
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_touches[0] = event.position
			drag_start_pos = get_viewport().get_mouse_position()
			drag_camera_pos = get_screen_center_position()
			start_drag()
		
		# Окончание перемещения камеры при отпускании левой кнопки мыши.
		if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			_touches.erase(0)
			is_dragging = false
	
	if event is InputEventMouseMotion:
		# Обрабатываем перемещение камеры, если есть активные касания (зажата левая кнопка).
		if _touches.size() >= 1:
			var moveVector = get_viewport().get_mouse_position() - drag_start_pos
			position = drag_camera_pos - moveVector * 1 / zoom.x

# Управление камерой для мобильных устройств.
func mobile_camera_control(event):
	if event is InputEventMouseButton:
		return
	
	if event is InputEventScreenTouch:
		_handle_touch(event)
	elif event is InputEventScreenDrag:
		_handle_drag(event)

# Обработка касаний экрана.
func _handle_touch(event):
	if event.pressed:
		# Начинаем отслеживать касание.
		_touches[event.index] = event.position
		start_drag()
	else:
		# Убираем касание, если оно завершилось.
		_touches.erase(event.index)
		if _touches.size() <= 0:
			is_dragging = false
	
	# Если касаний два, начинаем отслеживать зум.
	if _touches.size() == 2:
		var touch_point_positions = _touches.values()
		start_dist = touch_point_positions[0].distance_to(touch_point_positions[1])
		start_zoom = zoom

# Обработка перетаскивания на мобильных устройствах.
func _handle_drag(event):
	_touches[event.index] = event.position 
	
	# Если есть одно касание и разрешено панорамирование, перемещаем камеру.
	if _touches.size() == 1 and can_pan:
		print("Panning")
		position = get_screen_center_position()
		position -= event.relative * pan_speed
	
	# Если есть два касания и разрешено масштабирование, меняем зум камеры.
	elif _touches.size() >= 2 and can_zoom:
		var touch_point_positions = _touches.values()
		point_a.position = get_canvas_transform().affine_inverse() * touch_point_positions[0]
		point_b.position = get_canvas_transform().affine_inverse() * touch_point_positions[1]
		point_center.position = (point_a.position + point_b.position) / 2
		var current_dist = touch_point_positions[0].distance_to(touch_point_positions[1])
		position = position.lerp(point_center.position, 0.01)
		
		var zoom_factor = start_dist / current_dist
		var current_zoom = start_zoom / zoom_factor
		current_zoom.x = clamp(current_zoom.x, min_zoom, max_zoom)
		current_zoom.y = clamp(current_zoom.y, min_zoom, max_zoom)
		zoom = current_zoom

# Начало перемещения камеры.
func start_drag():
	drag_timer.start()

# Обработчик события таймера - начало перемещения.
func _on_timer_timeout():
	print("Start drag")
	if _touches.is_empty():
		return
	is_dragging = true

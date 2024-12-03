extends Node2D

@onready var ray_length_x = get_viewport().size.x * ray_length_x_modifier
@onready var ray_length_y = get_viewport().size.y * ray_length_y_modifier
@onready var camera: CameraManager = $".."  # Убедитесь, что путь к камере верен.

var ray_length_x_modifier = 0.5
var ray_length_y_modifier = 0.5
var move_speed: float = 300.0  # Скорость в пикселях в секунду.

var target_position: Vector2 = Vector2.ZERO  # Целевая позиция для камеры.
var is_camera_moving: bool = false  # Флаг для отслеживания движения камеры.

# Обновляет границы и запускает движение камеры.
func change_camera_bounds(node, visibility):
	print(node.global_position)  # Отладка позиции ноды.

	# Обновляем границы камеры.
	if node.global_position.x < (camera.limit_left + ray_length_x):
		camera.limit_left = node.global_position.x - ray_length_x + (node.size.x / 2 * node.scale.x)
	if node.global_position.x > (camera.limit_right - ray_length_x):
		camera.limit_right = node.global_position.x + ray_length_x - (node.size.x / 2 * node.scale.x)
	if node.global_position.y < (camera.limit_top + ray_length_y):
		camera.limit_top = node.global_position.y - ray_length_y + (node.size.y / 2 * node.scale.y)
	if node.global_position.y > (camera.limit_bottom - ray_length_y):
		camera.limit_bottom = node.global_position.y + ray_length_y - (node.size.y / 2 * node.scale.y)

	# Устанавливаем целевую позицию для плавного движения.
	target_position = node.global_position
	is_camera_moving = true  # Включаем флаг движения.

# Плавное движение камеры в методе _process.
func _process(delta):
	if is_camera_moving:
		# Плавно перемещаем камеру к целевой позиции.
		camera.position = camera.position.move_toward(target_position, move_speed * delta)

		# Если камера достигла целевой позиции, останавливаем движение.
		if camera.position.distance_to(target_position) < 1.0:
			print("Camera reached target position.")  # Отладка.
			is_camera_moving = false  # Отключаем флаг движения.

# Подключаем обработчик сигнала при готовности узла.
func _ready():
	ClickerManager.instance.node_revealed.connect(change_camera_bounds)

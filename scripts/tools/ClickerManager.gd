class_name ClickerManager
extends Node

# Сигналы для уведомления об изменении ресурса и его силы.
signal resource_changed(resource_name, current_value)
signal resource_strength_changed(resource_name, current_value)

# Статическая переменная для хранения экземпляра ClickerManager.
static var instance: ClickerManager

# Перечисление доступных ресурсов.
enum RESOURCE {
	TCOIN,
	TAP
}

# Переменные для отслеживания состояния кликов и силы.
var taps = 0 :
	get:
		return taps  # Возвращаем текущее количество кликов.
	set(value):
		taps = value  # Устанавливаем новое количество кликов.
		#taps_changed.emit(value)  # Возможно, это может быть использовано для отдельного сигнала.

var strength = 1  # Сила кликов.
var tapssecond = 0  # Клики в секунду (для авто-кликов).
var auto = 0  # Количество автоматических кликов.
var resource_dict: Dictionary = {}  # Словарь для хранения информации о ресурсах.
var current_resource_key: int  # Текущий ресурс, с которым работает игрок.

# Функция, вызываемая при готовности узла.
func _ready():
	instance = self  # Сохраняем ссылку на текущий экземпляр.
	
	# Ищем все кнопки ресурсов в сцене.
	for resource_button: ResourceButton in get_tree().get_nodes_in_group("resource_buttons"):
		# Проверяем, есть ли данный ресурс в словаре. Если нет, добавляем его.
		if !resource_dict.has(resource_button.resource_name):
			resource_dict[resource_button.resource_name] = {
				"amount": 0,  # Начальное количество ресурса.
				"strength": { "full": 1 }  # Начальная сила ресурса.
			}
		# Подключаем сигнал к кнопке ресурса для обработки получения ресурса.
		resource_button.gain_resource.connect(_on_resource_gained)

# Получение текущего значения ресурса по его имени.
func get_resource_value(resource_name):
	return resource_dict.get(resource_name).amount

# Обновление значения ресурса и вызов сигнала об изменении.
func update_resource_value(resource_name, value):
	resource_dict.get(resource_name).amount += value  # Увеличиваем значение ресурса.
	# Излучаем сигнал об изменении ресурса.
	resource_changed.emit(resource_name, resource_dict.get(resource_name).amount)

# Обновление силы ресурса на основе источника и нового значения.
func update_resource_strength(resource_name, source, value):
	# Обновляем силу ресурса для конкретного источника.
	resource_dict.get(resource_name).strength[str(source)] = value
	
	# Пересчитываем полную силу ресурса, суммируя значения всех источников.
	for strength_key in resource_dict.get(resource_name).strength:
		if strength_key == "full":
			resource_dict.get(resource_name).strength.full = 1
			continue
		# Добавляем силу от каждого источника к полному значению.
		resource_dict.get(resource_name).strength.full += resource_dict.get(resource_name).strength.get(strength_key)
	
	# Излучаем сигнал об изменении силы ресурса.
	resource_strength_changed.emit(resource_name, resource_dict.get(resource_name).strength.full)

# Обработчик сигнала получения ресурса.
func _on_resource_gained(resource_name):
	current_resource_key = resource_name  # Устанавливаем текущий ключ ресурса.
	# Обновляем количество ресурса с учетом его полной силы.
	update_resource_value(resource_name, resource_dict.get(resource_name).strength.full)

# Функция чтобы доставать из словаря силу клика. Например, чтобы всплывала нужная циферка
func get_resource_strength(resource_name):
	return resource_dict.get(resource_name).strength.full

# Очистка экземпляра при выходе из сцены.
func _exit_tree():
	instance = null

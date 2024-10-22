@tool
class_name GeneratorNode extends SkillNode

signal resource_generated(resource_name, amount)

@export var resource_name_generated: ClickerManager.RESOURCE = ClickerManager.RESOURCE.TCOIN

var generator_timer: Timer
var resource_made: float
var log_timer: Timer  # Таймер для логирования ресурсов

func increase_level(value):
	super(value)
	if generator_timer == null:
		generator_timer = Timer.new()
		add_child(generator_timer)
		generator_timer.timeout.connect(on_generator_timeout)
		generator_timer.start(0.05)  # Вы можете настроить это значение по своему усмотрению

	# Настройка логирования
	if log_timer == null:
		log_timer = Timer.new()
		add_child(log_timer)
		log_timer.timeout.connect(log_resource_amount)
		log_timer.start(60)  # Логирование каждую минуту

func on_generator_timeout():
	resource_made += current_strength * generator_timer.wait_time
	resource_generated.emit(resource_name_generated, int(resource_made))

	# Проверка, чтобы не генерировать 0 ресурсов
	if resource_made > 0:
		resource_made = fmod(resource_made, clamp(round(resource_made), 1, current_strength))

func log_resource_amount():
	# Получаем общее количество сгенерированного ресурса
	var current_amount = ClickerManager.instance.get_resource_value(resource_name_generated)
	LoggerG.add_log("Общее количество ресурса: " + str(current_amount))

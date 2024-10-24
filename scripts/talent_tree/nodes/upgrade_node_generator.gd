@tool
class_name GeneratorNode extends SkillNode

# Сигнал генерации ресурса
signal resource_generated(resource_name, amount)

# Экспортируемая переменная для типа ресурса, который генерируется узлом
@export var resource_name_generated: ClickerManager.RESOURCE = ClickerManager.RESOURCE.TCOIN

# Таймер для генерации ресурса
var generator_timer: Timer
# Сумма ресурса, которая была произведена, но еще не использована
var resource_made: float
var log_timer: Timer  # Таймер для логирования ресурсов

# Увеличение уровня узла
func increase_level(value):
	# Вызов родительской функции для увеличения уровня
	super(value)
	# Инициализация таймера, если он еще не создан
	if generator_timer == null:
		generator_timer = Timer.new()
		add_child(generator_timer)
		# Подключение сигнала таймера к обработчику on_generator_timeout
		generator_timer.timeout.connect(on_generator_timeout)
		generator_timer.start(0.05)  # Вы можете настроить это значение по своему усмотрению

	# Настройка логирования
	if log_timer == null:
		log_timer = Timer.new()
		add_child(log_timer)
		log_timer.timeout.connect(log_resource_amount)
		log_timer.start(60)  # Логирование каждую минуту

# Обработчик срабатывания таймера генерации
func on_generator_timeout():
	# Увеличение произведенного ресурса на основе текущей силы узла и времени ожидания таймера
	resource_made += current_strength * generator_timer.wait_time
	# Генерация ресурса с использованием целочисленного значения произведенного ресурса
	resource_generated.emit(resource_name_generated, int(resource_made))
	# Обновление произведенного ресурса (оставшаяся часть после передачи ресурса)
	if resource_made > 0:
		resource_made = fmod(resource_made, clamp(round(resource_made), 1, current_strength))

func log_resource_amount():
	# Получаем общее количество сгенерированного ресурса
	var current_amount = ClickerManager.instance.get_resource_value(resource_name_generated)
	LoggerG.add_log("Общее количество ресурса: " + str(current_amount))

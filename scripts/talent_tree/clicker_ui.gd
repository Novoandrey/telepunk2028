class_name ClickerUI extends MarginContainer

# Статическая переменная для хранения единственного экземпляра интерфейса ClickerUI.
static var instance: ClickerUI

# UI элементы, которые будут загружены при старте.
@onready var tap_button: ResourceButton = $TapContainer/TapButton
@onready var taps_label = $ClickInfo/VBoxScores/HBoxScore/Score
@onready var taps_strength_label = $ClickInfo/VBoxScores/HBoxTapStrength/TapsStrength
@onready var auto_score_label = $ClickInfo/VBoxScores/HBoxAutoScore/AutoScore
@onready var buy_window: BuyNodeWindow = $BuyWindow

# Текущий ресурс, к которому привязана кнопка.
var current_resource: Dictionary

# Метод, вызываемый при готовности узла.
func _ready():
	# Сохраняем ссылку на текущий экземпляр ClickerUI.
	instance = self
	
	# Получаем информацию о текущем ресурсе.
	current_resource = ClickerManager.instance.resource_dict.get(tap_button.resource_name)
	
	# Подключаемся к сигналам изменения ресурса и его силы.
	ClickerManager.instance.resource_changed.connect(on_resource_changed)
	ClickerManager.instance.resource_strength_changed.connect(on_resource_strength_changed)
	
	# Обновляем значения ресурсов в UI при старте.
	on_resource_changed(tap_button.resource_name, current_resource.amount)
	on_resource_strength_changed(tap_button.resource_name, current_resource.strength.full)

# Открываем окно покупки узла навыков.
func open_node_window(node: SkillNode):
	buy_window.node = node  # Устанавливаем выбранный узел.
	buy_window.show()  # Отображаем окно покупки.

# Обработчик изменения силы нажатия ресурса.
func on_resource_strength_changed(resource_name, amount):
	# Обновляем текст в интерфейсе для отображения текущей силы нажатия.
	taps_strength_label.text = ClickerManager.RESOURCE.keys()[resource_name] + " tap power: " + str(amount)

# Обработчик изменения количества ресурса.
func on_resource_changed(resource_name, amount):
	# Обновляем текст в интерфейсе для отображения текущего количества ресурса.
	taps_label.text = ClickerManager.RESOURCE.keys()[resource_name] + " Score: " + str(amount)
	pass  # Заглушка для возможной будущей логики.

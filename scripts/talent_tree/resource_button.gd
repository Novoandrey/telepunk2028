class_name ResourceButton extends TextureButton

signal gain_resource(resource_name)

@export var resource_name: ClickerManager.RESOURCE = ClickerManager.RESOURCE.TCOIN

func _ready():
	pressed.connect(on_button_pressed)

func on_button_pressed():
	# Измените общий ресурс в ClickerManager
	ClickerManager.instance.update_resource_value(resource_name, 1)  # Предполагается, что каждый клик дает 1 ресурс
	gain_resource.emit(resource_name)
	
	# Получаем общее количество ресурса после клика
	var total_resources = ClickerManager.instance.get_resource_value(resource_name)
	
	LoggerG.add_log("Общее количество: " + str(total_resources))

class_name ResourceButton extends TextureButton

signal gain_resource(resource_name)

@export var resource_name: ClickerManager.RESOURCE = ClickerManager.RESOURCE.TCOIN

func _ready():
	pressed.connect(on_button_pressed)
	pass

func on_button_pressed():
	gain_resource.emit(resource_name)

class_name ActionController

extends Control

@onready var button: TextureButton = $VBoxContainer/TextureButton

var is_selected: bool = false
var action_resource: Action

func _ready():
	button.pressed.connect(_on_texture_button_pressed)
	action_resource.action_activated.connect(unselect_action)

func _on_texture_button_pressed():
	if is_selected:
		unselect_action()
	else:
		select_action()

func select_action():
	print("Action selected")
	action_resource.action_selected.emit(action_resource)
	is_selected = true
	
func unselect_action():
	print("Action unselected")
	action_resource.action_canceled.emit()
	is_selected = false

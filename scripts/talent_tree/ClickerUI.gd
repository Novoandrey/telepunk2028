class_name ClickerUI extends MarginContainer

static var instance: ClickerUI

@onready var tap_button: ResourceButton = $MarginContainer/TapButton
@onready var taps_label = $ClickInfo/VBoxContainer/TapsScore
@onready var taps_strength_label = $ClickInfo/VBoxContainer/TapsStrength
@onready var auto_score_label = $ClickInfo/VBoxContainer/AutoScore
@onready var buy_window: BuyNodeWindow = $BuyWindow

var current_resource: Dictionary

func _ready():
	instance = self
	current_resource = ClickerManager.instance.resource_dict.get(tap_button.resource_name)
	ClickerManager.instance.resource_changed.connect(on_resource_changed)
	ClickerManager.instance.resource_strength_changed.connect(on_resource_strength_changed)
	on_resource_changed(tap_button.resource_name, current_resource.amount)
	on_resource_strength_changed(tap_button.resource_name, current_resource.strength.full)

func open_node_window(node: SkillNode):
	buy_window.node = node
	buy_window.show()

func on_resource_strength_changed(resource_name, amount):
	taps_strength_label.text = ClickerManager.RESOURCE.keys()[resource_name] + " tap power: " + str(amount)

func on_resource_changed(resource_name, amount):
	taps_label.text = ClickerManager.RESOURCE.keys()[resource_name] + ": " + str(amount)
	pass

extends TextureButton
class_name SkillNode

@onready var label = $MarginContainer/Label
@onready var panel = $Panel

@export var strength : int = 1
@export var mult_bool : bool = true
@export var max_level : int = 10

func _ready():
	label.text = "0/" + str(max_level)

var level : int = 0:
	set(value):
		level = value
		label.text = str(level) + "/" + str(max_level)


func _on_skill_node_pressed():
	level = min( level + 1, max_level)
	panel.show_behind_parent = true
	

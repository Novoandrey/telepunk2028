extends Node

signal selected_level_changed(selected_level: PackedScene)

@export var level_list: Array[PackedScene]
@export var load_button: LoadButton
@export var container: Node

var selected_level: PackedScene :
	get:
		return selected_level
	set(value):
		selected_level = value
		selected_level_changed.emit(selected_level)

func  _ready():
	var index = 0
	for scene in level_list:
		var button: Button = Button.new()
		button.pressed.connect(_on_item_selected.bind(index))
		button.text = get_scene_name(scene)
		container.add_child(button)
		index += 1
	if level_list.size() > 0:
		selected_level = level_list[0]
	
func _on_item_selected(index):
	selected_level = level_list[index]

func get_scene_name(scene):
	var instance = scene.instantiate()
	var chapter_name = instance.level_name
	return chapter_name

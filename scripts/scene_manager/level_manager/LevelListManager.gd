extends OptionButton

@export var chapter_list: Array[PackedScene]
@export var load_button: LoadButton

@onready var scene_manager: SceneManager = get_node("/root/SceneManager")
func  _ready():
	for scene in chapter_list:
		add_item(get_scene_name(scene))
	if chapter_list.size() > 0:
		load_button.scene_to_load = chapter_list[0]
	
func _on_item_selected(index):
	load_button.scene_to_load = chapter_list[index]
	pass # Replace with function body.

func get_scene_name(scene):
	var instance = scene.instantiate()
	var chapter_name = instance.level_name
	return chapter_name

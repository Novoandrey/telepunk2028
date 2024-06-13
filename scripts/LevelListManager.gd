extends OptionButton

@onready var level_button: LoadLevel = $"../Arena 1"
@onready var scene_manager: SceneManager = get_node("/root/SceneManager")
func  _ready():
	for level in scene_manager.level_list:
		add_item("Уровень {0}".format({"0": item_count+1}), item_count)
	if scene_manager.level_list.size() > 0:
		level_button.level_to_load = scene_manager.level_list[0]
	
	


func _on_item_selected(index):
	level_button.level_to_load = scene_manager.level_list[index]
	pass # Replace with function body.

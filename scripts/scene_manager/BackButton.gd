extends Button

@onready var scene_manager: SceneManager = get_node("/root/SceneManager")

func _ready():
	pressed.connect(scene_manager.return_to_scene)


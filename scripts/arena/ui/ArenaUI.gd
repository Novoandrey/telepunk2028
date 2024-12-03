extends Control


@onready var action_button_container: Control = $PlayerControl/Margin/VBoxContainer/PlayerActions/HBox
@onready var game_manager: GameManager = GameManager.instance

func _ready():
	action_button_container.get_child(0).show()
	game_manager.critter_selected.connect(on_critter_selected)

func on_critter_selected(_previous_critter, _selected_critter):
	if action_button_container.get_child(0).visible:
		action_button_container.get_child(0).hide()
	
	for child in action_button_container.get_children():
		if child == action_button_container.get_child(0):
			continue
		child.queue_free()
	var _critter_actions: CritterActions = _selected_critter.get_critter_component(CritterActions.get_custom_class_name())
	
	if _critter_actions == null:
		print("This critter can't act")
		action_button_container.get_child(0).show()
		return
	
	for action: Action in _critter_actions._actions:
		var action_button = action.action_button_scene.instantiate()
		action_button.action_resource = action
		action_button_container.add_child(action_button)
		print(action)

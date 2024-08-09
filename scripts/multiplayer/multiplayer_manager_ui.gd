extends Node

@onready var player_name_field = $TextEdit
@onready var side_selection_list = $OptionButton

var player_name: String :
	get:
		return player_name
	set(value):
		player_name = value
		MultiplayerManager.player_info.name = player_name

func _ready():
	MultiplayerManager.remove_multiplayer_peer()
	for side in GameManager.SIDE.keys():
		if side != GameManager.SIDE.find_key(0):
			side_selection_list.add_item(str(side))

func start_server():
	MultiplayerManager.create_game()

func start_client():
	MultiplayerManager.join_game()

func _on_text_edit_text_changed():
	player_name = player_name_field.text 

func _on_option_button_item_selected(index):
	MultiplayerManager.player_info.side = index
	pass # Replace with function body.

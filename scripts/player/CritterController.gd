class_name CritterController

extends Critter

@onready var _camera : CameraManager = CameraManager.instance

var _current_path_prediction: Array
var _current_tile_prediction: Vector2i :
	get:
		return _current_tile_prediction
	set(value):
		if _current_tile_prediction != value:
			_current_tile_prediction = value
var _current_action_tiles_range: Array
var _current_action_tiles_area: Array
var _current_movement_tiles: Array

func _ready():
	super()
	add_to_group("players")

func _unhandled_input(event):
	if is_selected:
		if event.is_action_pressed("ui_action") and has_critter_component(CritterActions.get_custom_class_name()):
			var actions = get_critter_component(CritterActions.get_custom_class_name())
			var target = GameManager.instance.get_critter_at_position(get_global_mouse_position())
			actions.ready_action(target)

func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("ui_action"):
		GameManager.instance._selected_critter = self

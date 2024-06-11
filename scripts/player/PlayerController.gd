extends Critter

@export var _animation: AnimatedSprite2D
@export var _path_line: Line2D

var _current_path_prediction: Array
var _current_tile_prediction: Vector2i :
	get:
		return _current_tile_prediction
	set(value):
		if _current_tile_prediction != value:
			draw_prediction(value)
			_current_tile_prediction = value

func _ready():
	global_position = tilemap.map_to_local(tilemap.local_to_map(global_position))
	_currentHealth = _health
	_animation.play(_state.to_lower())

func _physics_process(delta):
	if(!_current_path_prediction.is_empty()):
		pass
	if(_current_path.is_empty()):
		return
	var target_position = tilemap.map_to_local(_current_path.front())
	global_position = global_position.move_toward(target_position, 5)
	
	_current_tile = tilemap.local_to_map(global_position)
	if global_position == target_position:
		print(_current_path)
		draw_prediction(_current_path.back())
		_current_path.pop_front()
		if(_current_path.is_empty()):
			_state = state_names[State.IDLE]
			_animation.play(_state.to_lower())

func _input(event):
	var mouse_pos = get_viewport().get_mouse_position()
	if event.is_action_pressed("ui_action"):
		print("Clicked on {pos}".format({"pos": mouse_pos}))
		if tilemap.get_cell_tile_data(1, tilemap.local_to_map(mouse_pos)):
			return
		_current_path = tilemap.set_player_path(
				tilemap.local_to_map(global_position),
				tilemap.local_to_map(mouse_pos)
			).slice(1)
		print(_current_path)
		_state = state_names[State.WALK]
		_animation.play(_state.to_lower())
			
	_current_tile_prediction = tilemap.local_to_map(mouse_pos)
	
func draw_prediction(_current_tile_prediction):
	_path_line.clear_points()
	_path_line.add_point(global_position)
	var path_points = tilemap.set_player_path(
					tilemap.local_to_map(global_position),
					_current_tile_prediction).slice(1)
	for point in path_points:
		_path_line.add_point(tilemap.map_to_local(point))
	_path_line.get_point_count()

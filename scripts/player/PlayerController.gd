class_name PlayerController

extends Critter

#@export var _animation: AnimatedSprite2D
@onready var _path_line: Line2D = get_node("/root/ArenaScene/BattleArena/Line2D")

var _current_path_prediction: Array
var _current_tile_prediction: Vector2i :
	get:
		return _current_tile_prediction
	set(value):
		if _current_tile_prediction != value:
			draw_prediction(value)
			_current_tile_prediction = value
var _current_action_tiles_range: Array
var _current_action_tiles_area: Array
var _currnet_movement_tiles: Array

func _ready():
	gameManager._playerCritter = self
	Current_MovePoints_On_Value_Changed.connect(available_movement_tiles_update)
	global_position = tilemap.to_global(tilemap.map_to_local(tilemap.local_to_map(tilemap.to_local(global_position))))
	_current_tile = tilemap.local_to_map(tilemap.to_local(global_position))
	_currentMovePoints = _movePoints

func _physics_process(delta):
	if(!_current_path_prediction.is_empty()):
		pass
	if(_current_path.is_empty()):
		return
	var target_position = tilemap.to_global(tilemap.map_to_local(_current_path.front()))
	global_position = global_position.move_toward(target_position, 5)
	
	_current_tile = tilemap.local_to_map(tilemap.to_local(global_position))
	if global_position == target_position:
		print(_current_path)
		draw_prediction(_current_path.back())
		_currentMovePoints -= 1
		_current_path.pop_front()
		if(_current_path.is_empty()):
			_state = state_names[State.IDLE]
			animation_tree["parameters/conditions/isIdle"] = true
			animation_tree["parameters/conditions/isMoving"] = false
#Управление действиями игрока
func _unhandled_input(event):
	var mouse_pos = get_viewport().get_mouse_position()
	if _currentAction == null:
		_current_tile_prediction = tilemap.local_to_map(tilemap.to_local(mouse_pos))
	else:
		_current_tile_prediction = tilemap.local_to_map(tilemap.to_local(mouse_pos))
		available_action_area()
	if tilemap.get_cell_tile_data(1, tilemap.local_to_map(tilemap.to_local(mouse_pos))):
		return
	if event.is_action_pressed("ui_action"):
		print("Clicked on {pos}".format({"pos": mouse_pos}))
		print(tilemap.to_local(mouse_pos))
		if _currentAction != null: #Совершение действия
			var target_cell = tilemap.local_to_map(tilemap.to_local(mouse_pos))
			if available_action_tile(_currentAction._range).has(target_cell):
				_currentAction.activate(target_cell)
		#Перемещение
		elif _currentMovePoints > 0 and tilemap.astar.has_point(tilemap.get_id_for_point(tilemap.local_to_map(tilemap.to_local(mouse_pos)))) and !tilemap.astar.is_point_disabled(tilemap.get_id_for_point(tilemap.local_to_map(tilemap.to_local(mouse_pos)))):
			_current_path = tilemap.set_player_path(
					tilemap.local_to_map(tilemap.to_local(global_position)),
					tilemap.local_to_map(tilemap.to_local(mouse_pos))
				).slice(1, _currentMovePoints+1)
			print(_current_path)
			_state = state_names[State.WALK]
			animation_tree["parameters/conditions/isIdle"] = false
			animation_tree["parameters/conditions/isMoving"] = true
	
func draw_prediction(_current_tile_prediction):
	_path_line.clear_points()
	if !tilemap.astar.has_point(tilemap.get_id_for_point(_current_tile_prediction)) or tilemap.astar.is_point_disabled(tilemap.get_id_for_point(_current_tile_prediction)) or _currentAction != null:
		return
	_path_line.add_point(global_position)
	var path_points = tilemap.set_player_path(
					tilemap.local_to_map(tilemap.to_local(global_position)),
					_current_tile_prediction).slice(1)
	for point in path_points:
		if _path_line.get_point_count() > _currentMovePoints:
			break;
		_path_line.add_point(tilemap.to_global(tilemap.map_to_local(point)))
	_path_line.get_point_count()
	
	
func available_movement_tiles_update(previousValue, currentValue):
	if _currentAction != null:
		return
	tilemap.clear_layer(-1)
	var tiles_to_highlight: Array[Vector2i]
	var current_tiles_to_highlight: Array[Vector2i] = [_current_tile]
	for i in range(currentValue):
		for tile in current_tiles_to_highlight:
			for cell in tilemap.get_surrounding_cells(tile):
				if tilemap.get_cell_tile_data(1, cell) or tilemap.get_cell_tile_data(-1, cell) or tilemap.get_cell_source_id(0, cell) == -1 or cell == _current_tile:
					continue
				if gameManager.get_critter_at_cell(cell) != null:
					continue
				tilemap.set_cell(-1, cell, 5, Vector2i(0,0))
				tiles_to_highlight.append(cell)
		current_tiles_to_highlight = tiles_to_highlight
		tiles_to_highlight = []

func available_movement_tiles():
	if _currentAction != null:
		return
	tilemap.clear_layer(-1)
	var tiles_to_highlight: Array[Vector2i]
	var current_tiles_to_highlight: Array[Vector2i] = [_current_tile]
	for i in range(_currentMovePoints):
		for tile in current_tiles_to_highlight:
			for cell in tilemap.get_surrounding_cells(tile):
				if tilemap.get_cell_tile_data(1, cell) or tilemap.get_cell_tile_data(-1, cell) or tilemap.get_cell_source_id(0, cell) == -1 or cell == _current_tile:
					continue
				if gameManager.get_critter_at_cell(cell) != null:
					continue
				tilemap.set_cell(-1, cell, 5, Vector2i(0,0))
				tiles_to_highlight.append(cell)
		current_tiles_to_highlight = tiles_to_highlight
		tiles_to_highlight = []

func available_action_tile(ability_range) -> Array:
	tilemap.clear_layer(-1)
	var tiles_to_highlight: Array[Vector2i]
	var current_tiles_to_highlight: Array[Vector2i] = [_current_tile]
	for i in range(ability_range):
		for tile in current_tiles_to_highlight:
			for cell in tilemap.get_surrounding_cells(tile):
				if tilemap.get_cell_tile_data(1, cell) or tilemap.get_cell_tile_data(-1, cell) or tilemap.get_cell_source_id(0, cell) == -1 or cell == _current_tile:
					continue
				tilemap.set_cell(-1, cell, 5, Vector2i(1,0))
				tiles_to_highlight.append(cell)
		current_tiles_to_highlight = tiles_to_highlight
		tiles_to_highlight = []
	
	return tilemap.get_used_cells(-1)
	
func available_action_area():
	if _currentAction._area == 0:
		return
	tilemap.clear_layer(-1)
	var tiles_to_highlight: Array[Vector2i]
	var current_tiles_to_highlight: Array[Vector2i] = [_current_tile_prediction]
	for i in range(_currentAction._area):
		for tile in current_tiles_to_highlight:
			for cell in tilemap.get_surrounding_cells(tile):
				if tilemap.get_cell_tile_data(1, cell) or tilemap.get_cell_tile_data(-1, cell) or tilemap.get_cell_source_id(0, cell) == -1 or cell == _current_tile:
					continue
				tilemap.set_cell(-1, cell, 5, Vector2i(1,0))
				tiles_to_highlight.append(cell)
		current_tiles_to_highlight = tiles_to_highlight
		tiles_to_highlight = []
	
	return tilemap.get_used_cells(-1)
	pass

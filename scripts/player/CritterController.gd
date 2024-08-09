class_name CritterController

extends Critter

@onready var _path_line: Line2D = $Line2D
@onready var _camera : CameraManager = get_node("../../Camera2D")

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
var _current_movement_tiles: Array

func _ready():
	super()
	add_to_group("players")
	_path_line.scale = _path_line.scale / scale
	current_movePoints_on_value_changed.connect(available_movement_tiles_update)
	available_movement_tiles()

func _process(delta):
	if multiplayer.is_server():
		move()
	
#Управление действиями игрока
func _unhandled_input(event):
	if multiplayer.multiplayer_peer.get_unique_id() != owner_id:
		return
	
	var mouse_pos = get_global_mouse_position()
	
	if is_selected:

		if !tilemap.has_nav_point(mouse_pos) or _camera.is_dragging == true:
			return
		
		_current_tile_prediction = tilemap_point_position(mouse_pos)
		
		if _currentAction != null:
			available_action_area()
		
		if event.is_action_released("ui_action"):
			#Перемещение
			use_movement.rpc_id(1,mouse_pos)
			#Совершение действия
			use_action.rpc_id(1,mouse_pos)
	elif event.is_action_released("ui_action"):
		print(multiplayer)
		select_critter(mouse_pos)

	
#Совершение действия игрока
@rpc("any_peer", "call_local", "reliable")
func use_action(mouse_pos):
	if _currentAction != null: 
		var target_cell = tilemap.local_to_map(tilemap.to_local(mouse_pos))
		if available_action_tile(_currentAction._range).has(target_cell):
			_currentAction.activate(target_cell)

#Действие для перемещения игрока
@rpc("any_peer", "call_local", "reliable")
func use_movement(mouse_pos):
	if _currentMovePoints > 0 and tilemap.has_nav_point(mouse_pos) and tilemap.point_enabled(mouse_pos) and _currentAction == null and tilemap_point_position(mouse_pos) != _current_tile:
		if _path_line.get_point_count() > _currentMovePoints + 1:
			return
		_current_path = tilemap.set_player_path(
				tilemap.local_to_map(tilemap.to_local(global_position)),
				tilemap.local_to_map(tilemap.to_local(mouse_pos))
			).slice(1, _currentMovePoints+1)
		_state = state_names[State.WALK]
		animation_tree["parameters/conditions/isIdle"] = false
		animation_tree["parameters/conditions/isMoving"] = true

func select_critter(mouse_pos):
	var target_cell = tilemap.local_to_map(tilemap.to_local(mouse_pos))
	var target = gameManager.get_critter_at_cell(target_cell)
	if target != null and target.owner_id == multiplayer.get_unique_id():
		gameManager._selected_critter = target

#Перемещение игрока
func move():
	if(_current_path.is_empty()):
		return
	_path_line.global_position = tilemap.to_global(tilemap.map_to_local(_current_tile))
	is_moving = true
	var target_position = tilemap.to_global(tilemap.map_to_local(_current_path.front()))
	global_position = global_position.move_toward(target_position, _moveSpeed)
	
	if global_position == target_position:
		_path_line.position = Vector2(0,0)
		_current_tile = get_current_tile()
		draw_prediction(_current_tile)
		_currentMovePoints -= 1
		_current_path.pop_front()
		if(_current_path.is_empty()):
			_state = state_names[State.IDLE]
			animation_tree["parameters/conditions/isIdle"] = true
			animation_tree["parameters/conditions/isMoving"] = false
			is_moving = false

@rpc("authority", "call_local", "reliable")
func update_tile():
	pass

func move_prediction():
	pass

	
func draw_prediction(_current_tile_prediction):
	_path_line.clear_points()
	if !tilemap.has_nav_tile_point(_current_tile_prediction) or tilemap.astar.is_point_disabled(tilemap.get_id_for_point(_current_tile_prediction)) or _currentAction != null:
		return
	_path_line.add_point(_path_line.position)
	var path_points = tilemap.set_player_path(
					tilemap.local_to_map(tilemap.to_local(global_position)),
					_current_tile_prediction).slice(1)
	for point in path_points:
		#if _path_line.get_point_count() > _currentMovePoints:
			#break;
		_path_line.add_point(_path_line.to_local(tilemap.to_global(tilemap.map_to_local(point))))
	_path_line.get_point_count()

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

func tilemap_point_position(mouse_position):
	return tilemap.local_to_map(tilemap.to_local(mouse_position))


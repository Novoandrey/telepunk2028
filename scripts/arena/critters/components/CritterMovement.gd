class_name CritterMovement extends CritterComponent

static var component_name: String

signal critter_move(start_position, end_position)

enum MOVING {
	STOPPED,
	WILLING,
	FORCED
}

var navigation_map: TileMapManager = TileMapManager.instance
var past_position: Vector2i
var critter_path: Array :
	get:
		return critter_path
	set(value):
		critter_path = value
		critter_move.emit(critter_path.front(), critter_path.back())
var speed_mod: float = 5
var is_moving: MOVING = MOVING.STOPPED

func _ready():
	component_name = "CritterMovement"

static func get_custom_class_name() -> String:
	return component_name

func move_critter(_target):
	print(_target)
	var _new_path = navigation_map.set_player_path(
				critter._current_tile,
				_target).slice(1)
	critter_path = _new_path
	print(_new_path)
	past_position = critter._current_tile
	critter._state = Critter.State.MOVING
	is_moving = MOVING.WILLING

func force_move_critter(push_origin, _direction, _distance, _push_speed):
	if push_origin == critter._current_tile:
		match _direction:
			MovementForced.MOVE_DIRECTION.RIGHT:
				critter_path = TileMapManager.instance.get_straight_path(push_origin, Vector2i(1,1), _distance)
			MovementForced.MOVE_DIRECTION.LEFT:
				critter_path = TileMapManager.instance.get_straight_path(push_origin, Vector2i(-1,-1), _distance)
			MovementForced.MOVE_DIRECTION.UP & MovementForced.MOVE_DIRECTION.LEFT:
				critter_path = TileMapManager.instance.get_straight_path(push_origin, Vector2i(0,-1), _distance)
			MovementForced.MOVE_DIRECTION.UP & MovementForced.MOVE_DIRECTION.RIGHT:
				critter_path = TileMapManager.instance.get_straight_path(push_origin, Vector2i(1,0), _distance)
			MovementForced.MOVE_DIRECTION.DOWN & MovementForced.MOVE_DIRECTION.LEFT:
				critter_path = TileMapManager.instance.get_straight_path(push_origin, Vector2i(-1,0), _distance)
			MovementForced.MOVE_DIRECTION.DOWN & MovementForced.MOVE_DIRECTION.RIGHT:
				critter_path = TileMapManager.instance.get_straight_path(push_origin, Vector2i(0,1), _distance)
	else:
		match _direction:
			MovementForced.MOVE_DIRECTION.RIGHT:
				critter_path = TileMapManager.instance.get_straight_path(critter._current_tile, Vector2i(1,1), _distance)
			MovementForced.MOVE_DIRECTION.LEFT:
				critter_path = TileMapManager.instance.get_straight_path(critter._current_tile, Vector2i(-1,-1), _distance)
			MovementForced.MOVE_DIRECTION.UP & MovementForced.MOVE_DIRECTION.LEFT:
				critter_path = TileMapManager.instance.get_straight_path(critter._current_tile, Vector2i(0,-1), _distance)
			MovementForced.MOVE_DIRECTION.UP & MovementForced.MOVE_DIRECTION.RIGHT:
				critter_path = TileMapManager.instance.get_straight_path(critter._current_tile, Vector2i(1,0), _distance)
			MovementForced.MOVE_DIRECTION.DOWN & MovementForced.MOVE_DIRECTION.LEFT:
				critter_path = TileMapManager.instance.get_straight_path(critter._current_tile, Vector2i(-1,0), _distance)
			MovementForced.MOVE_DIRECTION.DOWN & MovementForced.MOVE_DIRECTION.RIGHT:
				critter_path = TileMapManager.instance.get_straight_path(critter._current_tile, Vector2i(0,1), _distance)
			MovementForced.MOVE_DIRECTION.TO_ACTOR:
				critter_path = TileMapManager.instance.get_straight_path(critter._current_tile, Vector2i(push_origin - critter._current_tile).sign(), _distance)
			MovementForced.MOVE_DIRECTION.FROM_ACTOR:
				critter_path = TileMapManager.instance.get_straight_path(critter._current_tile, Vector2i(critter._current_tile - push_origin ).sign(), _distance)
	is_moving = MOVING.FORCED
	critter._state = Critter.State.HURT

func teleport_critter(_target):
	critter.global_position = _target
	pass

func _process(_delta):
	move(_delta)
	force_move(_delta)

func move(_delta):
	if critter_path.is_empty() or is_moving != MOVING.WILLING:
		return
	
	var target_position = navigation_map.to_global(navigation_map.map_to_local(critter_path.front()))
	critter.global_position = critter.global_position.move_toward(target_position, 
		navigation_map.to_global(navigation_map.map_to_local(critter._current_tile)).distance_to(target_position) 
		* _delta * speed_mod)
	
	print("Moving")
	
	if critter.global_position == target_position:
		critter.set_critter_position()
		critter_path.pop_front()
		if(critter_path.is_empty()):
			critter._state = Critter.State.IDLE
			is_moving = MOVING.STOPPED
			print(critter._current_tile)

func force_move(_delta):
	if critter_path.is_empty() or is_moving != MOVING.FORCED:
		return
	
	var target_position = navigation_map.to_global(navigation_map.map_to_local(critter_path.front()))
	if GameManager.instance.get_critter_at_position(target_position) is Vector2i or GameManager.instance.get_critter_at_position(target_position) == critter:
		critter.global_position = critter.global_position.move_toward(target_position, 
			navigation_map.to_global(navigation_map.map_to_local(critter._current_tile)).distance_to(target_position) 
			* _delta * speed_mod)
	else:
		critter_path.clear()
		critter._state = Critter.State.IDLE
		is_moving = MOVING.STOPPED
	
	if critter.global_position == target_position:
		critter.set_critter_position()
		critter_path.pop_front()
		if(critter_path.is_empty()):
			critter._state = Critter.State.IDLE
			is_moving = MOVING.STOPPED
			print(critter._current_tile)

func shift_back():
	pass

func cancel_movement():
	critter._current_tile = past_position

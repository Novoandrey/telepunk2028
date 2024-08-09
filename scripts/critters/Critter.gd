class_name Critter

extends CharacterBody2D

enum State {
	IDLE = 0,
	WALK = 1
}

enum CRITTER_TYPE{
	PLAYER = 0,
	ENEMY = 1,
}

const state_names := ["IDLE", "WALK"]
signal current_health_on_value_changed(previousValue, currentValue)
signal current_movePoints_on_value_changed(previousValue, currentValue)
signal current_actionPoints_on_value_changed(previousValue, currentValue)
signal current_action_on_value_changed(previousValue, currentValue)


@onready var gameManager: GameManager = get_node("../../GameManager")
@onready var animation_tree: AnimationTree = $AnimationTree

@export var _health: int = 0
@export var _actionPoints: int = 4
@export var _movePoints: int = 4
@export var _moveSpeed: float = 5
@export var _critterType: CRITTER_TYPE = CRITTER_TYPE.PLAYER

var tilemap: TileMapManager
var owner_id: int = 1
var _currentAction: Action :
	get:
		return _currentAction
	set(value):
		current_action_on_value_changed.emit(_currentAction, value)
		_currentAction = value

@onready var _currentHealth: int = _health :
	get:
		return _currentHealth
	set(value):
		current_health_on_value_changed.emit(_currentHealth, value)
		_currentHealth = value
var _state: String = state_names[State.IDLE]
@onready var _currentActionPoints: int = _actionPoints :
	get: 
		return _currentActionPoints
	set(value):
		current_actionPoints_on_value_changed.emit(_currentActionPoints, value)
		_currentActionPoints = value
@onready var _currentMovePoints: int = _movePoints :
	get:
		return _currentMovePoints
	set(value):
		current_movePoints_on_value_changed.emit(_currentMovePoints, value)
		_currentMovePoints = value
var _current_path: Array :
	get:
		return _current_path
	set (value):
		_current_path = value
var _current_tile: Vector2i :
	get:
		return _current_tile
	set(value):
		if _current_tile != value:
			_current_tile = value
@onready var is_moving: bool = false

func _ready():
	global_position = get_arena_position()
	_current_tile = get_current_tile()
	_currentMovePoints = _movePoints
	gameManager.arena_critter.append(self)
	if _critterType == CRITTER_TYPE.ENEMY:
		gameManager._enemyCritters.append(self)
	elif _critterType == CRITTER_TYPE.PLAYER:
		gameManager._playerCritter = self

func refresh_actions():
	_currentActionPoints = _actionPoints
	_currentMovePoints = _movePoints	

func get_arena_position():
	return tilemap.to_global(tilemap.map_to_local(tilemap.local_to_map(tilemap.to_local(global_position))))
	
func get_current_tile():
	return tilemap.local_to_map(tilemap.to_local(global_position))

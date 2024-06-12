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
signal Current_Health_On_Value_Changed(previousValue, currentValue)
signal Current_MovePoints_On_Value_Changed(previousValue, currentValue)
signal Current_ActionPoints_On_Value_Changed(previousValue, currentValue)
signal Current_Action_On_Value_Changed(previousValue, currentValue)

@onready var tilemap: TileMap = get_node("/root/ArenaScene/BattleArena/Environment/TileMap")
@onready var gameManager: GameManager = get_node("/root/ArenaScene/GameManager")
@onready var animation_tree: AnimationTree = get_node("AnimationTree")

@export var _health: int = 0
@export var _actionPoints: int
@export var _movePoints: int
@export var _critterType: CRITTER_TYPE

var _currentAction: Action :
	get:
		return _currentAction
	set(value):
		Current_Action_On_Value_Changed.emit(_currentAction, value)
		_currentAction = value

@onready var _currentHealth: int = _health :
	get:
		return _currentHealth
	set(value):
		Current_Health_On_Value_Changed.emit(_currentHealth, value)
		_currentHealth = value
var _state: String = state_names[State.IDLE]
@onready var _currentActionPoints: int = _actionPoints :
	get: 
		return _currentActionPoints
	set(value):
		Current_ActionPoints_On_Value_Changed.emit(_currentActionPoints, value)
		_currentActionPoints = value
@onready var _currentMovePoints: int = _movePoints :
	get:
		return _currentMovePoints
	set(value):
		Current_MovePoints_On_Value_Changed.emit(_currentMovePoints, value)
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

func _ready():
	_current_tile = tilemap.local_to_map(global_position)
	gameManager._enemyCritters.append(self)

func refresh_actions():
	_currentActionPoints = _actionPoints
	_currentMovePoints = _movePoints	

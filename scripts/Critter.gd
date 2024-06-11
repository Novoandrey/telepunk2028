class_name Critter

extends CharacterBody2D

enum State {
	IDLE = 0,
	WALK = 1
}

const state_names := ["IDLE", "WALK"]
signal Current_Health_On_Value_Changed(previousValue, currentValue);

@export var tilemap: TileMap

@export var _health: int = 0
@export var _actionPoints: int
@export var _movePoints: int

var _currentHealth: int = 0 :
	get:
		return _currentHealth
	set(value):
		Current_Health_On_Value_Changed.emit(_currentHealth, value)
		_currentHealth = value
		print(_currentHealth)
var _state: String = state_names[State.IDLE]
var _current_path: Array
var _current_tile: Vector2i :
	get:
		return _current_tile
	set(value):
		if _current_tile != value:
			_current_tile = value
		

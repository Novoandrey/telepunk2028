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
const UNSELECTED: Color = Color(0, 0, 125)
const SELECTED: Color = Color(0, 150, 255)
const ALLY: Color = Color(0, 125, 0)
const ENEMY: Color = Color(125, 0, 0)

signal current_health_on_value_changed(previousValue, currentValue)
signal current_movePoints_on_value_changed(previousValue, currentValue)
signal current_actionPoints_on_value_changed(previousValue, currentValue)
signal current_action_on_value_changed(previousValue, currentValue)

@onready var tilemap: TileMapManager = get_node("../Environment/TileMap")
@onready var gameManager: GameManager = get_node("../../GameManager")
@onready var animation_tree: AnimationTree = $AnimationTree

@export var _critter_name: String = "dummy"
@export var _health: int = 0
@export var _actionPoints: int = 4
@export var _movePoints: int = 4
@export var _moveSpeed: float = 5
@export var _critterType: CRITTER_TYPE = CRITTER_TYPE.PLAYER
@export var critter_side: GameManager.SIDE = GameManager.SIDE.ENEMY
@export var owner_id: int = 0 :
	get:
		return owner_id
	set(value):
		owner_id = value
		print("Critter owner " + str(value))
		print("Player id " + str(MultiplayerManager.player_id))
		if owner_id == MultiplayerManager.player_id:
			$Sprite2D.material.set_shader_parameter("outline_color", UNSELECTED)
		elif critter_side == MultiplayerManager.players[MultiplayerManager.player_id].side:
			$Sprite2D.material.set_shader_parameter("outline_color", ALLY)
		else:
			$Sprite2D.material.set_shader_parameter("outline_color", ENEMY)

var _state: String = state_names[State.IDLE]

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
var _current_tile: Vector2i:
	get:
		return _current_tile
	set(value):
		if _current_tile != value:
			if tilemap.astar.has_point(tilemap.get_id_for_point(_current_tile)):
				tilemap.astar.set_point_disabled(tilemap.get_id_for_point(_current_tile), false)
			if multiplayer.get_unique_id() != owner_id:
				tilemap.astar.set_point_disabled(tilemap.get_id_for_point(value))
			_current_tile = value
			
@onready var is_moving: bool = false
@onready var is_selected: bool = false :
	get:
		return is_selected
	set(value):
		is_selected = value
		print(multiplayer)
		if is_selected:
			$Sprite2D.material.set_shader_parameter("outline_color", SELECTED)
		else:
			$Sprite2D.material.set_shader_parameter("outline_color", UNSELECTED)

func _ready():
	add_to_group("critters")
	if !gameManager.arena_critters.has(critter_side):
		gameManager.arena_critters[critter_side] = [self]
	else:
		gameManager.arena_critters[critter_side].append(self)
	call_deferred("set_critter_position")

func set_critter_position():
	global_position = get_arena_position()
	_current_tile = get_current_tile()
	_currentMovePoints = _movePoints
	pass

func refresh_actions(): ##
	_currentActionPoints = _actionPoints
	_currentMovePoints = _movePoints	

func get_arena_position():
	return tilemap.to_global(tilemap.map_to_local(tilemap.local_to_map(tilemap.to_local(global_position))))
	
func get_current_tile(): ##Получить координату текущего тайла
	return tilemap.local_to_map(tilemap.to_local(global_position))
	
func update_shader():
	if owner_id == MultiplayerManager.player_id:
		$Sprite2D.material.set_shader_parameter("outline_color", UNSELECTED)
	elif critter_side == MultiplayerManager.players[MultiplayerManager.player_id].side:
		$Sprite2D.material.set_shader_parameter("outline_color", ALLY)
	else:
		$Sprite2D.material.set_shader_parameter("outline_color", ENEMY)

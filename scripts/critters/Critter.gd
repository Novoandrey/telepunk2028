class_name Critter

extends CharacterBody2D

enum State {
	IDLE,
	MOVING,
	ATTACK_01,
	DISABLED,
	HURT
}

enum CRITTER_TYPE{
	PLAYER = 0,
	ENEMY = 1,
} 

const UNSELECTED: Color = Color(0, 0, 125)
const SELECTED: Color = Color(0, 150, 255)
const ALLY: Color = Color(0, 125, 0)
const ENEMY: Color = Color(125, 0, 0)

signal current_health_on_value_changed(previousValue, currentValue)
signal current_movePoints_on_value_changed(previousValue, currentValue)
signal current_actionPoints_on_value_changed(previousValue, currentValue)
signal current_action_on_value_changed(previousValue, currentValue)

@onready var tilemap: TileMapManager = TileMapManager.instance
@onready var gameManager: GameManager = GameManager.instance
@onready var animation_tree: AnimationTree = $AnimationTree

@export var _critter_name: String = "dummy"
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

var _state: State = State.IDLE

var critter_component_list: Dictionary

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
	for child in get_children():
		if child is CritterComponent:
			critter_component_list[child.get_custom_class_name()] = child
	if !gameManager.arena_critters.has(critter_side):
		gameManager.arena_critters[critter_side] = [self]
	else:
		gameManager.arena_critters[critter_side].append(self)
	call_deferred("set_critter_position")

func has_critter_component(component_name: String) -> bool:
	if critter_component_list.has(component_name):
		return true
	return false

func get_critter_component(component_name: String):
	return critter_component_list.get(component_name)

func set_critter_position():
	_current_tile = TileMapManager.instance.get_cell_from_position(global_position)
	
func update_outline():
	if owner_id == MultiplayerManager.player_id:
		$Sprite2D.material.set_shader_parameter("outline_color", UNSELECTED)
	elif critter_side == MultiplayerManager.players[MultiplayerManager.player_id].side:
		$Sprite2D.material.set_shader_parameter("outline_color", ALLY)
	else:
		$Sprite2D.material.set_shader_parameter("outline_color", ENEMY)

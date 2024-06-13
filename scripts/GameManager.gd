class_name GameManager

extends Node

@onready var tilemap: TileMapManager = get_node("/root/ArenaScene/BattleArena/Environment/TileMap")
@onready var sceneManager: SceneManager = get_node("/root/SceneManager")
var action_buttons: Array

signal Player_Critter_Added(_playerCritter)

var _enemyCritters: Array
var _playerCritter :
	get:
		return _playerCritter
	set(value):
		Player_Critter_Added.emit(value)
		_playerCritter = value	

func switch_turns():
	_playerCritter.refresh_actions()
	for _critter in _enemyCritters:
		tilemap.astar.set_point_disabled(tilemap.get_id_for_point(_critter._current_tile))

func get_critter_at_cell(cell) -> Critter:
	for critter in _enemyCritters:
		if critter._current_tile == cell:
			return critter
	return null

func return_to_menu():
	sceneManager.switch_scenes(preload("res://scenes/game.tscn"), get_parent())
	pass

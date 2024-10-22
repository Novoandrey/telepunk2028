class_name GameManager

extends Node

static var instance: GameManager

enum SIDE {
	ENEMY = 0,
	TEAM_1 = 1,
	TEAM_2 = 2,
	TEAM_3 = 3,
	TEAM_4 = 4
}

@onready var tilemap: TileMapManager = TileMapManager.instance
@onready var logger_scene = preload("res://scripts/logger/loggerG.gd")
var logger  # Переменная для логгера

signal critter_selected(_previous_critter, _selected_critter)

@export var _turn_order: Array[SIDE]
var arena_critters: Dictionary
var _current_team: SIDE = SIDE.TEAM_1
var _players_to_act: Dictionary
var can_select_critters: bool = true

var _selected_critter: Critter:
	get:
		return _selected_critter
	set(value):
		critter_selected.emit(_selected_critter, value)
		if _selected_critter != null:
			_selected_critter.is_selected = false
		_selected_critter = value
		_selected_critter.is_selected = true

func _ready():
	instance = self
	logger = logger_scene.new()  # Создаем экземпляр логгера
	get_tree().get_root().add_child(logger)  # Добавляем логгер в корень дерева узлов
	call_deferred("configure_game")

func configure_game():
	if multiplayer.is_server():
		var spawners = get_tree().get_nodes_in_group("spawners")
		var current_index = 0
		var players_id = [multiplayer.multiplayer_peer.get_unique_id()]
		players_id.append_array(multiplayer.get_peers())
		for spawn_point in spawners:
			if spawn_point.critter_type == Critter.CRITTER_TYPE.PLAYER:
				if current_index >= players_id.size():
					continue
				var peer_id = players_id[current_index]
				spawn_point.spawn_critter(MultiplayerManager.players[peer_id])
				current_index += 1
			else:
				spawn_point.spawn_critter()

		print(get_tree().get_nodes_in_group("spawners"))
		for _critter in arena_critters[_current_team]:
			_players_to_act[_critter.owner_id] = false

func switch_turns():
	switch_turns_rpc.rpc_id(1)

@rpc("any_peer", "call_local", "reliable")
func switch_turns_rpc():
	if _players_to_act.has(multiplayer.get_remote_sender_id()):
		_players_to_act[multiplayer.get_remote_sender_id()] = !_players_to_act[multiplayer.get_remote_sender_id()]
	
	for _player_turn_end in _players_to_act.values():
		if !_player_turn_end:
			print("Waiting for other player")
			return
	
	_players_to_act = {}
	for _critter in arena_critters[_current_team]:
		_players_to_act[_critter.owner_id] = false

func get_critter_at_cell(cell) -> Critter:
	for team_key in arena_critters:
		for critter in arena_critters.get(team_key):
			if critter._current_tile == cell:
				return critter
	return null

func get_critter_at_position(position):
	var cell: Vector2i = TileMapManager.instance.get_cell_from_position(position)
	for team_key in arena_critters:
		for critter in arena_critters.get(team_key):
			if critter._current_tile == cell:
				return critter
	return cell

func log_scene_change(old_scene: String, new_scene: String):
	var log_message = "Смена сцены: " + old_scene + " -> " + new_scene
	if logger:
		logger.add_log(log_message)
	else:
		print("Logger is not work")

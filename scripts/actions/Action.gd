class_name Action

extends Node

@onready var _actionHint: Label = get_node("/root/ArenaScene/UI/ActionHint")
@onready var _player = get_node("../")

@export var _cost: int
@export var _area: int
@export var _range: int
@export var _damage: int
@export var _actionHintText: String
@export var _animation: Critter.State


func _ready():
	_actionHint.text = _actionHintText
	_player._currentAction = self
	_player.available_action_tile(_range)

func activate(target):
	pass

func _exit_tree():
	_player._currentAction = null
	_player.available_movement_tiles()
	_actionHint.text = ""

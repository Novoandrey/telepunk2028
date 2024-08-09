class_name Action

extends Node

@onready var _owner:Critter = get_node("../")

@export var _area: int
@export var _range: int
@export var _damage: int
@export var _actionHintText: String
@export var _animation: Critter.State
@export var require_visual: bool = true
@export var end_turn: bool = true

signal on_action_used()

var action_resource: ActionController

func _ready():
	_owner._currentAction = self
	if _owner._critterType == Critter.CRITTER_TYPE.PLAYER:
		_owner.available_action_tile(_range)

func activate(_target, _user = null):
	on_action_used.emit()

func _exit_tree():
	_owner._currentAction = null
	if _owner._critterType == Critter.CRITTER_TYPE.PLAYER:
		_owner.available_movement_tiles()
	queue_free()

class_name Action

extends Node

@onready var _actionHint: Label = get_node("/root/ArenaScene/CanvasLayer/UI/ActionHint")
@onready var _owner:Critter = get_node("../")

@export var _cost: int
@export var _area: int
@export var _range: int
@export var _damage: int
@export var _actionHintText: String
@export var _animation: Critter.State

signal OnActionUsed()

func _ready():
	_actionHint.text = _actionHintText
	_owner._currentAction = self
	if _owner._critterType == Critter.CRITTER_TYPE.PLAYER:
		_owner.available_action_tile(_range)

func activate(target, user = null):
	OnActionUsed.emit()

func _exit_tree():
	_owner._currentAction = null
	if _owner._critterType == Critter.CRITTER_TYPE.PLAYER:
		_owner.available_movement_tiles()
		_actionHint.text = ""
	queue_free()

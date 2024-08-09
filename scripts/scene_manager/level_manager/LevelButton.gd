class_name LevelButton

extends LoadButton

@export var levels_to_unlock: Array[LevelButton]
@export var is_entry: bool = false

var curve: PackedScene = preload("res://scenes/scene_managment/level_selection/curved_line.tscn")

var is_locked: bool = true :
	get:
		return is_locked
	set(value):
		is_locked = value
		if value == false:
			disabled = false


func _ready():
	super()
	
	if is_entry:
		is_locked = false
	
	for level_button in levels_to_unlock:
		var _current_curve = curve.instantiate()
		_current_curve.position.y = size.y
		_current_curve.position.x = size.x/2
		add_child(_current_curve)
		_current_curve._path.curve.set_point_position(0, Vector2(0,0))
		_current_curve._path.curve.set_point_position(1, Vector2(level_button.position.x - position.x, level_button.position.y - position.y - size.y))
		_current_curve._path.curve.set_point_out(0, Vector2(0,(level_button.position.y - position.y)/2))
		_current_curve._path.curve.set_point_in(1, Vector2(0,-(level_button.position.y - position.y)/2))
		_current_curve.redraw()


func _on_pressed():
	if is_locked:
		return
	
	for level_button in levels_to_unlock:
		level_button.is_locked = false
	
	super()

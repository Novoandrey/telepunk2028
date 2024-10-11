@tool
extends Control

@onready var _path = $Path2D
@onready var _line = $Line2D

func _ready():
	print(_path)
	pass

func redraw():
	for point in _path.curve.get_baked_points():  
		_line.add_point(point + _path.position) 

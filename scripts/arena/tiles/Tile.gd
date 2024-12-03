@tool 
class_name Tile extends Node2D

@onready var test_ui: Control = $Control
@onready var tile_coords: Label = $Control/Panel/Label

var is_occupied: bool = false :
	get:
		return is_occupied
	set(value):
		is_occupied = value

func _ready():
	tile_coords.text = str(TileMapManager.instance.get_cell_from_position(global_position))
	#test_ui.hide()
	
	pass

func critter_enter(_body: Node2D):
	is_occupied = true;
	pass
	#var shader: ShaderMaterial = outline_sprite.material
	#print(shader)
	#shader.set_shader_parameter("outline_color", Color.CRIMSON)

func critter_exit(_body: Node2D):
	is_occupied = false;
	pass
	#var shader: ShaderMaterial = outline_sprite.material
	#print(shader)
	#shader.set_shader_parameter("outline_color", Color.WHITE)

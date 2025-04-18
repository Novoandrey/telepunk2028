class_name Tile
extends Node

@export var outline_sprite: Sprite2D

@onready var test_ui: Control = $Control

var is_occupied: bool = false :
	get:
		return is_occupied
	set(value):
		if value:
			test_ui.show()
		else :
			test_ui.hide()
		is_occupied = value

func _ready():
	test_ui.hide()

func critter_enter(body: Node2D):
	is_occupied = true;
	pass
	#var shader: ShaderMaterial = outline_sprite.material
	#print(shader)
	#shader.set_shader_parameter("outline_color", Color.CRIMSON)

func critter_exit(body: Node2D):
	is_occupied = false;
	pass
	#var shader: ShaderMaterial = outline_sprite.material
	#print(shader)
	#shader.set_shader_parameter("outline_color", Color.WHITE)

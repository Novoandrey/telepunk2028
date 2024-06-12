class_name Tile
extends Node

@export var outline_sprite: Sprite2D

func highlight_on(body: Node2D):
	pass
	#var shader: ShaderMaterial = outline_sprite.material
	#print(shader)
	#shader.set_shader_parameter("outline_color", Color.CRIMSON)

func highlight_off(body: Node2D):
	pass
	#var shader: ShaderMaterial = outline_sprite.material
	#print(shader)
	#shader.set_shader_parameter("outline_color", Color.WHITE)

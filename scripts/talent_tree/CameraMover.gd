extends Node2D

@onready var ray_length_x = get_viewport().size.x * ray_length_x_modifier
@onready var ray_length_y = get_viewport().size.y * ray_length_y_modifier
@onready var camera: CameraManager = $".."
var ray_length_x_modifier = 0.35
var ray_length_y_modifier = 0.5

# Called when the node enters the scene tree for the first time.
func change_camera_bounds(node, visibility):
	print(node.global_position)
	if node.global_position.x < (camera.limit_left + ray_length_x):
		camera.limit_left = node.global_position.x - ray_length_x + (node.size.x / 2 * node.scale.x)
	if node.global_position.x > (camera.limit_right - ray_length_x):
		camera.limit_right = node.global_position.x + ray_length_x - (node.size.x / 2 * node.scale.x)
	if node.global_position.y < (camera.limit_top + ray_length_y):
		camera.limit_top = node.global_position.y - ray_length_y + (node.size.y / 2 * node.scale.y)
	if node.global_position.y > (camera.limit_bottom - ray_length_y):
		camera.limit_bottom = node.global_position.y + ray_length_y - (node.size.y / 2 * node.scale.y)
	
	var new_center = node.global_position
	var node_count = 1
	for previous_node in node.previous_nodes:
		new_center += previous_node.global_position
		node_count += 1
	
	camera.position = node.global_position

func _ready():
	ClickerManager.instance.node_revealed.connect(change_camera_bounds)

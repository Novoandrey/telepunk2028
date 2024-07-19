class_name CameraManager

extends Camera2D

@export var max_zoom = 2
@export var min_zoom = 0.25
@export var zoom_speed = 0.1
@export var boundsUpperOffset = 0

@onready var tile_map : TileMap = get_node("/root/ArenaScene/BattleArena/Environment/TileMap")

var drag_start_pos = Vector2.ZERO
var drag_camera_pos = Vector2.ZERO
var top_bound
var left_bound
var right_bound
var bottom_bound
var isDragging = false


func _ready():
	top_bound = 0
	left_bound = 0
	right_bound = get_viewport_rect().size.x
	bottom_bound = get_viewport_rect().size.y
	
	if tile_map != null:
		print("Tilemap start" + str(tile_map.get_used_rect().position))
		print("Tilemap end" + str(tile_map.get_used_rect().end))
		print("Tilemap size" + str(tile_map.get_used_rect().size))
		var boundsStart = tile_map.to_global(tile_map.map_to_local(tile_map.get_used_rect().position))
		var boundsEnd = tile_map.to_global(tile_map.map_to_local(tile_map.get_used_rect().end))
		#boundsStart += tile_map.position + tile_map.get_parent().get_parent().position
		#boundsEnd += tile_map.position + tile_map.get_parent().get_parent().position
		print(boundsStart)
		print(boundsEnd)
		top_bound = boundsStart.y - boundsUpperOffset
		left_bound = boundsStart.x
		right_bound = boundsEnd.x
		bottom_bound = boundsEnd.y
		print(tile_map.to_global(tile_map.map_to_local(tile_map.get_used_rect().position)))
		print(tile_map.to_global(tile_map.map_to_local(tile_map.get_used_rect().size)))
	
	limit_top = top_bound
	limit_left = left_bound
	limit_right = right_bound
	limit_bottom = bottom_bound

func _process(delta):
	pass


func _unhandled_input(event):
	if event is InputEventScreenTouch:
		print("Touch")
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if zoom.x < max_zoom:
				zoom *= 1.1
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if zoom.x > min_zoom:
				zoom *= 0.9
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			drag_start_pos = get_viewport().get_mouse_position()
			drag_camera_pos = position
			print("Mouse")
			isDragging = true
			
		if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			isDragging = false
			
	if event is InputEventMouseMotion:
		if isDragging:
			var moveVector = get_viewport().get_mouse_position() - drag_start_pos
			position = drag_camera_pos - moveVector * 1/zoom.x
			if position.x < limit_left:
				position.x = limit_left
			if position.x > limit_right:
				position.x = limit_right
			if position.y < limit_top:
				position.y = limit_top
			if position.y > limit_bottom:
				position.y = limit_bottom
			

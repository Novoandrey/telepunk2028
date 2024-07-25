class_name CameraManager

extends Camera2D

@export var max_zoom = 2
@export var min_zoom = 0.25
@export var zoom_speed = 0.1
@export var pan_speed: float = 1.0
@export var boundsUpperOffset = 0
@export var can_pan: bool
@export var can_zoom: bool
@export var can_rotate: bool


@onready var tile_map : TileMap = get_node("/root/ArenaScene/BattleArena/Environment/TileMap")
@onready var point_a = get_node("/root/ArenaScene/PointA")
@onready var point_b = get_node("/root/ArenaScene/PointB")
@onready var point_center = get_node("/root/ArenaScene/PointCenter")
@onready var drag_timer = $Timer

var drag_start_pos = Vector2.ZERO
var drag_camera_pos = Vector2.ZERO
var is_dragging = false :
	get:
		return is_dragging
	set(value):
		is_dragging = value

var start_zoom: Vector2
var start_dist: float
var _touches: Dictionary = {}

func _ready():
	var top_bound = 0
	var left_bound = 0
	var right_bound = get_viewport_rect().size.x
	var bottom_bound = get_viewport_rect().size.y
	
	if tile_map != null:
		print("Tilemap start" + str(tile_map.get_used_rect().position))
		print("Tilemap end" + str(tile_map.get_used_rect().end))
		print("Tilemap size" + str(tile_map.get_used_rect().size))
		var boundsStart = tile_map.to_global(tile_map.map_to_local(tile_map.get_used_rect().position))
		var boundsEnd = tile_map.to_global(tile_map.map_to_local(tile_map.get_used_rect().end))
		top_bound = boundsStart.y - boundsUpperOffset
		left_bound = boundsStart.x
		right_bound = boundsEnd.x
		bottom_bound = boundsEnd.y
	
	limit_top = top_bound
	limit_left = left_bound
	limit_right = right_bound
	limit_bottom = bottom_bound
	

func _process(delta):
	pass


func _unhandled_input(event):
	
	mobile_camera_control(event)
	#print(get_canvas_transform().affine_inverse() * event.position)
	
	pc_camera_control(event)
	
	

func pc_camera_control(event):
	if event is InputEventScreenTouch:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if zoom.x < max_zoom:
				zoom *= 1.1
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if zoom.x > min_zoom:
				zoom *= 0.9
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_touches[0] = event.position
			drag_start_pos = get_viewport().get_mouse_position()
			drag_camera_pos = get_screen_center_position()
			start_drag()
			print("Mouse")
			
		if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			_touches.erase(0)
			is_dragging = false
			
	if event is InputEventMouseMotion:
		if _touches.size() >= 1:
			var moveVector = get_viewport().get_mouse_position() - drag_start_pos
			position = drag_camera_pos - moveVector * 1/zoom.x

func mobile_camera_control(event):
	if event is InputEventMouseButton:
		return
	
	if event is InputEventScreenTouch:
		_handle_touch(event)
	elif event is InputEventScreenDrag:
		_handle_drag(event)


func _handle_touch(event):
	if event.pressed:
		_touches[event.index] = event.position
		start_drag()
	else:
		_touches.erase(event.index)
		if _touches.size() <= 0:
			is_dragging = false
	
	if _touches.size() == 2:
		var touch_point_positions = _touches.values()
		start_dist = touch_point_positions[0].distance_to(touch_point_positions[1])
		start_zoom = zoom

func _handle_drag(event):
	_touches[event.index] = event.position 
	
	if _touches.size() == 1 and can_pan:
		print("Panning")
		position = get_screen_center_position()
		position -= event.relative * pan_speed
	
	elif _touches.size() >= 2 and can_zoom:
		
		var touch_point_positions = _touches.values()
		point_a.position = get_canvas_transform().affine_inverse() * touch_point_positions[0]
		point_b.position = get_canvas_transform().affine_inverse() * touch_point_positions[1]
		point_center.position = (point_a.position + point_b.position) / 2
		var current_dist = touch_point_positions[0].distance_to(touch_point_positions[1])
		position = position.lerp(point_center.position, 0.01)
		
		var zoom_factor = start_dist / current_dist
		var current_zoom = start_zoom / zoom_factor
		current_zoom.x = clamp(current_zoom.x, min_zoom, max_zoom)
		current_zoom.y = clamp(current_zoom.y, min_zoom, max_zoom)
		zoom = current_zoom
		

func start_drag():
	drag_timer.start()


func _on_timer_timeout():
	print("Start drag")
	if _touches.is_empty():
		return
	is_dragging = true

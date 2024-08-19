extends ScrollContainer

signal child_scrolled()
signal page_ended()

@onready var vertical_bar: VScrollBar = $_v_scroll
@onready var horizontal_bar: HScrollBar = $_h_scroll

func _ready():
	vertical_bar.scrolling.connect(vertical_scroll)
	print(vertical_bar)

func _unhandled_input(event):

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			vertical_scroll()

func vertical_scroll():
	if vertical_bar.value + size.y < vertical_bar.max_value:
		child_scrolled.emit()
	else:
		page_ended.emit()
	
func move_child_to(position_x: float, position_y: float):
	if horizontal_bar.visible:
		horizontal_bar.value = abs(position_x)
	if vertical_bar.visible:
		vertical_bar.value = abs(position_y)
	get_child(0).position = Vector2(position_x, position_y)
	pass

func move_child_to_end():
	var position_x = get_child(0).position.x
	var position_y = get_child(0).position.y
	if horizontal_scroll_mode != SCROLL_MODE_DISABLED:
		horizontal_bar.value = horizontal_bar.max_value
		position_x = horizontal_bar.max_value
	if vertical_scroll_mode != SCROLL_MODE_DISABLED:
		vertical_bar.value = vertical_bar.max_value
		position_y = -vertical_bar.max_value
	#get_child(0).position = Vector2(position_x, position_y)

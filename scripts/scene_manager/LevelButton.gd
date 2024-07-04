class_name LevelButton

extends LoadButton

@export var levels_to_unlock: Array[LevelButton]
@export var is_entry: bool = false

var is_locked: bool = true :
	get:
		return is_locked
	set(value):
		is_locked = value
		if value == false:
			disabled = false


func _ready():
	parent_scene = get_parent().get_parent().get_parent()
	parent_scene.level_buttons.append(self)
	if is_entry:
		is_locked = false
	
	for level_button in levels_to_unlock:
		var path2D = Path2D.new()
		path2D.position.y = size.y
		path2D.position.x = size.x/2
		path2D.curve = Curve2D.new()
		path2D.curve.add_point(Vector2(0,0), Vector2(50,25))
		path2D.curve.add_point(Vector2(100,100), Vector2(-50,-25))
		add_child(path2D)


func _on_pressed():
	if is_locked:
		return
	
	for level_button in levels_to_unlock:
		level_button.is_locked = false
	
	super()

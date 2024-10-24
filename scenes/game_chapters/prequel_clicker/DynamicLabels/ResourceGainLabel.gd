extends Label

# Тут мы настраиваем скорость движения анимации и оффсет появления текста с пополнением ресурса

@export var speed = 5
@export var offset = Vector2(0, 0)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	position += offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= speed * delta

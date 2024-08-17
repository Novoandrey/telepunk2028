class_name ClickerEventPlayer

extends AnimationPlayer

@export var animation_skip_time: float = 1 ##Длительность пропуска сцены
@export var starting_animation_name: String = "stop" ##Название анимации для воспроизведения
@export var can_interact: bool = true ##Игрок может действовать(тапать) на сцене

var is_skipping: bool = false

func _ready():
	print(get_animation_list())
	pass

func _unhandled_input(event):
	if !can_interact:
		return
	
	if event.is_action_released("ui_action"):
		if !is_playing(): #Запустить анимацию
			play(starting_animation_name)
		elif !is_skipping: #Пропуск сцены
			speed_scale = current_animation_length / animation_skip_time
			is_skipping = true
		else: #Остановка пропуска сцены
			speed_scale = 1
			is_skipping = false

func _play_until_key(): ##Остановить воспроизведения на данной точке (при пропуске сцены, данные метод игнорируется)
	if is_skipping:
		return
	pause()



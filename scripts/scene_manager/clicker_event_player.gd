class_name ClickerEventPlayer

extends AnimationPlayer

@onready var skip_timer: Timer = $SkipTimer
@onready var skip_progress_bar: ProgressBar = $CanvasLayer/Control/ProgressBar

@export var animation_skip_time: float = 1 ##Длительность пропуска сцены
@export var can_interact: bool = true ##Игрок может действовать(тапать) на сцене
@export var hold_to_skip_time: float = 1 ##Время, которое нужно держать палец, чтобы пропустить сцену

var is_skipping: bool = false
var is_full_skipping: bool = false

func _ready():
	print(get_animation_list())
	skip_timer.wait_time = hold_to_skip_time
	skip_timer.timeout.connect(skip_full)
	skip_progress_bar.max_value = hold_to_skip_time
	pass

func _process(delta):
	if !skip_timer.is_stopped():
		skip_progress_bar.value = skip_progress_bar.max_value - skip_timer.time_left
		pass

func _unhandled_input(event):
	if !can_interact:
		return
	if event.is_action_pressed("ui_action"):
		skip_timer.start()
		skip_progress_bar.show()
	
	if event.is_action_released("ui_action"):
		if !skip_timer.is_stopped():
			skip_progress_bar.value = 0
			skip_progress_bar.hide()
			skip_timer.stop()
		if !is_playing(): #Запустить анимацию
			play(current_animation)
		elif !is_skipping: #Пропуск сцены
			skip()
		else: #Остановка пропуска сцены
			speed_scale = 1
			is_skipping = false

func _skip_until_key(): ##Остановить частичный пропуск в данной точке времени
	if is_full_skipping:
		return
	elif is_skipping:
		speed_scale = 1
		is_skipping = false

func _pause_on_key(): ##Остановить воспроизведения на данной точке (при пропуске сцены, данные метод игнорируется)
	if is_full_skipping or is_skipping:
		return
	pause()

func skip(): ##Пропуск сцены до следующей точки skip_until_key
	play()
	speed_scale = current_animation_length / animation_skip_time
	is_skipping = true

func skip_full(): ##Полный пропуск сцены
	play()
	speed_scale = current_animation_length / animation_skip_time
	is_full_skipping = true
	can_interact = false
	pass

func switch_animation(animation_name: String):
	if get_animation_list().has(animation_name):
		play(animation_name)
	else:
		print("Animation not found")
	pass

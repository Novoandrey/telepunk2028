@tool
class_name GeneratorNode extends SkillNode

signal resource_generated(resource_name, amount)

@export var resource_name_generated: ClickerManager.RESOURCE = ClickerManager.RESOURCE.TCOIN

var generator_timer: Timer
var resource_made: float

func increase_level(value):
	super(value)
	if generator_timer == null:
		generator_timer = Timer.new()
		add_child(generator_timer)
		generator_timer.timeout.connect(on_generator_timeout)
		generator_timer.start(0.05)
	#generator_wait_time = generator_max_wait_time / level / current_strength

func on_generator_timeout():
	resource_made += current_strength * generator_timer.wait_time
	resource_generated.emit(resource_name_generated, int(resource_made))
	if resource_made > 0:
		resource_made = fmod(resource_made, clamp(round(resource_made), 1, current_strength))

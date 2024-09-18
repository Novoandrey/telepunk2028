@tool
class_name StoryNode extends SkillNode

@export var resource_tap_strength_increase: ClickerManager.RESOURCE = ClickerManager.RESOURCE.TCOIN

func _ready():
	super()
	node_strength_changed.connect(on_node_strength_changed)
	pass

func on_node_strength_changed(_value):
	print(current_strength)
	ClickerManager.instance.update_resource_strength(resource_tap_strength_increase, node_id, current_strength)

	

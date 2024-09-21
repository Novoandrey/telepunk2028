@tool
class_name ModifierNode extends SkillNode

@export var parent_node: SkillNode ##Родительский нод для усиления
@export var power_up_type: INCREASE_MODIFIER = INCREASE_MODIFIER.ADDITIVE ##Формат усиления родительского нода

func _ready():
	super()
	create_connections([parent_node], CONNECTION_TYPE.PREVIOUS)

func increase_level(value):
	super(value)
	power_up_parent()

func power_up_parent(type: INCREASE_MODIFIER = power_up_type):
	match power_up_type:
		INCREASE_MODIFIER.ADDITIVE:
			print(parent_node.current_strength)
			print(current_strength)
			parent_node.current_strength = parent_node.current_strength + current_strength
		INCREASE_MODIFIER.MULTIPLICATIVE:
			parent_node.current_strength += parent_node.strength * current_strength
			pass

#func _validate_property(property):
	##if property.name == "previous_nodes" or property.name == "next_nodes":
		##property.usage &= ~PROPERTY_USAGE_EDITOR


class_name BuyNodeWindow extends PanelContainer

@onready var buy_button: Button = $Margin/Control/VLayout/BuyInfo/BuyNode
@onready var close_button: Button = $Margin/Control/VLayout/MenuBar/CloseWindow
@onready var description_label: RichTextLabel = $Margin/Control/VLayout/NodeInfo/NodeDescription/RichTextLabel
@onready var parameters_label: RichTextLabel = $Margin/Control/VLayout/NodeInfo/NodeParameters/RichTextLabel
@onready var node_icon: TextureRect = $Margin/Control/VLayout/NodeInfo/TextureRect
@onready var node_name: Label = $Margin/Control/VLayout/MenuBar/NodeName

var node: SkillNode : 
	set(value):
		node = value
		update_node_info()
		can_buy_node()

func update_node_info():
	description_label.text = node.node_data.get(node.NODE_DATA_KEYS.NODE_DESCRIPTION)
	parameters_label.text = "Node level: " + str(node.node_data.get(node.NODE_DATA_KEYS.LEVEL)) + "/" + str(node.node_data.get(node.NODE_DATA_KEYS.MAX_LEVEL)) \
	+ "\nCurrent node cost: " + str(node.node_data.get(node.NODE_DATA_KEYS.CURRENT_COST)) \
	+ "\nCurrent node strength: " + str(node.node_data.get(node.NODE_DATA_KEYS.CURRENT_STRENGTH))
	node_icon.texture = node.texture_normal
	node_name.text = node.node_name
	pass

func can_buy_node():
	if node.level >= node.max_level or !node.is_unlocked:
		buy_button.disabled = true
	else:
		buy_button.disabled = false

func try_to_buy_node():
	if node != null and node.buy_node():
		print("Node was bought")
		update_node_info()
	else:
		print("Can't buy node")

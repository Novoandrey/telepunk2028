class_name BuySynapseWindow extends PanelContainer

# UI элементы, которые будут загружены при старте
@onready var buy_button: Button = $Margin/Control/VLayout/BuyInfo/BuyNode
@onready var close_button: Button = $Margin/Control/VLayout/MenuBar/CloseWindow
@onready var description_label: RichTextLabel = $Margin/Control/VLayout/NodeInfo/NodeDescription/RichTextLabel
@onready var song_label: RichTextLabel = $Margin/Control/VLayout/NodeInfo/NodeDescription/RichTextLabel2
@onready var parameters_label: RichTextLabel = $Margin/Control/VLayout/NodeInfo/NodeParameters/RichTextLabel
@onready var node_icon: TextureRect = $Margin/Control/VLayout/NodeInfo/TextureRect
@onready var node_name: Label = $Margin/Control/VLayout/MenuBar/NodeName

# Переменная для хранения текущего узла навыков
var node: SynapsNode : 
	set(value):
		node = value
		update_node_info()  # Обновляем информацию об узле
		can_buy_node()      # Проверяем возможность покупки узла

# Обновление информации об узле в UI
func update_node_info():
	# Устанавливаем описание узла
	description_label.text = node.node_data.get(node.NODE_DATA_KEYS.NODE_DESCRIPTION)
	
	# Формируем текст с параметрами узла
	parameters_label.text = "Node level: " + str(node.node_data.get(node.NODE_DATA_KEYS.LEVEL)) + "/" + str(node.node_data.get(node.NODE_DATA_KEYS.MAX_LEVEL)) \
						  + "\nCurrent node cost: " + str(node.node_data.get(node.NODE_DATA_KEYS.CURRENT_COST)) \
						  + "\nCurrent node strength: " + str(node.node_data.get(node.NODE_DATA_KEYS.CURRENT_STRENGTH))
	
	# Устанавливаем иконку узла и его название
	node_icon.texture = node.texture_normal
	node_name.text = node.node_name

# Проверка возможности покупки узла
func can_buy_node():
	# Узел нельзя купить, если его уровень максимальный или он не разблокирован
	if node.level >= node.max_level or !node.is_unlocked:
		buy_button.disabled = true  # Отключаем кнопку покупки
	else:
		buy_button.disabled = false  # Включаем кнопку покупки

# Попытка покупки узла
func try_to_buy_node():
	# Проверяем, что узел существует и покупка прошла успешно
	if node != null and node.buy_node():
		print("Node was bought")  # Сообщение об успешной покупке
		update_node_info()        # Обновляем информацию после покупки
	else:
		print("Can't buy node")   # Сообщение о неудачной попытке покупки

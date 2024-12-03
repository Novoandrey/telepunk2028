class_name NodeBuyList extends VBoxContainer

var node_arr: Dictionary

func _ready():
	ClickerManager.instance.node_tree_changed.connect(on_node_tree_changed)
	pass

func clear_list():
	pass

func fill_list():
	for node in node_arr:
		pass	
	pass

func sort_list():
	pass

func on_node_tree_changed(node_tree: UpgradeTreeManager):
	node_arr = node_tree.tree_nodes
	fill_list()
	pass

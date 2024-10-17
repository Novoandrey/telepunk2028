class_name UpgradeTreeManager extends Node2D

var tree_nodes: Array[Dictionary]
var node_data: Dictionary


func _ready():
	get_children_rec(self, tree_nodes)
	print(tree_nodes)

func get_children_rec(node, arr):
	var num_children = node.get_child_count()
	if num_children > 0:
		for i in num_children:
			var child = node.get_child(i)
			if child is SkillNode:
				child.node_level_changed.connect(on_node_level_changed)
				if child is GeneratorNode:
					child.resource_generated.connect(on_resource_generated)
				arr.append({"node":child, "node_data": child.node_data})
			get_children_rec(child, arr)
	else:
		return

func on_node_level_changed(_node):
	pass

func on_resource_generated(resource_name, amount):
	ClickerManager.instance.update_resource_value(resource_name, amount)
	pass

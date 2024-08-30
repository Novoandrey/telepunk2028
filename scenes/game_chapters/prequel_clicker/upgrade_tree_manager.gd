extends Node2D

var strength : int = 1

func _on_skill_node_pressed_control():
	var children := []
	get_children_rec(self, children)
	for child in children:
		if (child.mult_bool == true) && (child.level != 0):
			strength *= child.strength
		elif (child.mult_bool == false) && (child.level != 0):
			strength += child.strength
		else:
			continue
	return

func get_children_rec(node, arr):
	var num_children = node.get_child_count()
	if num_children > 0:
		for i in num_children:
			var child = node.get_child(i)
			if child.get_class() == "TextureButton":
				arr.append(child)
			get_children_rec(child, arr)
	else:
		return

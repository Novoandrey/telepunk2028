extends Node

@export var node_to_hide: CanvasItem
@export var node_to_show: CanvasItem


func _on_pressed():
	node_to_hide.hide()
	node_to_show.show()

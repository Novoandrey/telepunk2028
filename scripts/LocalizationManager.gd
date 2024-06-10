extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_button_ru_button_down():
	TranslationServer.set_locale("ru")
	pass # Replace with function body.


func _on_button_en_button_down():
	TranslationServer.set_locale("en")
	pass # Replace with function body.


func _on_button_fr_button_down():
	TranslationServer.set_locale("fr")
	pass # Replace with function body.

# TODO: Добавить остальные локализации

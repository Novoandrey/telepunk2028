extends AnimationPlayer

func _unhandled_input(event):
	if event.is_action_released("ui_action"):
		play("001_intro_animation")

extends Node2D

var taps = 0
var strength = 1
var tapssecond = 0
var auto = 0


func _process(delta):
	$TapsScore.text = str(taps)
	$TapsStrength.text = "Click Strength: " + str(strength)
	$AutoScore.text = "Auto Score: " + str(auto)
	$UpgradeButton.text = "Upgrade Cost: " + str(strength * 10)
	$AutoButton.text = "Auto Cost: " + str((auto + 1) * 20)


func _on_tap_button_pressed():
	taps += strength


func _on_upgrade_button_pressed():
	if (taps >= strength * 10):
		taps -= strength * 10
		strength += 1


func _on_auto_button_pressed():
	if (taps >= (auto + 1) * 20):
		taps -= (auto + 1) * 20
		auto += 1
		
		


func _on_timer_timeout():
	taps += auto
	

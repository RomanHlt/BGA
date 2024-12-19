extends Control


func _on_barre_5_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		$"Barre 4".button_pressed = false
		$"Barre 3".button_pressed = false
		$"Barre 2".button_pressed = false
		$"Barre 1".button_pressed = false


func _on_barre_4_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		$"Barre 3".button_pressed = false
		$"Barre 2".button_pressed = false
		$"Barre 1".button_pressed = false
	else:
		$"Barre 5".button_pressed = true

func _on_barre_3_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		$"Barre 2".button_pressed = false
		$"Barre 1".button_pressed = false
	else:
		$"Barre 4".button_pressed = true
		$"Barre 5".button_pressed = true


func _on_barre_2_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		$"Barre 1".button_pressed = false
	else:
		$"Barre 3".button_pressed = true
		$"Barre 4".button_pressed = true
		$"Barre 5".button_pressed = true


func _on_barre_1_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$"Barre 2".button_pressed = true
		$"Barre 3".button_pressed = true
		$"Barre 4".button_pressed = true
		$"Barre 5".button_pressed = true

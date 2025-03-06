extends Control

func _ready() -> void:
	"""Initialise l'affichage à l'aide des informations stockées dans GlobalsOptions"""
	var Musique = GlobalsOptions.Musique
	var barres = get_children()
	for i in range(Musique):
		barres[i].button_pressed = false
	for i in range(Musique, 5):
		barres[i].button_pressed = true
	if GlobalsOptions.Musique_disable:
		$"CheckButton Musique".button_pressed = false
	
func _on_barre_5_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		$"Barre 4".button_pressed = false
		$"Barre 3".button_pressed = false
		$"Barre 2".button_pressed = false
		$"Barre 1".button_pressed = false
		GlobalsOptions.Musique = 5
	else:
		GlobalsOptions.Musique = 4


func _on_barre_4_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		$"Barre 3".button_pressed = false
		$"Barre 2".button_pressed = false
		$"Barre 1".button_pressed = false
		GlobalsOptions.Musique = 4
	else:
		$"Barre 5".button_pressed = true
		GlobalsOptions.Musique = 3


func _on_barre_3_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		$"Barre 2".button_pressed = false
		$"Barre 1".button_pressed = false
		GlobalsOptions.Musique = 3
	else:
		$"Barre 4".button_pressed = true
		$"Barre 5".button_pressed = true
		GlobalsOptions.Musique = 2


func _on_barre_2_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		$"Barre 1".button_pressed = false
		GlobalsOptions.Musique = 2
	else:
		$"Barre 3".button_pressed = true
		$"Barre 4".button_pressed = true
		$"Barre 5".button_pressed = true
		GlobalsOptions.Musique = 1


func _on_barre_1_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		GlobalsOptions.Musique = 1
	else:
		$"Barre 2".button_pressed = true
		$"Barre 3".button_pressed = true
		$"Barre 4".button_pressed = true
		$"Barre 5".button_pressed = true
		GlobalsOptions.Musique = 0


func _on_check_button_musique_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		GlobalsOptions.Musique_disable = true
		$"../Musique/Barre 1".disabled = true
		$"../Musique/Barre 2".disabled = true
		$"../Musique/Barre 3".disabled = true
		$"../Musique/Barre 4".disabled = true
		$"../Musique/Barre 5".disabled = true
	else:
		GlobalsOptions.Musique_disable = false
		$"../Musique/Barre 1".disabled = false
		$"../Musique/Barre 2".disabled = false
		$"../Musique/Barre 3".disabled = false
		$"../Musique/Barre 4".disabled = false
		$"../Musique/Barre 5".disabled = false

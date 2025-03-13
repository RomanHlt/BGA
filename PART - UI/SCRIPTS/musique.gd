extends Control

func _ready() -> void:
	"""Initialise l'affichage à l'aide des informations stockées dans GlobalsOptions"""
	var Musique = Main.get_node("Globals Options").Musique
	var barres = get_children()
	for i in range(Musique):
		barres[i].button_pressed = false
	for i in range(Musique, 5):
		barres[i].button_pressed = true
	if Main.get_node("Globals Options").Musique_disable:
		$"CheckButton Musique".button_pressed = false
	
func _on_barre_5_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		$"Barre 4".button_pressed = false
		$"Barre 3".button_pressed = false
		$"Barre 2".button_pressed = false
		$"Barre 1".button_pressed = false
		Main.get_node("Globals Options").Musique = 5
	else:
		Main.get_node("Globals Options").Musique = 4


func _on_barre_4_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		$"Barre 3".button_pressed = false
		$"Barre 2".button_pressed = false
		$"Barre 1".button_pressed = false
		Main.get_node("Globals Options").Musique = 4
	else:
		$"Barre 5".button_pressed = true
		Main.get_node("Globals Options").Musique = 3


func _on_barre_3_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		$"Barre 2".button_pressed = false
		$"Barre 1".button_pressed = false
		Main.get_node("Globals Options").Musique = 3
	else:
		$"Barre 4".button_pressed = true
		$"Barre 5".button_pressed = true
		Main.get_node("Globals Options").Musique = 2


func _on_barre_2_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		$"Barre 1".button_pressed = false
		Main.get_node("Globals Options").Musique = 2
	else:
		$"Barre 3".button_pressed = true
		$"Barre 4".button_pressed = true
		$"Barre 5".button_pressed = true
		Main.get_node("Globals Options").Musique = 1


func _on_barre_1_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		Main.get_node("Globals Options").Musique = 1
	else:
		$"Barre 2".button_pressed = true
		$"Barre 3".button_pressed = true
		$"Barre 4".button_pressed = true
		$"Barre 5".button_pressed = true
		Main.get_node("Globals Options").Musique = 0


func _on_check_button_musique_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		Main.get_node("Globals Options").Musique_disable = true
		$"../Musique/Barre 1".disabled = true
		$"../Musique/Barre 2".disabled = true
		$"../Musique/Barre 3".disabled = true
		$"../Musique/Barre 4".disabled = true
		$"../Musique/Barre 5".disabled = true
	else:
		Main.get_node("Globals Options").Musique_disable = false
		$"../Musique/Barre 1".disabled = false
		$"../Musique/Barre 2".disabled = false
		$"../Musique/Barre 3".disabled = false
		$"../Musique/Barre 4".disabled = false
		$"../Musique/Barre 5".disabled = false

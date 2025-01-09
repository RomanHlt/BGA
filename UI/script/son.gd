extends Control

func _ready() -> void:
	"""Initialise l'affichage à l'aide des informations stockées dans GlobalsOptions"""
	var Son = GlobalsOptions.Son
	var barres = get_children()
	for i in range(Son):
		barres[i].button_pressed = false
	for i in range(Son, 5):
		barres[i].button_pressed = true
	if GlobalsOptions.Son_disable:
		$"CheckButton Son".button_pressed = false

func _on_barre_5_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		$"Barre 4".button_pressed = false
		$"Barre 3".button_pressed = false
		$"Barre 2".button_pressed = false
		$"Barre 1".button_pressed = false
		GlobalsOptions.Son = 5
	else:
		GlobalsOptions.Son = 4


func _on_barre_4_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		$"Barre 3".button_pressed = false
		$"Barre 2".button_pressed = false
		$"Barre 1".button_pressed = false
		GlobalsOptions.Son = 4
	else:
		$"Barre 5".button_pressed = true
		GlobalsOptions.Son = 3


func _on_barre_3_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		$"Barre 2".button_pressed = false
		$"Barre 1".button_pressed = false
		GlobalsOptions.Son = 3
	else:
		$"Barre 4".button_pressed = true
		$"Barre 5".button_pressed = true
		GlobalsOptions.Son = 2


func _on_barre_2_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		$"Barre 1".button_pressed = false
		GlobalsOptions.Son = 2
	else:
		$"Barre 3".button_pressed = true
		$"Barre 4".button_pressed = true
		$"Barre 5".button_pressed = true
		GlobalsOptions.Son = 1


func _on_barre_1_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		GlobalsOptions.Son = 1
	else:
		$"Barre 2".button_pressed = true
		$"Barre 3".button_pressed = true
		$"Barre 4".button_pressed = true
		$"Barre 5".button_pressed = true
		GlobalsOptions.Son = 0


func _on_check_button_son_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		GlobalsOptions.Son_disable = true
		$"../Son/Barre 1".disabled = true
		$"../Son/Barre 2".disabled = true
		$"../Son/Barre 3".disabled = true
		$"../Son/Barre 4".disabled = true
		$"../Son/Barre 5".disabled = true
	else:
		GlobalsOptions.Son_disable = false
		$"../Son/Barre 1".disabled = false
		$"../Son/Barre 2".disabled = false
		$"../Son/Barre 3".disabled = false
		$"../Son/Barre 4".disabled = false
		$"../Son/Barre 5".disabled = false

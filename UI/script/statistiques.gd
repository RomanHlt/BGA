extends Control


func _on_retour_pressed() -> void:
	"""Retour au menu pause / Retour à l'écran d'accueil. Dépend de l'endroit où a été ouvert l'option"""
	if GlobalsOptions.open_from_accueil == true:
		get_tree().change_scene_to_file("res://UI/scene/ecran_d'accueil.tscn")
	else:
		get_tree().change_scene_to_file("res://UI/scene/menu.tscn")

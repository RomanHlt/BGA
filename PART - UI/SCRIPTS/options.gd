extends Control


func _on_retour_pressed() -> void:
	"""Retour au menu pause / Retour à l'écran d'accueil. Dépend de l'endroit où a été ouvert l'option"""
	if Main.get_node("Globals Options").open_from_accueil == true:
		get_tree().root.get_node("/root/Ecran d'accueil/Menu d'accueil").visible = true
		self.visible = false
	else:
		get_tree().root.get_node("/root/Map/CanvasLayer/Menu").visible = true
		self.visible = false

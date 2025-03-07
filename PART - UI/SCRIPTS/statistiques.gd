extends Control


func update_stats() -> void:
	$"nbSauts".text = "Nombre de sauts : " + str(GlobalsOptions.nb_sauts)

func _on_retour_pressed() -> void:
	"""Retour au menu pause / Retour à l'écran d'accueil. Dépend de l'endroit où a été ouvert l'option"""
	if GlobalsOptions.open_from_accueil == true:
		get_tree().root.get_node("/root/Ecran d'accueil/Menu d'accueil").visible = true
		self.visible = false
	else:
		get_tree().root.get_node("/root/Map/CanvasLayer/Menu").visible = true
		self.visible = false

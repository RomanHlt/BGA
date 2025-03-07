extends Control


func _on_charger_la_partie_pressed() -> void:
	# Lancer la sauvegarde
	pass


func _on_options_pressed() -> void:
	GlobalsOptions.open_from_accueil = true
	get_tree().root.get_node("/root/Ecran d'accueil/Options").visible = true
	get_tree().root.get_node("/root/Ecran d'accueil/Menu d'accueil").visible = false


func _on_statistiques_pressed() -> void:
	GlobalsOptions.open_from_accueil = true
	get_tree().root.get_node("/root/Ecran d'accueil/Statistiques").update_stats()
	get_tree().root.get_node("/root/Ecran d'accueil/Statistiques").visible = true
	get_tree().root.get_node("/root/Ecran d'accueil/Menu d'accueil").visible = false


func _on_progres_pressed() -> void:
	GlobalsOptions.open_from_accueil = true
	get_tree().root.get_node("/root/Ecran d'accueil/Progrès").visible = true
	get_tree().root.get_node("/root/Ecran d'accueil/Menu d'accueil").visible = false


func _on_nouvelle_partie_pressed() -> void:
	# Creer une nouvelle partie (Ecrase l'ancienne)
	pass # Replace with function body.

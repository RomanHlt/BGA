extends Control


func _on_charger_la_partie_pressed() -> void:
	# Lancer la sauvegarde
	pass


func _on_options_pressed() -> void:
	GlobalsOptions.open_from_accueil = true
	get_tree().change_scene_to_file("res://UI/scene/options.tscn")


func _on_statistiques_pressed() -> void:
	GlobalsOptions.open_from_accueil = true
	get_tree().change_scene_to_file("res://UI/scene/statistiques.tscn")


func _on_progres_pressed() -> void:
	GlobalsOptions.open_from_accueil = true
	get_tree().change_scene_to_file("res://UI/scene/progrès.tscn")


func _on_nouvelle_partie_pressed() -> void:
	# Creer une nouvelle partie (Ecrase l'ancienne)
	pass # Replace with function body.

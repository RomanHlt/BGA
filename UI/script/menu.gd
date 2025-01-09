extends Control


func _on_reprendre_pressed() -> void:
	# Desactiver le menu
	pass


func _on_options_pressed() -> void:
	GlobalsOptions.open_from_accueil = false
	get_tree().change_scene_to_file("res://UI/scene/options.tscn")


func _on_statistiques_pressed() -> void:
	GlobalsOptions.open_from_accueil = false
	get_tree().change_scene_to_file("res://UI/scene/statistiques.tscn")


func _on_progres_pressed() -> void:
	GlobalsOptions.open_from_accueil = false
	get_tree().change_scene_to_file("res://UI/scene/progrès.tscn")


func _on_quitter_la_partie_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/scene/ecran_d'accueil.tscn")

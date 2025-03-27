extends Control

func _ready() -> void:
	if get_tree().current_scene.id.split(".")[1] == "0" and get_tree().current_scene.id.split(".")[2] == "0":
		$"Quitter la Partie".text = "Quitter la Partie"
	else:
		$"Quitter la Partie".text = "Retour au Hub"
	
func _on_reprendre_pressed() -> void:
	# Desactiver le menu
	var menu = get_tree().root.get_node("/root/Map/CanvasLayer/Menu")
	menu.visible = not menu.visible # Inverser l'état de la visibilité du menu
	get_tree().paused = menu.visible # Mettre en pause le jeu si le menu est ouvert


func _on_options_pressed() -> void:
	Main.get_node("Globals Options").open_from_accueil = false
	get_tree().root.get_node("/root/Map/CanvasLayer/Options").visible = true
	get_tree().root.get_node("/root/Map/CanvasLayer/Menu").visible = false


func _on_statistiques_pressed() -> void:
	Main.get_node("Globals Options").open_from_accueil = false
	get_tree().root.get_node("/root/Map/CanvasLayer/Statistiques").update_stats()
	get_tree().root.get_node("/root/Map/CanvasLayer/Statistiques").visible = true
	get_tree().root.get_node("/root/Map/CanvasLayer/Menu").visible = false


func _on_progres_pressed() -> void:
	Main.get_node("Globals Options").open_from_accueil = false
	get_tree().root.get_node("/root/Map/CanvasLayer/Progrès").visible = true
	get_tree().root.get_node("/root/Map/CanvasLayer/Menu").visible = false


func _on_quitter_la_partie_pressed() -> void:
	if $"Quitter la Partie".text == "Quitter la Partie":
		Main.get_node("Globals Options").ingame = false
		get_tree().paused = false
		get_tree().change_scene_to_file("res://PART - UI/SCENES/ecran_d'accueil.tscn")
	else:
		Main.get_node("Globals Options").open_from_accueil = false
		get_tree().paused = false
		get_tree().change_scene_to_file("res://PART - LEVELS/SCENES/M1/M1.tscn")

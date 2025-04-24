extends Control

var canContinue = false

func _ready() -> void:
	if ResourceLoader.exists('res://GLOBAL - DATA/SAVES/PlayerData.tres') and ResourceLoader.exists('res://GLOBAL - DATA/SAVES/WorldData.tres'):
		canContinue = true
		$"Charger la partie".disabled = false
	else:
		canContinue = false
		$"Charger la partie".disabled = true


func _on_charger_la_partie_pressed() -> void:
	var lvl = PlayerDataSaver.PlayerStats.current_lvl
	Main.get_node("Globals Levels").change_lvl(lvl, "Welcome Back",str(lvl))


func _on_options_pressed() -> void:
	Main.get_node("Globals Options").open_from_accueil = true
	get_tree().root.get_node("/root/Ecran d'accueil/Options").visible = true
	get_tree().root.get_node("/root/Ecran d'accueil/Menu d'accueil").visible = false


func _on_statistiques_pressed() -> void:
	Main.get_node("Globals Options").open_from_accueil = true
	get_tree().root.get_node("/root/Ecran d'accueil/Statistiques").update_stats()
	get_tree().root.get_node("/root/Ecran d'accueil/Statistiques").visible = true
	get_tree().root.get_node("/root/Ecran d'accueil/Menu d'accueil").visible = false


func _on_progres_pressed() -> void:
	Main.get_node("Globals Options").open_from_accueil = true
	get_tree().root.get_node("/root/Ecran d'accueil/Progrès").visible = true
	get_tree().root.get_node("/root/Ecran d'accueil/Menu d'accueil").visible = false


func _on_nouvelle_partie_pressed() -> void:
	PlayerDataSaver.PlayerStats = PlayerData.new()
	PlayerDataSaver.WorldStats = WorldData.new()
	var lvl = PlayerDataSaver.PlayerStats.current_lvl
	Main.get_node("Globals Levels").change_lvl(lvl, "Let's Begin",str(lvl))

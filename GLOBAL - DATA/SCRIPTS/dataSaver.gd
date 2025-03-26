extends Node2D

@export_category("Ressources")
@export var PlayerStats:PlayerData
@export var WorldStats:WorldData



func _handle_save():
	PlayerStats.save_game()
	WorldStats.save_game()

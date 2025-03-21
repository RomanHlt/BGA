extends Node2D

@export_category("Ressources")
@export var PlayerStats:Resource


func _handle_save():
	PlayerStats.save_game()

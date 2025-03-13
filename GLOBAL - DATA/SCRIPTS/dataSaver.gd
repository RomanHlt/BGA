extends Node2D

@export_category("Ressources")
@export var file:Resource

func _handle_save():
	file.save_game()

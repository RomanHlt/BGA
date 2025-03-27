extends Node2D

@export_category("Ressources")
@export var PlayerStats:PlayerData
@export var WorldStats:WorldData

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fastSave"):
		_handle_save()

func _handle_save():
	PlayerStats.save_game()
	WorldStats.save_game()
	print("game saved !")

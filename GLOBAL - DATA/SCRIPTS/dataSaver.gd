extends Node2D

@export_category("Ressources")
@export var PlayerStats:PlayerData
@export var WorldStats:WorldData
@export var SettingsStats:SettingsData 
@export var dataExist:bool = false

func _ready() -> void:
	_handle_load()

func _process(delta: float) -> void:
	pass

func _handle_save():
	PlayerStats.save_game()
	WorldStats.save_game()
	SettingsStats.save_game()
	print("Game Saved !")

func _handle_load():
	PlayerStats = PlayerData.new().load_game()
	WorldStats = WorldData.new().load_game()
	SettingsStats = SettingsData.new().load_game()
	if PlayerStats != null and WorldStats != null and SettingsStats != null:
		dataExist = true
		print("-------------------")
		print("Game Loaded !")
	else:
		dataExist = false
		print("Couldn't find saves")
		print("-------------------")
		PlayerStats = PlayerData.new()
		WorldStats = WorldData.new()
		SettingsStats = SettingsData.new()
		print("Player Data Created")
		print("World Data Created")
		print("Settings Data Created")
		print("-------------------")

extends Resource
class_name PlayerData

@export_category("Save Files")
@export var save_file:JSON
@export_category("Data")
var level = 0
var items:Array = ["Apple","Gun","Key"]
var health = 100

func save_game():
	ResourceSaver.save(self,'res://DATA/SAVES/save00.json')
	print("Game saved !")

extends Resource
class_name PlayerData

@export var level = 0
@export var items:Array = ["Apple","Gun","Key"]
@export var health = 100

func save_game():
	var result = ResourceSaver.save(self,'res://GLOBAL - DATA/SAVES/Data00.tres')
	assert(result == OK)
	print("Game Saved")
func load_game():
	if ResourceLoader.exists('res://GLOBAL - DATA/SAVES/Data00.tres'):
		var player = ResourceLoader.load('res://GLOBAL - DATA/SAVES/Data00.tres')
		if player is PlayerData:
			return player

extends Resource
class_name PlayerData


@export var level = 0
@export var items:Array = ["Apple","Gun","Key"]
@export var health = 4
@export var dashUnlocked:bool = false
@export var is_dead = false
@export var max_health = 4
@export var current_lvl:String = "1.0.0"
@export var last_lvl:String = "0.0.0"

func save_game():
	var result = ResourceSaver.save(self,'res://GLOBAL - DATA/SAVES/PlayerData.tres')
	assert(result == OK)
func load_game():
	if ResourceLoader.exists('res://GLOBAL - DATA/SAVES/PlayerData.tres'):
		var player = ResourceLoader.load('res://GLOBAL - DATA/SAVES/PlayerData.tres')
		if player is PlayerData:
			print("PlayerData Found")
			if player.is_dead == true: 
				player.is_dead = false
				player.health = player.max_health
			return player
	else:
		return null

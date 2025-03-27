extends Resource
class_name WorldData

@export var levels:int = 1
@export var compo:Dictionary={1:[false,false,false],2:[false,false,false]}
@export var access:Dictionary={1:false,2:false}

func save_game():
	var result = ResourceSaver.save(self,'res://GLOBAL - DATA/SAVES/WorldData.tres')
	assert(result == OK)
	print("World Saved")
	
	
	
func load_game():
	if ResourceLoader.exists('res://GLOBAL - DATA/SAVES/WorldData.tres'):
		var data = ResourceLoader.load('res://GLOBAL - DATA/SAVES/WorldData.tres')
		if data is WorldData:
			return data

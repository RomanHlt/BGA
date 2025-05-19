extends Resource
class_name WorldData

@export var levels:int = 1
@export var compo:Dictionary={1:[false,false,false],2:[false,false,false],3:[false,false,false]}
@export var access:Dictionary={1:true,2:false,"next":false}



func save_game():
	var result = ResourceSaver.save(self,'res://GLOBAL - DATA/SAVES/WorldData.tres')
	assert(result == OK)
	
	
	
func load_game():
	if ResourceLoader.exists('res://GLOBAL - DATA/SAVES/WorldData.tres'):
		var data = ResourceLoader.load('res://GLOBAL - DATA/SAVES/WorldData.tres')
		if data is WorldData:
			print("WorldData Found")
			return data
	else:
		print("WorldData Created")
		return WorldData.new()


func level_completed(id:String, isLastLevel:bool = false):
	if !isLastLevel: access[int(id.split(".")[1])] = true #debloquer le niveau suivant
	else:
		access["next"] = true #débloquer le monde suivant

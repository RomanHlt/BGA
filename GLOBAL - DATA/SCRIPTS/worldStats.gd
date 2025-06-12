extends Resource
class_name WorldData

@export var levels:int = 1
@export var compo:Dictionary={1:[false,false,false],2:[false,false,false],3:[false,false,false],4:[true,true,true],5:[false,false,false],6:[false,false,false]}
@export var access:Dictionary={1:true,2:false,3:false,4:true,5:true,"next":false}



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
		return null



func level_completed(id:String, isLastLevel:bool = false):
	if !isLastLevel: access[int(id.split(".")[1])] = true #debloquer le niveau suivant
	else:
		access["next"] = true #débloquer le monde suivant

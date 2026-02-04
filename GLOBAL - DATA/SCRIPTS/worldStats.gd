extends Resource
class_name WorldData

@export var levels:int = 1
@export var compo:Dictionary={"1.1.0":[false,false,false],"1.2.0":[false,false,false],"1.3.0":[false,false,false],"0.1.0":[true,true,true],"1.4.0":[false,false,false],"2.0.0":[true,true,true],"2.1.0":[false,false,false],"2.2.0":[false,false,false],"2.3.0":[false,false,false],"2.4.0":[false,false,false]}
@export var access:Dictionary={"0.1.0":true,"1.0.0":true,"1.1.0":true,"1.2.0":false,"1.3.0":false,"1.4.0":false,"2.0.0":false,"2.1.0":true,"2.2.0":false,"2.3.0":false,"2.4.0":false}

"""
Pour une meilleur lisibilité je vais essayer de changer les clés des dico par le nom du niveau qu'elles représentent
"""


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



func level_completed(id:String):
	access[id] = true #debloquer le niveau suivant

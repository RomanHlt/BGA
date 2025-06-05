extends Resource
class_name SettingsData


@export var son:bool = true
@export var music:bool = true
@export var sonVolume:int = 100
@export var musicVolume:int = 100
@export var events:Array = InputMap.get_actions()
@export var inputs_events:Dictionary = {}

func save_game():
	for i in InputMap.get_actions():
		#print("-",i,":")
		inputs_events[i] = []
		for event in InputMap.action_get_events(i):
			#print("-------- ",event.as_text())
			inputs_events[i].append(event)
	var result = ResourceSaver.save(self,'res://GLOBAL - DATA/SAVES/SettingsData.tres')
	assert(result == OK)
func load_game():
	if ResourceLoader.exists('res://GLOBAL - DATA/SAVES/SettingsData.tres'):
		var settings = ResourceLoader.load('res://GLOBAL - DATA/SAVES/SettingsData.tres')
		if settings is SettingsData:
			print("SettingsData Found")
			for i in settings.inputs_events:
				print(i ," | ", settings.inputs_events[i])
				InputMap.action_erase_events(i)
				for j in settings.inputs_events[i]:
					InputMap.action_add_event(i,j)
				
			return settings
	else:
		print("SettingsData created")
		return SettingsData.new()

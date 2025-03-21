extends Control

@export var dico : Dictionary # Clé : id en Str "x.y" | Valeur : chemin en string
@export var loadscene_path : String

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS # Le script autoload ne sera pas afecté par les pauses.

func change_lvl(id, titre, sous_titre):
	var new_lvl_path = dico[id]
	$"../CanvasLayer/Fondu".change_lvl(new_lvl_path, titre, sous_titre)

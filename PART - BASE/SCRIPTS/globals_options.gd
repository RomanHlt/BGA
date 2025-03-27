extends Control

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS # Le script autoload ne sera pas afecté par les pauses.
	
# Variables pour sauvegarder les données du jeu
func _process(delta: float) -> void:
	print(Main.get_node("/root/GlobalsOptions").ingame)

# Variables des options (Les valeurs renseignées seront celles par défaut
var Son = 3  # Son (0-5)
var Son_disable = false # Son coupé

var Musique = 3 # Musique (0-5)
var Musique_disable = false # Musique coupée

# Variables autre
var open_from_accueil = true # true si les options/stat/... sont ouverts depuis l'accueil, false s'ils sont ouverts depuis le menu pause
var ingame = false # true si le joueur est en jeu. (Mettre false à chaque fois que le joueur ne doit pas ouvrir le menu : cinématique/accueil/...)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu") and ingame == true:
		print("input")
		var menus = get_tree().root.get_node("/root/Map/CanvasLayer").get_children() # Liste de tout les menus
		var open = false # true si un menu est ouvert
		for child in menus: # Vérification, si un menu est ouvert
			if child.visible:
				open = true
		
		if open: # Si un menu est ouvert, on les fermes tous
			for child in menus:
				child.visible = false
			get_tree().paused = false # Reprendre le jeu
		else:	# Si aucun menu n'est ouvert, on montre le menu principal
			menus[0].visible = true
			get_tree().paused = true # Mettre en pause le jeu

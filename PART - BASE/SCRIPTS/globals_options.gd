extends Control
signal controllerOn
signal controllerOff

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS # Le script autoload ne sera pas afecté par les pauses.
	
# Variables pour sauvegarder les données du jeu
# Variables des options (Les valeurs renseignées seront celles par défaut
var Son = 3  # Son (0-5)
var Son_disable = false # Son coupé

var controller = false

var Musique = 3 # Musique (0-5)
var Musique_disable = false # Musique coupée

# Variables autre
var onMenu:bool = true
var ingame = false # true si le joueur est en jeu. (Mettre false à chaque fois que le joueur ne doit pas ouvrir le menu : cinématique/accueil/...)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("controllerUsed"):
		if !controller:
			emit_signal("controllerOn")
		controller=true
	elif Input.is_action_just_pressed("keyboardUsed"):
		if controller:
			emit_signal("controllerOff")
		controller=false
"""
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
"""

extends CharacterBody2D

"""
FONCTIONNEMENT PAR DEFAUT
POUR EN FAIRE UN BOSS : DUPLIQUER PUIS ADAPTER LE SCRIPT
"""

@export_category("Global details")
@export var sprite:Sprite2D
@export var layer : int = 0

@export_category("Boss specificity")
@export var health = 10 			# Vie du boss
@export var distance_max_melee = 50 	# Distance max pour une attaque de melee
# --
# --
# --
# --- Variable interne  ---
@onready var target : CharacterBody2D # Cible du boss
# --
# --
# --
# --- Variable d'état ---
@onready var is_idle = true				# Ne fait rien
@onready var is_attacking = false		# Attaque (Corps à corps, tir, magie)
@onready var is_following = false		# Suit la cible
@onready var is_using_capacity = false	# Utilise une capacité (Hors attaque : heal, tp, bouclier)
@onready var evolution = 1				# Niveau d'évolution/Numéro de la phase
# --
# --
# --
# --- ready ---
func _ready() -> void:
	collision_layer = 2**layer
	collision_mask = 2**layer
	# Afficher la barre de vie du boss
	await get_tree().create_timer(1).timeout
# --
# --
# --
# --- Actions internes (Prendre dégat, évoluer, choix des actions, ...) ---
func _on_zone_de_détéction_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		target = body

func action():
	"""Choisi l'action à faire en fonction de certains paramètres et de l'état (idle, attacking, ...) du boss."""
	var actions = ["attack", "follow", "use_capacity"] # Actions possible, à modifier selon les boss et selon les conditions en temps réel
	var action = pick_random_action(actions)
	print("Action choisie : ", action) # Debug
	if action == "attack":
		attack()
	if action == "follow":
		follow()
	if action == "use_capacity":
		use_capacity()

func pick_random_action(actions: Array) -> String:
	"""Renvoie une action au hasard"""
	return actions[randi() % actions.size()]

func attack():
	"""Choisi quel type d'attaque utiliser"""
	is_idle = false
	is_attacking = true
	if self.global_position.distance_to(target.global_position) <= distance_max_melee: # Distance entre boss et cible <= max melee ?
		melee()
	else:
		long()

func melee():
	pass
	
func long():
	pass

func use_capacity():
	is_idle = false
	is_using_capacity = true
	
	is_using_capacity = false
	is_idle = true

func _takeDamages(damages):
	if damages <= health:
		health -= damages
		# Retirer les dégats à la barre de vie du boss
	else:
		health = 0
		# Retirer les dégats à la barre de vie du boss
# --
# --
# --
# --- Actions externes (Attaquer, suivre, tout ce qui est visible) ---
func evolve():
	"""Vérifie si les conditions pour changer de phase sont bonne, change de phase si oui"""
	pass

func follow():
	is_idle = false
	is_following = true
	
	is_following = false
	is_idle = true

# --
# --
# --
# --- Proscess ---
func _process(delta: float) -> void:
	if is_idle:
		action()
	evolve()
	move_and_slide()

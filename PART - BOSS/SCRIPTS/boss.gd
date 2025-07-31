extends CharacterBody2D

"""
FONCTIONNEMENT PAR DEFAUT
POUR EN FAIRE UN BOSS : DUPLIQUER PUIS ADAPTER LE SCRIPT
"""

@export_category("Global details")
@export var sprite:Sprite2D
@export var layer : int = 0

@export_category("Boss specificity")
@export var health_max = 10 			# Vie du boss
@export var distance_max_melee = 50 	# Distance max pour une attaque de melee
# --
# --
# --
# --- Variable interne  ---
@onready var target : CharacterBody2D # Cible du boss
@onready var health = health_max
# --
# --
# --
# --- Variable d'état ---
@onready var is_idle = true				# Ne fait rien
@onready var is_attacking = false		# Attaque (Corps à corps, tir, magie)
@onready var is_following = false		# Suit la cible
@onready var is_using_capacity = false	# Utilise une capacité (Hors attaque : heal, tp, bouclier)
@onready var lvl_evolution = 1				# Niveau d'évolution/Numéro de la phase
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

func use_capacity():
	is_idle = false
	is_using_capacity = true
	var capas = ["Heal", "Tp", "Summon"] 
	if health == health_max: # Exemple de condition modifiant les possibilités
		while "Heal" in capas:
			capas.erase("Heal")
	if lvl_evolution < 2: # La capa summon sera utilisée que apres la phase 1
		while "Summon" in capas:
			capas.erase("Summon")
	var choice = pick_random_action(capas)
	if choice == "Heal":
		heal()
	if choice == "Tp":
		tp()
	if choice == "Summon":
		summon()


func melee():
	var melees = ["melee_1", "melee_2"] # Différente attaque de mélée si besoin
	var choice = pick_random_action(melees)
	if choice == "melee_1":
		melee_1()
	if choice == "melee_2":
		melee_2()


func long():
	var longs = ["long_1", "long_2", "long_2", "long_2"] # Exemple pour modifier les proba, long_1 est rare
	var choice = pick_random_action(longs)
	if choice == "long_1":
		long_1()
	if choice == "long_2":
		long_2()

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

# - Attaque -
func melee_1():
	print("Melee 1 !")
	is_attacking = false	# Ne pas oublier ces deux dernières ligne
	is_idle = true
	
func melee_2():
	print("Melee 2 !")
	is_attacking = false
	is_idle = true
	
func long_1():
	print("Long 1 !")
	is_attacking = false
	is_idle = true
	
func long_2():
	print("Long 2 !")
	is_attacking = false
	is_idle = true
	
func heal():
	print("HEAL !!!")
	is_using_capacity = false
	is_idle = true

func tp():
	print("TP")
	self.position.x += 250 # exemple
	is_using_capacity = false
	is_idle = true

func summon():
	print("Summon !")
	is_using_capacity = false
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

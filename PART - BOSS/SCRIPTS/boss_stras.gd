extends CharacterBody2D

"""
FONCTIONNEMENT PAR DEFAUT
POUR EN FAIRE UN BOSS : DUPLIQUER PUIS ADAPTER LE SCRIPT
"""

@export_category("Global details")
@export var sprite:Sprite2D
@export var target : CharacterBody2D 		# Cible du boss
@export var TL : Marker2D
@export var TR : Marker2D
@export var BL : Marker2D
@export var BR : Marker2D

@export_category("Boss specificity")
@export var health_max = 10 			# Vie du boss
@export var speed = 100
# --
# --
# --
# --- Variables internes  ---
@onready var health = health_max			# Vie max
var stuned = false					# Boss stuned ?
var in_R_to_L = false
var in_L_to_R = false
# Variables d'état
@onready var is_idle = true				# Ne fait rien
@onready var is_attacking = false		# Attaque (Corps à corps, tir, magie)
@onready var is_using_capacity = false	# Utilise une capacité (Hors attaque : heal, tp, bouclier)
@onready var lvl_evolution = 1			# Niveau d'évolution/Numéro de la phase
@onready var is_dead = false
# --- Variables spécifiques
# --
# --
# --
# --- ready ---
func _ready() -> void:
	pass
# --
# --
# --
# --- Actions internes (Prendre dégat, évoluer, choix des actions, ...) ---
func action():
	"""Choisi l'action à faire en fonction de certains paramètres et de l'état (idle, attacking, ...) du boss."""
	var actions = ["pic","pic","backdash","bombe","bombe"] # Actions possible, à modifier selon les boss et selon les conditions en temps réel
	if not target:
		while "pic" in actions:
			actions.erase("attack")
		while "bombe" in actions:
			actions.erase("follow")
	if lvl_evolution == 1:
		while "backdash" in actions:
			actions.erase("backdash")
	
	var action = pick_random_action(actions)
	if action == "pic":
		pic()
	if action == "bombe":
		bombe()
	if action == "backdash":
		backdash()


func pick_random_action(actions: Array) -> String:
	"""Renvoie une action au hasard"""
	return actions[randi() % actions.size()]

func pic():
	"""Choisi en fonction de sa position acctuelle vers où le boss 'pic'.
	Pic entre le point A et B, si le joueur se trouve entre il sera ejecté et prendra des dégats"""
	if self.global_position == TL.global_position:
		#Lancer l'animation de pic
		self.global_position = BR.global_position
		if in_L_to_R:
			target._takeDamages()
			target.velocity.y -= 500
	if self.global_position == TR.global_position:
		#Lancer l'animation de pic
		self.global_position = BL.global_position
		if in_R_to_L:
			target._takeDamages()
			target.velocity.y -= 500
	#Lancer l'animation de remonté
	

func bombe():
	if self.global_position == TL.global_position:
		self.velocity.x = speed
	if self.global_position == TR.global_position:
		self.velocity.x = -speed
	#Drop les bombes

func backdash():
	pass


func _takeDamages(damages):
	if damages <= health:
		health -= damages
		# Retirer les dégats à la barre de vie du boss
	else:
		health = 0
		# Retirer les dégats à la barre de vie du boss
		is_dead = true
		dead()
	evolve() # Vérifier le changement de phase


# --
# --
# --
# --- Actions externes (Attaquer, suivre, tout ce qui est visible) ---
func evolve():
	"""Vérifie si les conditions pour changer de phase sont bonne, change de phase si oui"""
	if health <= 5:
		lvl_evolution = 2
		health_max = 5 # Il va pas se heal au dessus de 5 s'il change de phase


# - Attaques/capas -



func dead():
	is_idle = false
	is_using_capacity = false
	is_attacking = false
	self.velocity = Vector2.ZERO
	# attendre que l'animation de mort se joue dans handle_animation() puis queue free la bas
# --
# --
# --
# --- Process ---
func _process(delta: float) -> void:
	handle_animation()
	if is_idle:
		action()


func _physics_process(delta):
	move_and_slide()

# --- Animation ---
func handle_animation():
	"""Toutes les animations"""
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	pass # Replace with function body.




# Détéction du joueur dans une des zones de l'attque pic du boss
func _on_l_to_r_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		in_L_to_R = true

func _on_l_to_r_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		in_L_to_R = false

func _on_r_to_l_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		in_R_to_L = true

func _on_r_to_l_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		in_R_to_L = false


# Arrivé du boos sur un point clé, quand il passe très proche on dit qu'il est sur ce point
func _on_tl_body_entered(body: Node2D) -> void:
	if body.name == self.name:
		self.global_position = TL.global_position

func _on_tr_body_entered(body: Node2D) -> void:
	if body.name == self.name:
		self.global_position = TR.global_position

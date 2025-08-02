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
@export var speed = 100
@export var distance_max_melee = 50 	# Distance max pour une attaque de melee
# --
# --
# --
# --- Variable interne  ---
@onready var target : CharacterBody2D 		# Cible du boss
@onready var health = health_max			# Vie max
@onready var stuned = false					# Boss stuned ?
# Suivi
@onready var following_time = 0 			# Temps max pour follow le joueur, on arrête de le follow après
@onready var following_distance = 0			# Distance max de suivi, on arrête de courir après l'avoir parcourue
@onready var follow_timer = 0.0				# Temps max pendant lequel le boss suit le joueur (choisi aléatoirement dans la fonction follow)
@onready var distance_traveled = 0.0		# Distance max " " "
# Deplacement
@onready var last_position = Vector2.ZERO	# Dernière position du boss
@onready var stuck_timer = 0.0				# Temps coincé
@onready var stuck_check_delay = 0.15		# Temps max à resté coincé avant de sauter
@onready var tried_jump = false				# Le boss a-t-il essayé de sauté ? Evite de sauter conte un mur en boucle
@onready var tried_jump_switch = false		# Le boss a-t-il essayé de sauté tout en changeant de layer ?
@onready var can_go_deeper = true			# Peut switch de layer vers derrière ?
@onready var can_go_closer = true			# " " devant ?
@onready var can_go_deeper_with_jump = true	# Bah c'est dans le nom il est assez long comme ça hein
@onready var can_go_closer_with_jump = true
@onready var Layers							# Listes des layers
# --
# --
# --
# --- Variable d'état ---
@onready var is_idle = true				# Ne fait rien
@onready var is_attacking = false		# Attaque (Corps à corps, tir, magie)
@onready var is_following = false		# Suit la cible
@onready var is_using_capacity = false	# Utilise une capacité (Hors attaque : heal, tp, bouclier)
@onready var lvl_evolution = 1			# Niveau d'évolution/Numéro de la phase
# --
# --
# --
# --- ready ---
func _ready() -> void:
	z_index = -layer
	collision_layer = 2**layer
	collision_mask = 2**layer
	$Deeper.collision_mask = 2**(layer+1)
	$Closer.collision_mask = 2**(layer-1)
	$Deeper_with_jump.collision_mask = 2**(layer+1)
	$Closer_with_jump.collision_mask = 2**(layer-1)
	Layers = get_parent().get_parent().get_children().filter(func (x): if x.is_class("TileMapLayer"): return x) # Ah gros l'arbre généalogique de fou si cette ligne marche encore à la fin du jeu c'est un miracle
	self.reparent(Layers[layer])
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
	# var actions = ["attack", "follow", "use_capacity"] # Actions possible, à modifier selon les boss et selon les conditions en temps réel
	var actions = ["follow", "nothing"] # ligne pour les tests, utiliser celle au dessus
	if not target:
		while "attack" in actions:
			actions.erase("attack")
		while "follow" in actions:
			actions.erase("follow")
	
	var action = pick_random_action(actions)
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
	evolve() # Au cas où on change de phase


func _on_closer_body_entered(body: Node2D) -> void:
	can_go_closer = false
func _on_closer_body_exited(body: Node2D) -> void:
	can_go_closer = true
func _on_deeper_body_entered(body: Node2D) -> void:
	can_go_deeper = false
func _on_deeper_body_exited(body: Node2D) -> void:
	can_go_deeper = true


func _on_deeper_with_jump_body_entered(body: Node2D) -> void:
	can_go_deeper_with_jump = false
func _on_deeper_with_jump_body_exited(body: Node2D) -> void:
	can_go_deeper_with_jump = true
func _on_closer_with_jump_body_entered(body: Node2D) -> void:
	can_go_closer_with_jump = false
func _on_closer_with_jump_body_exited(body: Node2D) -> void:
	can_go_closer_with_jump = true
# --
# --
# --
# --- Actions externes (Attaquer, suivre, tout ce qui est visible) ---
func evolve():
	"""Vérifie si les conditions pour changer de phase sont bonne, change de phase si oui"""
	if health <= 5:
		lvl_evolution = 2
		health_max = 5 # Il va pas se heal au dessus de 5 s'il change de phase


func follow():
	"""Pour follow un joueur en mouvement constant ça va se faire dans le physics process"""
	is_idle = false
	is_following = true
	following_time = randi_range(2, 4) # random entre 2 et 4 inclus
	following_distance = randi_range(100, 400)
	
	follow_timer = 0.0
	distance_traveled = 0.0
	last_position = global_position


func stun(time):
	"""Appeler depuis le joueur pour stun le boss"""
	stuned = true
	is_attacking = false
	is_following = false
	is_using_capacity = false
	is_idle = true
	stop_follow()
	await get_tree().create_timer(time).timeout
	stuned = false


func change_layer(l:int = 0):
	self.reparent(Layers[l])
	self.collision_mask = 2**l
	self.collision_layer = 2**l
	self.z_index = -l
	$Deeper.collision_mask = 2**(l+1)
	$Closer.collision_mask = 2**(l-1)
	layer = l
	self.position.y+=1 #Eviter que les checker ne detectent plus de collisions (patch de brute)
	# Ah là ca va être lourd
	$JumpLeft.collision_mask = 2**l
	$JumpRight.collision_mask = 2**l
	$Above.collision_mask = 2**l
	$Below.collision_mask = 2**l
	$Deeper_with_jump.collision_mask = 2**(layer+1)
	$Closer_with_jump.collision_mask = 2**(layer-1)
	# Rajouter toutes les areas s'ils y en a +


# - Attaques/capas -
func melee_1():
	print("ATTACK : Melee 1 !")
	await get_tree().create_timer(2).timeout 
	is_attacking = false	# Ne pas oublier ces deux dernières ligne
	is_idle = true


func melee_2():
	print("ATTACK : Melee 2 !")
	await get_tree().create_timer(2).timeout
	is_attacking = false
	is_idle = true


func long_1():
	print("ATTACK RARE 1/4 : Long 1 ! ")
	await get_tree().create_timer(2).timeout
	is_attacking = false
	is_idle = true


func long_2():
	print("ATTACK : Long 2 !")
	await get_tree().create_timer(2).timeout
	is_attacking = false
	is_idle = true


func heal():
	print("CAPA : HEAL !!!")
	is_using_capacity = false
	is_idle = true


func tp():
	print("CAPA : TP")
	await get_tree().create_timer(2).timeout
	is_using_capacity = false
	is_idle = true


func summon():
	print("CAPA PHASE 2: Summon !")
	await get_tree().create_timer(2).timeout
	is_using_capacity = false
	is_idle = true


func stop_follow():
	is_following = false
	velocity = Vector2.ZERO
	is_idle = true


# - Collisions -
func _on_jump_left_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		$JumpComponent.handle_jump(self, true)


func _on_jump_right_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		$JumpComponent.handle_jump(self, true)


func _on_above_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.velocity.y = -600
		if randi() % 2 == 1:
			body.velocity.x = 600
		else:
			body.velocity.x = -600


func _on_below_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		self.stun(3)
		self.velocity.y = -500
		if randi() % 2 == 1:
			self.velocity.x = 600
		else:
			self.velocity.x = -600
# --
# --
# --
# --- Process ---
func _process(delta: float) -> void:
	if stuned:
		return
	elif is_idle:
		action()


func _physics_process(delta):
	$GravityComponent.handle_gravity(self, delta) # Applique la gravité
	if is_following:
		follow_timer += delta
		
		# Gestion des Layers
		if target.collision_layer > self.collision_layer and can_go_deeper and not tried_jump_switch:
			change_layer(layer + 1)
		if target.collision_layer < self.collision_layer and can_go_closer and not tried_jump_switch and layer != 0:
			change_layer(layer - 1)
		
		# Calculer direction et mouvement
		var direction_x = sign(target.position.x - position.x)
		velocity.x = direction_x * speed # Que le x sinon on annule la gravité en écrasant la valeur en y
		
		if tried_jump:
			if can_go_closer and layer != 0:
				change_layer(layer - 1)
			elif can_go_deeper:
				change_layer(layer + 1)
		
		# Gestion des problèmes de boss coincé
		var horizontal_speed = abs(global_position.x - last_position.x) / delta # abs(x) = |x|
		if horizontal_speed < 5:  # presque pas de mouvement
			stuck_timer += delta
			if stuck_timer >= stuck_check_delay and not tried_jump: # Si on attend trop longtemps et qu'on a pas déjà essayé, on saute
				$JumpComponent.handle_jump(self, true)
				tried_jump = true 
			if stuck_timer >= 4 and tried_jump: # Bloqué depuis trop longtemps (Urgence)
				self.velocity.y = -500
				self.velocity.x = direction_x * -500 # on va dans le sens inverse pour pas s'exploser contre l'obstacle
		else:	# Quand on bouge on reset tout et c'est plus coincé
			stuck_timer = 0.0
			tried_jump = false
			tried_jump_switch = false

		# Activer la bonne collision de jump
		if direction_x == 1:
			$JumpLeft.hide()
			$JumpRight.show()
		else:
			$JumpLeft.show()
			$JumpRight.hide()

		# Calculer la distance parcourue depuis la dernière frame
		distance_traveled += global_position.distance_to(last_position)
		last_position = global_position

		# Conditions d'arrêt
		if (follow_timer >= following_time or distance_traveled >= following_distance) and is_on_floor():
			stop_follow()

	move_and_slide()

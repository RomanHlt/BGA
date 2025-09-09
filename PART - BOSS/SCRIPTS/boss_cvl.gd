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
# --
# --
# --
# --- Variables internes  ---
@onready var target : CharacterBody2D 		# Cible du boss
@onready var health = health_max			# Vie max
@onready var stuned = false					# Boss stuned ?
# Suivi
@onready var following_time = 0 			# Temps max pour follow le joueur, on arrête de le follow après
@onready var following_distance = 0			# Distance max de suivi, on arrête de courir après l'avoir parcourue
@onready var follow_timer = 0.0				# Temps max pendant lequel le boss suit le joueur (choisi aléatoirement dans la fonction follow)
@onready var distance_traveled = 0.0		# Distance max " " "
# Deplacement
@onready var direction_x					# -1 gauche, 1 droite
@onready var last_position = Vector2.ZERO	# Dernière position du boss
@onready var Layers							# Listes des layers
# Variables d'état
@onready var is_idle = true				# Ne fait rien
@onready var is_attacking = false		# Attaque (Corps à corps, tir, magie)
@onready var is_following = false		# Suit la cible
@onready var is_using_capacity = false	# Utilise une capacité (Hors attaque : heal, tp, bouclier)
@onready var lvl_evolution = 1			# Niveau d'évolution/Numéro de la phase
@onready var is_dead = false
# Attaques
@onready var dashing = false
# --- Variables spécifiques (A un boss précis) ---
# --
# --
# --
# --- ready ---
func _ready() -> void:
	z_index = -layer
	collision_layer = 2**layer
	collision_mask = 2**layer
	$Above.collision_mask = 2**layer
	$Below.collision_mask = 2**layer
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
	var actions = ["attack", "follow"] # Actions possible, à modifier selon les boss et selon les conditions en temps réel
	#var actions = ["attack", "flop"]# Ligne debug, reelle au dessus
	if not target:
		while "attack" in actions:
			actions.erase("attack")
		while "follow" in actions:
			actions.erase("follow")
	
	if actions == []:
		actions = ["Idle"]
	
	var action = pick_random_action(actions)
	if action == "attack":
		attack()
	if action == "follow":
		follow()

func pick_random_action(actions: Array) -> String:
	"""Renvoie une action au hasard"""
	return actions[randi() % actions.size()]


func attack():
	"""Choisi quel type d'attaque utiliser"""
	is_idle = false
	is_attacking = true
	var attacks = ["dash", "long"]
	var choice = pick_random_action(attacks)
	if choice == "dash":
		dash()
	else:
		long()


func _takeDamages(damages):
	if damages <= health:
		health -= damages
		# Retirer les dégats à la barre de vie du boss
	else:
		health = 0
		# Retirer les dégats à la barre de vie du boss
		is_dead = true
		dead()
	evolve() # Au cas où on change de phase
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
	following_time = randi_range(1, 3)
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
	layer = l
	self.position.y+=1 #Eviter que les checker ne detectent plus de collisions (patch de brute)
	$Above.collision_mask = 2**l
	$Below.collision_mask = 2**l
	# Rajouter toutes les areas s'ils y en a +


# - Attaques/capas -
func dash():
	print("dash")
	await get_tree().create_timer(1).timeout
	direction_x = sign(target.position.x - position.x)
	dashing = true
	if direction_x == 1:
		$meleeRight.collision_mask = 2**layer
	else:
		$meleeLeft.collision_mask = 2**layer
	velocity.x = direction_x * (speed + 300) # Dash en dur on s'en fou il est utilisé que ici
	while dashing:
		await get_tree().create_timer(0.16).timeout
	velocity.x = 0
	$meleeLeft.collision_mask = 0
	$meleeRight.collision_mask = 0


func long():
	print("Eboulement")
	await get_tree().create_timer(3).timeout
	for i in range(100):
		var scene = preload("res://PART - OBJECTS/SCENES/dangerousrock.tscn")
		var child = scene.instantiate()
		child.position = Vector2(randi_range(-1012, 1025), randi_range(-2324, -1416))
		get_parent().get_parent().add_child(child)


	is_attacking = false
	is_idle = true

func stop_follow():
	is_following = false
	velocity = Vector2.ZERO
	is_idle = true

func dead():
	is_idle = false
	is_following = false
	is_using_capacity = false
	is_attacking = false
	$Above.hide()
	$Below.hide()
	self.velocity = Vector2.ZERO
	# attendre que l'animation de mort se joue dans handle_animation()
	self.queue_free()
	# Faire spawn une récompense etc

# - Collisions -

func _on_melee_left_body_entered(body: Node2D) -> void:
	if dashing:
		if body.name == "Player":
			#animer l'attaque à gauche
			target._takeDamages(2)
			target.stun(2)
			target.velocity.y = -600
			target.velocity.x = -600
			stun(0.5)
		elif body.name =="TileMapLayer":
			print(body, body.name)
			stun(3)
		dashing = false

func _on_melee_right_body_entered(body: Node2D) -> void:
	if dashing:
		if body.name == "Player":
			#animer l'attaque à droite
			target._takeDamages(2)
			target.stun(2)
			target.velocity.y = -600
			target.velocity.x = 600
			stun(0.5)
			dashing = false
		elif body.name =="TileMapLayer":
			print(body, body.name)
			stun(3)
			dashing = false
		
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
	handle_animation()
	if stuned:
		return
	elif is_idle:
		action()


func _physics_process(delta):
	$GravityComponent.handle_gravity(self, delta) # Applique la gravité
	if is_following:
		follow_timer += delta

		# Calculer direction et mouvement
		direction_x = sign(target.position.x - position.x)
		velocity.x = direction_x * speed # Que le x sinon on annule la gravité en écrasant la valeur en y

		# Gestion des problèmes de boss coincé
		var horizontal_speed = abs(global_position.x - last_position.x) / delta # abs(x) = |x|

		# Calculer la distance parcourue depuis la dernière frame
		distance_traveled += global_position.distance_to(last_position)
		last_position = global_position

		# Conditions d'arrêt
		if (follow_timer >= following_time or distance_traveled >= following_distance or global_position.distance_to(target.global_position) < 25) and is_on_floor():
			stop_follow()
			
			
	move_and_slide()

# --- Animation ---
func handle_animation():
	"""Toutes les animations"""
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	pass # Replace with function body.

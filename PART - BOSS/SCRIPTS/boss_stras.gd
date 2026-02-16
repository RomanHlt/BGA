extends CharacterBody2D

@export_category("Global details")
@export var sprite:Sprite2D
@export var target : CharacterBody2D 		# Cible du boss
@export var tilemap1 : TileMapLayer
@export var TL : Marker2D
@export var TR : Marker2D
@export var BL : Marker2D
@export var BR : Marker2D
@export var LeftUpPath : PathFollow2D
@export var RightUpPath : PathFollow2D
@export var LeftBombePath : PathFollow2D
@export var RightBombePath : PathFollow2D

@export_category("Boss specificity")
@export var health_max = 10 			# Vie du boss
@export var speed = 0.2
# --
# --
# --
# --- Variables internes  ---
@onready var health = health_max			# Vie max
var in_R_to_L = false
var in_L_to_R = false
var in_backdash = false
var dir = 1
# Variables d'état
@onready var is_idle = true				# Ne fait rien
@onready var is_attacking = false		# Attaque (Corps à corps, tir, magie)
@onready var is_bombing = false 		# Attaque bombe
@onready var lvl_evolution = 2			# Niveau d'évolution/Numéro de la phase
@onready var is_dead = false
# --- Variables spécifiques
# --
# --
# --
# --- ready ---
func _ready() -> void:
	$Sprite2D.flip_h = true
# --
# --
# --
# --- Actions internes (Prendre dégat, évoluer, choix des actions, ...) ---
func action():
	"""Choisi l'action à faire en fonction de certains paramètres et de l'état (idle, attacking, ...) du boss."""
	#var actions = ["pic","pic","backdash","bombe","bombe"] # Actions possible, à modifier selon les boss et selon les conditions en temps réel
	var actions = ["backdash"] # Test
	
	if not target:
		while "pic" in actions:
			actions.erase("pic")
		while "bombe" in actions:
			actions.erase("bombe")
	if lvl_evolution == 1:
		while "backdash" in actions:
			actions.erase("backdash")
	
	var action = pick_random_action(actions)
	print(action)
	await get_tree().create_timer(1.5).timeout
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
	is_idle = false
	is_attacking = true
	
	# Détruire les fallingrocks
	for child in tilemap1.get_children():
		if child is Fallingrock:
			child.break_rock()
	
	await get_tree().create_timer(2).timeout
	
	if self.global_position.distance_to(TL.global_position) < 5.0:
		$AnimationPlayer.play("début piquet")
		await $AnimationPlayer.animation_finished
		self.global_position = BR.global_position
		if in_L_to_R:
			target._takeDamages(1) 
			target.velocity.y = -800
		$AnimationPlayer.play("redressage")
		RightUpPath.progress_ratio = 0
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play("vol montant")
		while RightUpPath.progress_ratio < 0.99:
			RightUpPath.progress_ratio += speed * get_process_delta_time()
			await get_tree().process_frame
		self.global_position = TR.global_position
		$AnimationPlayer.play("vol stationnaire")
		$Sprite2D.flip_h = false
		is_idle = true
		is_attacking = false
	
	elif self.global_position.distance_to(TR.global_position) < 5.0:
		$AnimationPlayer.play("début piquet")
		await $AnimationPlayer.animation_finished
		self.global_position = BL.global_position
		if in_R_to_L:
			target._takeDamages(1)
			target.velocity.y = -800
		$AnimationPlayer.play("redressage")
		LeftUpPath.progress_ratio = 0
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play("vol montant")
		while LeftUpPath.progress_ratio < 0.99:
			LeftUpPath.progress_ratio += speed * get_process_delta_time()
			await get_tree().process_frame
		self.global_position = TL.global_position
		$AnimationPlayer.play("vol stationnaire")
		$Sprite2D.flip_h = true
		is_idle = true
		is_attacking = false


func bombe():
	if is_bombing:
		return
	var vect : Vector2
	if self.global_position.distance_to(TR.global_position) < 5.0:
		RightBombePath.progress_ratio = 0
		dir = -1
		vect = Vector2(-30, -10)
	elif self.global_position.distance_to(TL.global_position) < 5.0:
		LeftBombePath.progress_ratio = 0
		dir = 1
		vect = Vector2(30, -10)
	await get_tree().process_frame
	is_attacking = true
	is_bombing = true
	is_idle = false
	$AnimationPlayer.play("Largage")
	while is_bombing:
		await get_tree().create_timer(0.15).timeout
		if not is_bombing:
			break
		var scene = preload("res://PART - BOSS/SCENES/boss_stras_bombe.tscn")
		var child = scene.instantiate()
		child.position = self.position - vect
		tilemap1.add_child(child)
	$AnimationPlayer.play("vol stationnaire")

func backdash():
	set_physics_process(true) #opti
	is_attacking = true
	is_idle = false
	self.velocity.y = -350
	$AnimationPlayer.play("vol montant")
	await get_tree().create_timer(2).timeout
	self.velocity.y = 0
	$BackDash.show()
	$AnimationPlayer.stop()
	$AnimationPlayer.play("Backdash")
	await get_tree().create_timer(2).timeout
	self.scale.x = 0.25
	self.scale.y = 0.25
	self.global_position = target.global_position + Vector2(0, -100)
	

	while self.scale.x < 1.5:
		await get_tree().process_frame
		self.scale.x += 1.3 * get_process_delta_time()
		self.scale.y += 1.3 * get_process_delta_time()
	
	self.z_index = 10
	if in_backdash:
		target._takeDamages(2)
		target.velocity = Vector2(0, -500)
	$BackDash.hide()
	
	while self.scale.x < 2.5:
		await get_tree().process_frame
		self.scale.x += 2 * get_process_delta_time()
		self.scale.y += 2 * get_process_delta_time()
	
	$AnimationPlayer.play("Avant")
	self.velocity.y = -750
	while self.scale.x < 3.5:
		await get_tree().process_frame
		self.scale.x += 2.8 * get_process_delta_time()
		self.scale.y += 2.8 * get_process_delta_time()
	
	self.global_position = TR.global_position + Vector2(0, -500)
	self.scale.x = 1.5
	self.scale.y = 1.5
	$AnimationPlayer.play("vol stationnaire")
	self.z_index = 0
	$Sprite2D.flip_h = false
	self.velocity.y = 200
	while self.global_position.distance_to(TR.global_position) > 5.0:
		await get_tree().process_frame
	self.velocity.y = 0
	set_physics_process(false) #opti
	self.global_position = TR.global_position
	is_idle = true
	is_attacking = false
	

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
		is_idle = false
		action()
	if is_bombing:
		if dir == 1:
			LeftBombePath.progress_ratio += speed * delta
		elif dir == -1:
			RightBombePath.progress_ratio += speed * delta
		
		if LeftBombePath.progress_ratio > 0.99 and dir == 1:
			LeftBombePath.progress_ratio = 1.0
			self.global_position = TR.global_position
			$Sprite2D.flip_h = false
			is_bombing = false
			is_attacking = false
			is_idle = true
		if RightBombePath.progress_ratio > 0.99 and dir == -1:
			RightBombePath.progress_ratio = 1.0
			self.global_position = TL.global_position
			$Sprite2D.flip_h = true
			is_bombing = false
			is_attacking = false
			is_idle = true

func _physics_process(delta: float) -> void:
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


# Backdash attaque
func _on_back_dash_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		in_backdash = true

func _on_back_dash_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		in_backdash = false

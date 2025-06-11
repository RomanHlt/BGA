extends Node2D

@export_category("Self Settings")
@export var layer : int
@export var damage : float = 50

@onready var on_area = false			# Le joueur est dans la zone de la spear (Zone rouge dans le debug)
@onready var is_up = false				# La spear est en position haute
@onready var running = false			# La spear est entrain d'attaquer
@onready var timer = 0.0				# Timer lancer au début de l'animation
@onready var target : CharacterBody2D	# Cible (qui sera le joueur)
@onready var is_first_touch_up = true	# Première fois qu'on touche le joueur en montant (pour eviter de prendre un coup/frame)
@onready var is_first_touch_down = true	# Pareil en decente


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	"""Mettre toute les collisions au bon layer"""
	$AnimatableBody2D.collision_layer = 2**layer
	$AnimatableBody2D.collision_mask = 2**layer
	$AnimatableBody2D/Dps2.collision_layer = 2**layer
	$AnimatableBody2D/Dps2.collision_mask = 2**layer
	$AnimatableBody2D/Spear_up.collision_layer = 2**layer
	$AnimatableBody2D/Spear_up.collision_mask = 2**layer
	$AnimatableBody2D/Spear_base.collision_layer = 2**layer
	$AnimatableBody2D/Spear_base.collision_mask = 2**layer

func _process(delta: float) -> void:
	if running:
		timer += delta * 1000.0  # convertit en ms
		
	if timer >= 420.0 and timer <= 1700.0: # Le spike est en haut dans l'animation à ce moment là
		is_up = true
	else:	# Le spike est en bas sinon
		is_up = false
		
	if timer >= 410.0 and timer <= 430.0 and on_area and is_first_touch_up: # Si le spike est entrain de monter et que le joueur est dans la zone et que on l'a pas déjà touché
		target._takeDamages(damage)
		is_first_touch_up = false
		
	if timer >= 1690 and timer <= 1710 and on_area and is_first_touch_down: # Si le spike est entrain de descendre et ...
		is_first_touch_down = false
		target._takeDamages(damage)

func _on_dps_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		target = body	# Le joueur devient la cible
		on_area = true	# Il rentre dans la zone
		if not running:	# Si l'attaque n'est pas déjà en cours on attaque
			running = true
			$Spikeplayer.play("Pik")
			await get_tree().create_timer(0.4).timeout
			$AudioStreamPlayer.play()
			await get_tree().create_timer(1).timeout
			$AudioStreamPlayer.play()

func _on_dps_2_body_exited(body: Node2D) -> void:
	"""Zone rouge dans le debug"""
	if body.name == "Player":
		on_area = false


func _on_spear_base_body_entered(body: Node2D) -> void:
	"""Zone rose en bas"""
	if body.name == "Player" and not is_up:
		body._takeDamages(damage)


func _on_spear_up_body_entered(body: Node2D) -> void:
	"""Zone rose en haut"""
	if body.name == "Player" and is_up:
		body._takeDamages(damage)

func _on_spikeplayer_animation_finished(anim_name: StringName) -> void:
	"""Reset timer / first_touch / running"""
	running = false
	is_first_touch_up = true
	is_first_touch_down = true
	timer = 0.0

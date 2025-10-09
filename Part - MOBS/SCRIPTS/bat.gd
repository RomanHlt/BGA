extends CharacterBody2D

@export_category("Nodes")
@export var layer:int = 0
@export var SPEED : float
@export var health_max : int = 3
var health : int
var animatedSprite:AnimatedSprite2D
var map
var direction: Vector2
var target : CharacterBody2D
var dir : float

var dead : bool = false
var is_sleeping : bool = true
var is_hurt : bool = false
var is_chasing : bool = false
var is_attacking : bool = false


func _ready() -> void:
	animatedSprite = _choose([$Fire, $Albino, $Root, $Standart, $Vampire, $Zombie])
	for child in get_children():
		if child.is_class("AnimatedSprite2D") and child.name != animatedSprite.name:
			child.hide()

	map = self.owner
	
	collision_layer = 2**layer
	collision_mask = 2**layer
	
	#l'area de detection du player et des dégats reçus est sur le meme layer que bat
	$DetectionPlayer.collision_mask = 2**layer
	$DetectionPlayer.collision_layer = 0
	
	$TakingDamage.collision_mask = 2**layer
	$TakingDamage.collision_layer = 0

	#l'area des dégats donnés est désactivée
	$AttackArea.collision_mask = 0

	health = health_max

func _choose(array):
	#on mélange l'array et on récupère le 1er élément
	array.shuffle()
	return array.front()
	

func _process(delta: float) -> void:
	_animation()
	_move(delta)
	
	move_and_slide()


func _move(delta):
	if is_sleeping or is_hurt or dead:
		velocity = Vector2(0,0)
	elif is_chasing:
		direction.x = sign(target.position.x - position.x)
		direction.y = sign(target.position.y - position.y)
		direction = Vector2(direction.x, direction.y)
		velocity = direction * SPEED * delta
	

func _animation():
	#orientation en fct de la direction
	if direction.x >= 0:
		animatedSprite.flip_h = false
	elif direction.x < 0:
		animatedSprite.flip_h = true
	
	#animation en fct des actions
	if !dead:
		if is_sleeping:
			animatedSprite.play("sleeping")
		elif is_attacking:
			animatedSprite.play("attack")
		elif is_hurt:
			animatedSprite.play("hurt")
			await (animatedSprite.animation_finished)
			is_hurt = false
		else :
			animatedSprite.play("flying")


func _on_taking_damage_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		_takes_damages(1)
		dir = _choose([-1, 1])
		target.velocity.x = dir*200
		target.velocity.y = -500


func _takes_damages(damages):
	health -= damages
	if health > 0 :
		is_hurt = true
	elif health <= 0: 
		dead = true
		_death()


func _death():
	if dead == true:
		animatedSprite.play("death")
		collision_layer = 0
		$AttackArea.collision_layer = 0
		await (animatedSprite.animation_finished)
		self.queue_free()


func _on_detection_player_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_sleeping =  false
		is_chasing = true
		target = body
		$AttackArea.collision_mask = 2**layer


func _on_detection_player_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_chasing = false
		$AttackArea.collision_mask = 0


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_chasing =  false
		is_attacking = true
		body._takeDamages(1)
		await get_tree().create_timer(1).timeout
		is_attacking = false
		dir = _choose([-1,1])
		velocity.x = dir * 10
		velocity.y = -10
		await get_tree().create_timer(1).timeout
		is_chasing = true

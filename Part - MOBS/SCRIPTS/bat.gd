extends CharacterBody2D

@export_category("Nodes")
@export var layer:int = 0
@export var SPEED : float
var animatedSprite:AnimatedSprite2D
var map
var direction: Vector2
var target : CharacterBody2D

var dead : bool = false
var is_sleeping : bool = true
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
	$DetectionPlayer.collision_layer = 2**layer
	
	$TakingDamage.collision_layer = 2**layer
	$TakingDamage.collision_mask = 2**layer
	
	#l'area des dégats donnés est désactivée
	$AttackArea.collision_mask = 0


func _choose(array):
	#on mélange l'array et on récupère le 1er élément
	array.shuffle()
	return array.front()
	

func _process(delta: float) -> void:
	_animation()
	_move(delta)
	
	move_and_slide()


func _move(delta):
	if is_sleeping or dead:
		velocity = Vector2(0,0)
	elif is_chasing:
		direction.x = sign(target.position.x - position.x)
		direction.y = sign(target.position.y - position.y)
		direction = Vector2(direction.x, direction.y)
		velocity = direction * SPEED * delta
	

func _animation():
	#orientation en fct de la direction
	if direction.x > 0:
		animatedSprite.flip_h = false
	elif direction.x < 0:
		animatedSprite.flip_h = true
	
	#animation en fct des actions
	if !dead:
		if is_sleeping:
			animatedSprite.play("sleeping")
		else:
			if is_chasing:
				animatedSprite.play("chasing")
			elif is_attacking:
				animatedSprite.play("attack")

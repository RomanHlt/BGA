extends CharacterBody2D

@export var SPEED : float
var direction : Vector2
var dead : bool = false
var taking_damage : bool = false
var is_attacking : bool = false
var is_chasing : bool = false
var is_sleeping : bool = true
@export_category("Nodes")
var map
@export var layer:int = 0
var animatedSprite:AnimatedSprite2D
var player : CharacterBody2D
var progress_ratio

func _ready() -> void:
	animatedSprite = _choose([$Zombie, $Root, $Fire, $Standart, $Vampire, $Albino])
	for child in get_children():
		if child.is_class("AnimatedSprite2D") and child.name != animatedSprite.name:
			child.hide()
	
	map = self.owner
	#z_index = -layer
	collision_mask = 2**layer
	collision_layer = 2**layer
	
	#l'area de detection du player est sur le meme layer que la chauve-souris
	$DetectionPlayer.collision_layer = 2**layer
	$DetectionPlayer.collision_mask = 2**layer
	
	#la collision shade des dégts est desactivée
	$AttackArea.collision_mask = 0


func _choose(array):
	array.shuffle()
	return array.front()

func _process(delta: float) -> void:
	_move(delta)
	_handle_animation()

func _move(delta):
	if is_sleeping:
		velocity = Vector2(0,0)
	if is_chasing or is_attacking:
		direction = position.direction_to(player.position) * SPEED
		direction.x = abs(direction.x)/direction.x
		velocity = direction * SPEED *delta

	move_and_slide()

func _handle_animation():
	if !dead or is_sleeping:
		animatedSprite.play("sleeping")
	elif !dead and !is_sleeping :
		#l'animation et la direction sont coérentes
		if direction.x == -1:
			animatedSprite.flip_h = true
		elif direction.x == 1:
			animatedSprite.flip_h = false
		
		#animation
		if !is_attacking:
			animatedSprite.play("flying")
		elif is_attacking:
			animatedSprite.play("attack")

func _on_detection_player_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_sleeping = false
		is_chasing = true
		player = body

func _on_detection_player_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_chasing = false

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_attacking = true
		_attack(body)

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_attacking = false
		$AttackArea.collision_layer = 0

func _attack(body: Node2D):
	$BatDealingDamage.collision_mask = 2**layer
	if body.name == "Player":
		body._takeDamages(1)

func _on_bat_taking_damage_area_entered(area: Area2D) -> void:
	if area.name == "PlayerDealingDamageZone":
		dead = true 
		_death()

func _death():
	dead = true
	animatedSprite.play("death")
	collision_layer = 0
	await (animatedSprite.animation_finished)
	self.queue_free()

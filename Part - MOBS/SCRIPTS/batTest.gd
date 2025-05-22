extends Path2D

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
@onready var pos_x = $PathFollow2D.position[0]
@onready var progress_ratio = $PathFollow2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animatedSprite = _choose([$PathFollow2D/Bat/Zombie, $PathFollow2D/Bat/Root, $PathFollow2D/Bat/Fire, $PathFollow2D/Bat/Standart, $PathFollow2D/Bat/Vampire, $PathFollow2D/Bat/Albino])
	for child in $PathFollow2D/Bat.get_children():
		if child.is_class("AnimatedSprite2D") and child.name != animatedSprite.name:
			child.hide()

	#z_index = -layer
	$PathFollow2D/Bat.collision_mask = 2**layer
	$PathFollow2D/Bat.collision_layer = 2**layer
	
	#l'area de detection du player est sur le meme layer que la chauve-souris
	$PathFollow2D/Bat/DetectionPlayer.collision_layer = 2**layer
	$PathFollow2D/Bat/DetectionPlayer.collision_mask = 2**layer
	
	#la collision shade des dégts est desactivée
	$PathFollow2D/Bat/AttackArea.collision_mask = 0

func _choose(array):
	array.shuffle()
	return array.front()


func _process(delta: float) -> void:
	_handle_animation()
	_move(delta)
	if $PathFollow2D.position[0] <= pos_x:
		animatedSprite.flip_h = true
	else:
		animatedSprite.flip_h = false
	pos_x = $PathFollow2D.position[0]
	
func _move(delta):
	if !is_sleeping and !is_attacking and !is_chasing and !dead:
		$PathFollow2D.progress_ratio+=delta*SPEED/100

func _handle_animation():
	if !dead or !is_sleeping:
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
	elif !dead and is_sleeping :
		animatedSprite.play("sleeping")

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
		is_attacking = false
		$AttackArea.collision_layer = 0

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_attacking = false
		$AttackArea.collision_layer = 0


func _on_taking_damage_area_entered(area: Area2D) -> void:
	if area.name == "PlayerDealingDamageZone":
		dead = true 
		_death()

func _death():
	dead = true
	is_attacking = false
	is_chasing = false
	is_sleeping = false
	animatedSprite.stop()
	animatedSprite.play("death")
	$PathFollow2D/Bat.collision_layer = 0
	$PathFollow2D/Bat/DetectionPlayer.collision_layer = 0
	$PathFollow2D/Bat/AttackArea.collision_layer = 0
	$PathFollow2D/Bat/AttackArea.collision_layer = 0
	await (animatedSprite.animation_finished)
	self.queue_free()

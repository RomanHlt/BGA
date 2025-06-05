extends CharacterBody2D

@export var SPEED : float
var direction : Vector2
var dead : bool = false
var taking_damage : bool = false
var is_attacking : bool = false
@export_category("Nodes")
@export var gravityComponent : GravityComponent
@onready var target : CharacterBody2D = self
var map
@export var layer:int = 0
var animatedSprite:AnimatedSprite2D
var player: CharacterBody2D
var on_area: bool = false

func _ready() -> void:
	animatedSprite = _choose([$BlueBrown, $BlueBlue, $GreenBlue, $GreenBrown, $PurpleWhite, $PurpleBlue])
	for child in get_children():
		if child.is_class("AnimatedSprite2D") and child.name != animatedSprite.name:
			child.hide()
	
	map = self.owner
	#z_index = -layer
	collision_mask = 2**layer
	collision_layer = 2**layer

	#la collision shade des dégats est desactivée
	$FrogDealingDamage.collision_mask = 0
	
	#l'area de detection du player est sur le meme layer que la grenouille
	$PlayerDetection.collision_layer = 2**layer
	$PlayerDetection.collision_mask = 2**layer

func _physics_process(delta: float) -> void:
	gravityComponent.handle_gravity(self, delta)
	
	move_and_slide()

func _process(delta: float) -> void:
	_move(delta)
	_handle_animation()
	
	move_and_slide()

func _move(delta):
	if !dead:
		velocity += direction * SPEED *delta
		
		#si attaque pas de mouvement
		if is_attacking:
			velocity.x = 0
	elif dead:
		velocity.x = 0

func _handle_animation():
	var anim_spire = animatedSprite
	#pour gérer le côté qu'elle regarde en fct de la direction
	if direction.x == -1:
		anim_spire.flip_h = true
	elif direction.x == 1:
		anim_spire.flip_h = false
	
	#animation en fct du mouvement
	if !dead and !direction.x == 0 and is_attacking == false:
		animatedSprite.play("jump")
	elif !dead and direction.x == 0 and is_attacking == false:
		animatedSprite.play("idle")
	elif !dead and is_attacking == true:
		animatedSprite.play("attack")

func _on_direction_timer_timeout() -> void:
	if !is_attacking:
		#la direction est randomisée pendant un certain tps random aussi
		$DirectionTimer.wait_time = _choose([1, 1.5, 2.0, 2.5])
		direction = _choose([Vector2.RIGHT, Vector2.LEFT, Vector2(0,0)])
		velocity = direction
	elif is_attacking:
		#seule la direction est choisi de manière random
		$DirectionTimer.wait_time = 0.5
		direction = _choose([Vector2.RIGHT, Vector2.LEFT])

func _choose(array):
	#on mélange l'array et on récupère le 1er élément
	array.shuffle()
	return array.front()


func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_attacking = true
		await get_tree().create_timer(0.3).timeout		#timer le temps que l'animation soit lancé
		$FrogDealingDamage.collision_mask = 2**layer	#activation de la zone de dégat

func _on_player_detection_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_attacking = false
		$FrogDealingDamage.collision_mask = 0		#désactivation de la zone de dégat

func _on_frog_taking_damage_area_entered(area: Area2D) -> void:
	if area.name == "PlayerDealingDamageZone":
		dead = true 
		_death()

func _death():
	dead = true
	animatedSprite.play("death")
	collision_layer = 0
	await (animatedSprite.animation_finished)
	self.queue_free()

func _on_frog_dealing_damage_body_entered(body: CharacterBody2D) -> void:
	if body.name == "Player":
		body._takeDamages(1)

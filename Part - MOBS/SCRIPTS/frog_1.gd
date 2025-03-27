extends CharacterBody2D

@export var SPEED : float
var direction : Vector2
var dead : bool = false
var taking_damage : bool = false
var is_attacking : bool = false
@export_category("Nodes")
@export var gravityComponent : GravityComponent
var map
@export var layer:int = 0
var animatedSprite:AnimatedSprite2D

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
		if is_attacking:
			velocity.x = 0
	elif dead:
		velocity.x = 0

func _handle_animation():
	var anim_spire = animatedSprite
	if !dead and !direction.x == 0 and is_attacking == false:
		animatedSprite.play("jump")
		if direction.x == -1:
			anim_spire.flip_h = true
		elif direction.x == 1:
			anim_spire.flip_h = false
	elif !dead and direction.x == 0 and is_attacking == false:
		animatedSprite.play("idle")
	elif !dead and is_attacking == true:
		animatedSprite.play("attack")


func _on_direction_timer_timeout() -> void:
	$DirectionTimer.wait_time = _choose([1.5, 2.0, 2.5])
	direction = _choose([Vector2.RIGHT, Vector2.LEFT, Vector2(0,0)])
	velocity = direction


func _choose(array):
	array.shuffle()
	return array.front()


func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_attacking = true
		_on_frog_dealing_damage_body_entered(body)

func _on_player_detection_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_attacking = false

func _attack(body):
	$FrogDealingDamage.collision_mask = 2**layer
	if body.name == "Player":
		body._takeDamages(1)

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
	_attack(body)

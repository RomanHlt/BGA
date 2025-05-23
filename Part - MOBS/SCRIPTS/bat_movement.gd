extends CharacterBody2D

var SPEED: float
var is_chasing:bool
var is_attacking: bool
var player : CharacterBody2D
var direction : Vector2
var dead: bool
var is_sleeping:bool
var animatedSprite: AnimatedSprite2D

func _process(delta: float) -> void:
	SPEED = get_parent().get_parent().SPEED
	is_chasing = get_parent().get_parent().is_chasing
	is_attacking = get_parent().get_parent().is_attacking
	player = get_parent().get_parent().player
	is_sleeping = get_parent().get_parent().is_sleeping
	animatedSprite = get_parent().get_parent().animatedSprite
	if is_chasing or is_attacking:
		velocity = position.direction_to(player.position) * SPEED
		direction.x = abs(velocity.x)/velocity.x
	else :
		velocity = Vector2(0,0)

	move_and_slide()

func _handle_animation():
	animatedSprite = get_parent().get_parent().animatedSprite
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

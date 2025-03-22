extends CharacterBody2D

@export var SPEED : float
var direction : Vector2
var dead : bool = false
var taking_damage : bool = false
@export_category("Nodes")
@export var gravityComponent : GravityComponent

var animatedSprite:AnimatedSprite2D

func _ready() -> void:
	animatedSprite = _choose([$BlueBrown, $BlueBlue, $GreenBlue, $GreenBrown, $PurpleWhite, $PurpleBlue])
	for child in get_children():
		if child.is_class("AnimatedSprite2D") and child.name != animatedSprite.name:
			child.hide()
	

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
	elif dead:
		velocity.x = 0

func _handle_animation():
	var anim_spire = animatedSprite
	if !dead and !direction.x == 0:
		animatedSprite.play("jump")
		if direction.x == -1:
			anim_spire.flip_h = true
		elif direction.x == 1:
			anim_spire.flip_h = false
	elif !dead and direction.x == 0:
		animatedSprite.play("idle")
	

func _on_direction_timer_timeout() -> void:
	$DirectionTimer.wait_time = _choose([1.5, 2.0, 2.5])
	direction = _choose([Vector2.RIGHT, Vector2.LEFT, Vector2(0,0)])
	velocity = direction
	

func _choose(array):
	array.shuffle()
	return array.front()


func _on_frog_taking_damage_area_entered(area: Area2D) -> void:
	if area.name == "PlayerDealingDamageZone":
		dead = true 
		_death()


func _on_frog_dealing_damage_area_entered(area: Area2D) -> void:
	if area.name == "PlayerCollision" and direction.x == 0:
		pass
		


func _death():
	dead = true
	animatedSprite.play("death")
	collision_layer = 0
	await (animatedSprite.animation_finished)
	self.queue_free()

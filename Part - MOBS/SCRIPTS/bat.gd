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
	

func _choose(array):
	array.shuffle()
	return array.front()

func _process(delta: float) -> void:
	_move(delta)
	_handle_animation()

func _move(delta):
	if !is_chasing:
		velocity += direction * SPEED * delta
	move_and_slide()

func _handle_animation():
	if !dead and !is_sleeping:
		animatedSprite.play("flying")
		if direction.x == -1:
			animatedSprite.flip_h = true
		elif direction.x == 1:
			animatedSprite.flip_h = false

func _on_detection_player_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_sleeping = false
		#is_chasing = true


func _on_direction_timer_timeout() -> void:
	$DirectionTimer.wait_time = _choose([0.3, 0.5, 0.7, 1.0])
	if is_chasing == false:
		direction = _choose([Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN, Vector2.UP])
		

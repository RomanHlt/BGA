extends CharacterBody2D

@export_subgroup("Nodes")
@export var speed: float
@export var gravityComponent : GravityComponent
@export var animator:AnimationPlayer
@export var layer: int
var dead: bool = false
var sleeping: bool = true
var attacking: bool = false
var see_player: bool = false
var walking: bool = false
var take_damage: bool = false
var direction: Vector2
var PV_max: int = 3
var PV: int
var player: CharacterBody2D
var target: CharacterBody2D = self
var map
var pt_ref : Node2D

func _ready() -> void:
	map = self.owner
	
	collision_layer = 2**layer
	collision_mask = 2**layer
	
	$PlayerDetection.collision_layer = 2**layer
	$PlayerDetection.collision_mask = 2**layer
	
	pt_ref = $Pt_ref

func _physics_process(delta: float) -> void:
	gravityComponent.handle_gravity(self, delta)
	move_and_slide()

func _process(delta: float) -> void:
	_move(delta)
	_animation()
	
	move_and_slide()

func _animation():
	if direction.x == -1:
		$Sprite2D.flip_h = false
	elif direction.x == 1 :
		$Sprite2D.flip_h = true
	
	if !dead:
		if sleeping:
			animator.play("chill")
		if walking:
			if is_on_wall():
				animator.play("jump")
			else:
				animator.play("walk")
		if take_damage:
			animator.play("hurt")
		if attacking:
			animator.play("attack")
	

func _move(delta:float):
	if !dead:
		
		if see_player:
			direction.x = sign(target.position.x - self.position.x)
			velocity = direction*speed
		elif attacking or sleeping:
			velocity.x = 0
		else :
			direction = (pt_ref.global_position - self.global_position).normalized()
			velocity = direction*speed*delta

func _on_player_detection_body_entered(body: CharacterBody2D) -> void:
	if body.name == "Player":
		sleeping = false
		see_player = true
		walking = true
		target = body

func _on_player_detection_body_exited(body: CharacterBody2D) -> void:
	if body.name == "Player":
		see_player = false

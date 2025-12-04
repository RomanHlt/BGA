extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -200.0
var jump:bool = false
var direction:int = 0
@export var layer:int = 0
var player:Player
var playerIn:bool = false
var exploding:bool = false

func _ready() -> void:
	collision_layer = 0
	collision_mask = 2**layer
	$Sprite2D.light_mask = 2**(layer+1)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if jump and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump = false

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if velocity.x >0:
		$AnimationPlayer.play("run")
		$Sprite2D.flip_h = false
	elif velocity.x < 0 :
		$AnimationPlayer.play("run")
		$Sprite2D.flip_h = true
	else:
		$AnimationPlayer.play("idle")
	
	if is_on_wall() and player != null and !exploding:
		explode()

	move_and_slide()

func explode():
	exploding = true
	$death.start()
	direction = 0
	jump = true
	await $death.timeout
	print("boom")
	player.camera.shake()
	if playerIn:
		player._takeDamages(1)
	queue_free()

func _on_detect_zone_body_entered(body: Node2D) -> void:
	if body is Player and !direction and !exploding:
		player = body
		velocity.y+= -100
		await get_tree().create_timer(0.1).timeout
		direction = int((body.global_position.x-global_position.x)/abs(body.global_position.x-global_position.x))


func _on_explode_body_entered(body: Node2D) -> void:
	if body is Player:
		explode()


func _on_damages_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		playerIn =true

func _on_damages_zone_body_exited(body: Node2D) -> void:
	if body is Player and !exploding:
		playerIn =false

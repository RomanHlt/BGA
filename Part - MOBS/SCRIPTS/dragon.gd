extends CharacterBody2D

var flame = preload("res://PART - MOBS/SCENES/dragon_flame.tscn")

@export var sprite:Sprite2D #??
@export var layer : int = 0

@onready var is_sleeping = true
@onready var target : CharacterBody2D = self
@onready var stop = false

func _ready() -> void:
	collision_layer = 2**layer
	collision_mask = 2**layer
	await get_tree().create_timer(1).timeout

func _process(delta: float) -> void:
	$GravityComponent.handle_gravity($".", delta) # Applique la gravité
	if is_sleeping: 
		$DragonAnimator.play("Idle_left")
		velocity[0] = 0 # Arreter son déplacement
	else:
		var direction = sign(target.position[0] - self.position[0]) # direction = 1 ou -1 en fonction de la position du joueur par rapport au mob
		velocity[0] = direction * 100 # Vitesse 100
	
	if velocity.length() > 0 and not is_sleeping: # Si le mob est en mouvement
		$Dragon.flip_h = velocity[0] > 0 #S'il bouge vers la droite on le fait tourner vers la droite sinon on le laisse à gauche
		$DragonAnimator.play("walk_left")

	move_and_slide()

func fire_left():
	var fire = flame.instantiate()
	add_child(fire)
	fire.collision_layer = collision_layer
	fire.collision_mask = collision_mask
	fire.z_index = z_index
	fire.position = Vector2(-25, 0)
	fire.anime("left")
	await stop
	fire.stop()


func fire_right():
	var fire2 = flame.instantiate()
	add_child(fire2)
	fire2.collision_layer = collision_layer
	fire2.collision_mask = collision_mask
	fire2.z_index = z_index
	fire2.position = Vector2(45, 0)
	fire2.anime("right")
	await stop
	fire2.stop()

func _on_detectionarea_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_sleeping = false
		target = body



func _on_detectionarea_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_sleeping = true


func _on_detectionleft_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		velocity[0] = 0
		stop = false
		fire_left()


func _on_detectionright_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		stop = false
		fire_right()


func _on_detectionleft_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		stop = true

func _on_detectionright_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		stop = true
